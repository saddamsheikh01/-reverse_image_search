class UrlValidator {
  UrlValidator._();

  static final _httpUrl = RegExp(
    r'^https?:\/\/[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
  );

  static bool isValidHttpUrl(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return false;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return false;
    if (uri.scheme != 'http' && uri.scheme != 'https') return false;
    if (uri.host.isEmpty) return false;
    return _httpUrl.hasMatch(trimmed);
  }

  static bool isSupportedImageUrl(String? value) {
    if (!isValidHttpUrl(value)) return false;
    final path = Uri.parse(value!.trim()).path.toLowerCase();
    return path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.webp') ||
        path.contains('image') ||
        path.isNotEmpty;
  }

  static String? domainOf(String? url) {
    final uri = Uri.tryParse(url?.trim() ?? '');
    if (uri == null || uri.host.isEmpty) return null;
    return uri.host.replaceFirst(RegExp(r'^www\.'), '');
  }
}
