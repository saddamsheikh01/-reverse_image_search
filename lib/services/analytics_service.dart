import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

class AnalyticsService {
  Future<void> log(String name, [Map<String, Object>? params]) async {}

  Future<void> appOpened() => log('app_opened');
  Future<void> languageSelected(String code) =>
      log('language_selected', {'language': code});
  Future<void> onboardingCompleted() => log('onboarding_completed');
  Future<void> galleryOpened() => log('gallery_opened');
  Future<void> cameraOpened() => log('camera_opened');
  Future<void> imageSelected() => log('image_selected');
  Future<void> imageCaptured() => log('image_captured');
  Future<void> imageEdited() => log('image_edited');
  Future<void> searchStarted(String type) =>
      log('search_started', {'search_type': type});
  Future<void> searchCompleted(String type, int count) =>
      log('search_completed', {'search_type': type, 'result_count': count});
  Future<void> searchFailed(String reason) =>
      log('search_failed', {'reason': reason});
  Future<void> resultOpened() => log('result_opened');
  Future<void> resultShared() => log('result_shared');
  Future<void> resultFavorited() => log('result_favorited');
  Future<void> historyOpened() => log('history_opened');
  Future<void> subscriptionViewed() => log('subscription_viewed');
  Future<void> subscriptionStarted() => log('subscription_started');
  Future<void> subscriptionRestored() => log('subscription_restored');
}
