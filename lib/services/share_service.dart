import 'package:share_plus/share_plus.dart';

class ShareService {
  const ShareService();

  Future<void> shareResult({
    required String title,
    required String url,
  }) {
    return Share.share('$title\n$url');
  }
}
