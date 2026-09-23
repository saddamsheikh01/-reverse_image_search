import 'package:flutter_test/flutter_test.dart';
import 'package:reverse_image_search/core/utils/url_validator.dart';

void main() {
  test('accepts valid https image urls', () {
    expect(UrlValidator.isValidHttpUrl('https://example.com/image.jpg'), isTrue);
    expect(UrlValidator.isSupportedImageUrl('https://cdn.example.com/photo.png'), isTrue);
  });

  test('rejects invalid or unsafe urls', () {
    expect(UrlValidator.isValidHttpUrl(''), isFalse);
    expect(UrlValidator.isValidHttpUrl('javascript:alert(1)'), isFalse);
    expect(UrlValidator.isValidHttpUrl('ftp://example.com/a.jpg'), isFalse);
    expect(UrlValidator.isValidHttpUrl('not a url'), isFalse);
  });

  test('extracts domain', () {
    expect(UrlValidator.domainOf('https://www.example.com/page'), 'example.com');
  });
}
