import 'package:flutter_test/flutter_test.dart';
import 'package:reverse_image_search/models/search_type.dart';
import 'package:reverse_image_search/models/user_models.dart';
import 'package:reverse_image_search/services/feature_access_service.dart';

void main() {
  const access = FeatureAccessService();

  test('pro users receive premium features', () {
    expect(access.canAccess(PremiumFeature.adFree, isPro: true), isTrue);
    expect(access.canAccess(PremiumFeature.unlimitedSearch, isPro: true), isTrue);
  });

  test('free users do not get ad-free or unlimited search', () {
    expect(access.canAccess(PremiumFeature.adFree, isPro: false), isFalse);
    expect(access.canAccess(PremiumFeature.unlimitedSearch, isPro: false), isFalse);
  });

  test('quota blocks free users at the limit', () {
    expect(
      access.canSearch(
        const UsageStats(used: 50, limit: 50, remaining: 0, isPro: false),
      ),
      isFalse,
    );
    expect(
      access.canSearch(
        const UsageStats(used: 50, limit: 5000, remaining: 4950, isPro: true),
      ),
      isTrue,
    );
  });
}
