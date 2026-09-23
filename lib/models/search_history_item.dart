import 'search_type.dart';

class SearchHistoryItem {
  const SearchHistoryItem({
    required this.id,
    required this.createdAt,
    required this.searchType,
    this.thumbnail,
    this.imageUrl,
    this.resultCount = 0,
  });

  final String id;
  final DateTime createdAt;
  final SearchType searchType;
  final String? thumbnail;
  final String? imageUrl;
  final int resultCount;

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['id']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      searchType: SearchType.fromValue(json['searchType']?.toString()),
      thumbnail: json['thumbnail']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      resultCount: int.tryParse(json['resultCount']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'searchType': searchType.apiValue,
        'thumbnail': thumbnail,
        'imageUrl': imageUrl,
        'resultCount': resultCount,
      };
}
