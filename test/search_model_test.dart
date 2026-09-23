import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:reverse_image_search/models/search_response.dart';
import 'package:reverse_image_search/models/search_type.dart';

void main() {
  test('parses visual match fixtures', () {
    final json = jsonDecode(
      File('test/fixtures/visual_matches.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final response = SearchResponse.fromJson(json);
    expect(response.searchType, SearchType.visualMatches);
    expect(response.results.visualMatches, isNotEmpty);
    expect(response.results.visualMatches.first.sourceDomain, 'example.com');
    expect(response.results.isEmpty, isFalse);
  });

  test('parses product fixtures', () {
    final json = jsonDecode(
      File('test/fixtures/products.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final response = SearchResponse.fromJson(json);
    expect(response.results.products.first.price, '\$49.99');
    expect(response.results.products.first.isProduct, isTrue);
  });

  test('empty results stay empty', () {
    final json = jsonDecode(
      File('test/fixtures/no_results.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final response = SearchResponse.fromJson(json);
    expect(response.results.isEmpty, isTrue);
  });
}
