import 'search_result.dart';

class FavoriteItem {
  const FavoriteItem({
    required this.id,
    required this.result,
    required this.createdAt,
  });

  final String id;
  final SearchResult result;
  final DateTime createdAt;

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id']?.toString() ?? json['result']?['id']?.toString() ?? '',
      result: SearchResult.fromJson(
        json['result'] is Map
            ? Map<String, dynamic>.from(json['result'] as Map)
            : json,
      ),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'result': result.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };
}
