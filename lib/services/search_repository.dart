import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/search_response.dart';
import '../models/search_type.dart';
import 'serp_api_service.dart';

final serpApiServiceProvider = Provider<SerpApiService>((ref) {
  return SerpApiService();
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(serpApiServiceProvider));
});

class SearchRepository {
  SearchRepository(this._serpApi);

  final SerpApiService _serpApi;

  Future<SearchResponse> searchByUrl({
    required String url,
    required SearchType searchType,
  }) {
    return _serpApi.searchByUrl(url: url, searchType: searchType);
  }

  Future<SearchResponse> searchImage({
    String? imageUrl,
    File? file,
    required SearchType searchType,
  }) {
    if (file != null) {
      return _serpApi.searchFile(file: file, searchType: searchType);
    }
    return _serpApi.searchByUrl(url: imageUrl ?? '', searchType: searchType);
  }

  Future<SearchResponse> getSearch(String id) async {
    throw UnimplementedError('Saved search lookup is local-only.');
  }
}
