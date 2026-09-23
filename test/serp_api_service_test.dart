import 'package:flutter_test/flutter_test.dart';
import 'package:reverse_image_search/models/search_type.dart';
import 'package:reverse_image_search/services/serp_api_service.dart';

void main() {
  test('normalizes Google Lens visual matches', () {
    final service = SerpApiService();
    final response = service.normalize(
      {
        'visual_matches': [
          {
            'position': 1,
            'title': 'Blue sneakers',
            'link': 'https://shop.example.com/shoes',
            'source': 'shop.example.com',
            'thumbnail': 'https://img.example.com/t.jpg',
            'image': 'https://img.example.com/full.jpg',
          },
        ],
        'exact_matches': [],
        'knowledge_graph': {
          'title': 'Sneakers',
          'source': 'example.com',
        },
      },
      'https://cdn.example.com/query.jpg',
      SearchType.all,
    );

    expect(response.queryImage, 'https://cdn.example.com/query.jpg');
    expect(response.results.visualMatches, hasLength(1));
    expect(response.results.visualMatches.first.title, 'Blue sneakers');
    expect(response.results.visualMatches.first.sourceDomain, 'shop.example.com');
    expect(response.results.aboutImage?.hasContent, isTrue);
  });
}
