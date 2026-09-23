import 'package:url_launcher/url_launcher.dart';

import '../core/utils/url_validator.dart';

class UrlService {
  const UrlService();

  Future<bool> openExternal(String? raw) async {
    if (!UrlValidator.isValidHttpUrl(raw)) return false;
    final uri = Uri.parse(raw!.trim());
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<bool> openStore(String raw) async {
    final uri = Uri.parse(raw.trim());
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
