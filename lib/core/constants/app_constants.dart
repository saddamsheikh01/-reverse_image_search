class AppConstants {
  AppConstants._();

  static const String appName = 'Deep Image Search';
  static const String packageName = 'com.reverseimagesearch.app';

  static const Duration splashDuration = Duration(milliseconds: 1600);
  static const Duration apiTimeout = Duration(seconds: 45);
  static const Duration connectTimeout = Duration(seconds: 20);

  static const int maxImageBytes = 25 * 1024 * 1024;
  static const int freeSearchLimit = 50;
  static const int proSearchLimit = 5000;
  static const int recentSearchLimit = 20;

  static const List<String> supportedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  static const List<String> supportedMimeTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
  ];

  static const String monthlyProductId = 'reverse_image_search_pro_monthly';
  static const String yearlyProductId = 'reverse_image_search_pro_yearly';

  static const String supportEmail = 'support@reverseimagesearch.app';
  static const String privacyUrl = 'https://reverseimagesearch.app/privacy';
  static const String termsUrl = 'https://reverseimagesearch.app/terms';
}

class AppEnv {
  AppEnv._();

  static const String flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'development',
  );

  static const String serpApiKey = String.fromEnvironment(
    'SERPAPI_KEY',
    defaultValue: '',
  );

  static bool get isProduction => flavor == 'production';
  static bool get isDevelopment => flavor == 'development';
  static bool get verboseLogging => !isProduction;
}
