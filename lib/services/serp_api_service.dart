import 'dart:io';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_constants.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/url_validator.dart';
import '../models/search_response.dart';
import '../models/search_result.dart';
import '../models/search_type.dart';

class SerpApiService {
  SerpApiService({Dio? dio}) : _dio = dio ?? Dio(
          BaseOptions(
            connectTimeout: AppConstants.connectTimeout,
            receiveTimeout: AppConstants.apiTimeout,
            sendTimeout: AppConstants.apiTimeout,
          ),
        );

  final Dio _dio;

  Future<SearchResponse> searchByUrl({
    required String url,
    required SearchType searchType,
  }) async {
    final imageUrl = url.trim();
    if (!UrlValidator.isValidHttpUrl(imageUrl)) {
      throw const AppException(
        code: AppErrorCode.validation,
        message: 'Please enter a valid image URL.',
      );
    }
    return _searchLens(imageUrl: imageUrl, searchType: searchType);
  }

  Future<SearchResponse> searchFile({
    required File file,
    required SearchType searchType,
  }) async {
    final hostedUrl = await _hostTemporaryImage(file);
    return _searchLens(imageUrl: hostedUrl, searchType: searchType);
  }

  Future<SearchResponse> _searchLens({
    required String imageUrl,
    required SearchType searchType,
  }) async {
    if (AppEnv.serpApiKey.isEmpty) {
      throw const AppException(
        code: AppErrorCode.unavailable,
        message: 'SerpApi key is missing. Pass --dart-define=SERPAPI_KEY=your_key',
      );
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://serpapi.com/search.json',
        queryParameters: {
          'engine': 'google_lens',
          'api_key': AppEnv.serpApiKey,
          'url': imageUrl,
          if (searchType != SearchType.aboutThisImage) 'type': searchType.apiValue,
        },
      );
      return normalize(response.data ?? const {}, imageUrl, searchType);
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) {
        throw const AppException(
          code: AppErrorCode.unauthorized,
          message: 'SerpApi rejected the request. Check SERPAPI_KEY.',
        );
      }
      if (status == 429) {
        throw const AppException(
          code: AppErrorCode.rateLimit,
          message: 'Search limit reached.',
        );
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        throw const AppException(
          code: AppErrorCode.network,
          message: 'Please check your connection and try again.',
        );
      }
      throw const AppException(
        code: AppErrorCode.unavailable,
        message: 'Search service is temporarily unavailable.',
      );
    }
  }

  Future<String> _hostTemporaryImage(File file) async {
    final filename = file.uri.pathSegments.isEmpty
        ? 'search.jpg'
        : file.uri.pathSegments.last;
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      throw const AppException(
        code: AppErrorCode.invalidImage,
        message: 'The selected image is empty.',
      );
    }

    final hosts = <Future<String> Function()>[
      () => _uploadCatbox(bytes, filename),
      () => _uploadTmpFiles(bytes, filename),
      () => _uploadZeroX(bytes, filename),
    ];

    AppException? lastError;
    for (final host in hosts) {
      try {
        final url = await host();
        if (UrlValidator.isValidHttpUrl(url)) return url;
      } on AppException catch (error) {
        lastError = error;
      } catch (_) {
        lastError = const AppException(
          code: AppErrorCode.invalidImage,
          message: 'Unable to upload this gallery image.',
        );
      }
    }
    throw lastError ??
        const AppException(
          code: AppErrorCode.invalidImage,
          message: 'Unable to prepare this image for search.',
        );
  }

  Future<String> _uploadCatbox(List<int> bytes, String filename) async {
    final response = await _dio.post<String>(
      'https://catbox.moe/user/api.php',
      data: FormData.fromMap({
        'reqtype': 'fileupload',
        'fileToUpload': MultipartFile.fromBytes(bytes, filename: filename),
      }),
      options: Options(responseType: ResponseType.plain),
    );
    final url = response.data?.trim() ?? '';
    if (!url.startsWith('http')) {
      throw const AppException(
        code: AppErrorCode.invalidImage,
        message: 'Unable to upload this gallery image.',
      );
    }
    return url;
  }

  Future<String> _uploadTmpFiles(List<int> bytes, String filename) async {
    final response = await _dio.post<Map<String, dynamic>>(
      'https://tmpfiles.org/api/v1/upload',
      data: FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      }),
    );
    final url = response.data?['data']?['url']?.toString() ?? '';
    if (url.isEmpty) {
      throw const AppException(
        code: AppErrorCode.invalidImage,
        message: 'Unable to upload this gallery image.',
      );
    }
    return url.replaceFirst('tmpfiles.org/', 'tmpfiles.org/dl/');
  }

  Future<String> _uploadZeroX(List<int> bytes, String filename) async {
    final response = await _dio.post<String>(
      'https://0x0.st',
      data: FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: filename),
      }),
      options: Options(
        responseType: ResponseType.plain,
        headers: {'User-Agent': 'DeepImageSearch/1.0'},
      ),
    );
    final url = response.data?.trim() ?? '';
    if (!url.startsWith('http')) {
      throw const AppException(
        code: AppErrorCode.invalidImage,
        message: 'Unable to upload this gallery image.',
      );
    }
    return url;
  }

  SearchResponse normalize(
    Map<String, dynamic> raw,
    String queryImage,
    SearchType searchType,
  ) {
    final visual = _list(raw['visual_matches']);
    final exact = _list(raw['exact_matches']);
    final products = _list(raw['shopping_results']).isNotEmpty
        ? _list(raw['shopping_results'])
        : visual.where((item) => item['price'] != null).toList();

    return SearchResponse(
      searchId: const Uuid().v4(),
      queryImage: queryImage,
      searchType: searchType,
      results: SearchResultsBundle(
        visualMatches: [
          for (var i = 0; i < visual.length; i++)
            _item(visual[i], 'visual_match', i),
        ],
        exactMatches: [
          for (var i = 0; i < exact.length; i++)
            _item(exact[i], 'exact_match', i),
        ],
        products: [
          for (var i = 0; i < products.length; i++)
            _item(products[i], 'product', i),
        ],
        aboutImage: _about(raw['knowledge_graph'] ?? raw['about_this_image'] ?? raw['image_sources']),
      ),
    );
  }

  SearchResult _item(Map<String, dynamic> item, String category, int index) {
    final sourceUrl = (item['link'] ?? item['source'] ?? item['url'] ?? '').toString();
    final price = item['price'];
    return SearchResult(
      id: item['position'] != null ? '${category}_${item['position']}' : '${category}_$index',
      title: (item['title'] ?? item['source'] ?? 'Untitled').toString(),
      category: category,
      thumbnail: item['thumbnail']?.toString() ?? item['image']?.toString(),
      imageUrl: item['image']?.toString() ?? item['original']?.toString() ?? item['thumbnail']?.toString(),
      sourceUrl: sourceUrl.isEmpty ? null : sourceUrl,
      sourceDomain: item['source']?.toString() ?? UrlValidator.domainOf(sourceUrl),
      description: item['snippet']?.toString() ?? item['title']?.toString(),
      price: price is Map ? price['value']?.toString() : price?.toString(),
      currency: price is Map ? price['currency']?.toString() : item['currency']?.toString(),
    );
  }

  AboutImageInfo? _about(dynamic raw) {
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    final websites = <String>[];
    final searches = <String>[];
    final sources = map['sources'];
    if (sources is List) {
      for (final item in sources.whereType<Map>()) {
        final link = item['link']?.toString();
        if (link != null && link.isNotEmpty) websites.add(link);
      }
    }
    final related = map['related_searches'];
    if (related is List) {
      for (final item in related) {
        if (item is Map) {
          searches.add((item['query'] ?? item['name'] ?? '').toString());
        } else {
          searches.add(item.toString());
        }
      }
    }
    final info = AboutImageInfo(
      summary: map['subtitle']?.toString() ?? map['title']?.toString() ?? map['description']?.toString(),
      possibleSource: map['source']?.toString() ?? (websites.isNotEmpty ? websites.first : null),
      relatedWebsites: websites,
      relatedSearches: searches.where((e) => e.isNotEmpty).toList(),
    );
    return info.hasContent ? info : null;
  }

  List<Map<String, dynamic>> _list(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
