import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/storage_keys.dart';
import '../core/storage/local_storage.dart';
import '../models/favorite_item.dart';
import '../models/search_history_item.dart';
import '../models/search_response.dart';
import '../models/search_result.dart';
import '../models/user_models.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(ref.watch(localStorageProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(ref.watch(localStorageProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class HistoryRepository {
  HistoryRepository(this._storage);

  final LocalStorage _storage;

  Future<List<SearchHistoryItem>> list() async {
    return _storage
        .readJsonList(StorageKeys.localHistory)
        .map(SearchHistoryItem.fromJson)
        .toList();
  }

  Future<void> saveLocal(SearchHistoryItem item) async {
    final current = _storage.readJsonList(StorageKeys.localHistory);
    current.removeWhere((e) => e['id'] == item.id);
    current.insert(0, item.toJson());
    await _storage.writeJsonList(StorageKeys.localHistory, current.take(50).toList());
  }

  Future<void> saveResponse(SearchResponse response) async {
    final cache = _storage.readJsonList(StorageKeys.localSearchCache);
    cache.removeWhere((e) => e['searchId'] == response.searchId);
    cache.insert(0, response.toJson());
    await _storage.writeJsonList(StorageKeys.localSearchCache, cache.take(20).toList());
  }

  SearchResponse? getCached(String id) {
    final cache = _storage.readJsonList(StorageKeys.localSearchCache);
    for (final item in cache) {
      if (item['searchId']?.toString() == id) {
        return SearchResponse.fromJson(item);
      }
    }
    return null;
  }

  Future<void> delete(String id) async {
    final current = _storage.readJsonList(StorageKeys.localHistory)
      ..removeWhere((e) => e['id'] == id);
    await _storage.writeJsonList(StorageKeys.localHistory, current);
  }

  Future<void> clear() async {
    await _storage.writeJsonList(StorageKeys.localHistory, []);
    await _storage.writeJsonList(StorageKeys.localSearchCache, []);
    await _storage.writeJsonList(StorageKeys.recentSearches, []);
  }
}

class FavoritesRepository {
  FavoritesRepository(this._storage);

  final LocalStorage _storage;

  Future<List<FavoriteItem>> list() async {
    return _storage
        .readJsonList(StorageKeys.localFavorites)
        .map(FavoriteItem.fromJson)
        .toList();
  }

  Future<void> add(SearchResult result) async {
    final current = _storage.readJsonList(StorageKeys.localFavorites);
    current.removeWhere((e) => e['id'] == result.id || e['result']?['id'] == result.id);
    current.insert(
      0,
      FavoriteItem(id: result.id, result: result, createdAt: DateTime.now()).toJson(),
    );
    await _storage.writeJsonList(StorageKeys.localFavorites, current);
  }

  Future<void> remove(String id) async {
    final current = _storage.readJsonList(StorageKeys.localFavorites)
      ..removeWhere((e) => e['id'] == id || e['result']?['id'] == id);
    await _storage.writeJsonList(StorageKeys.localFavorites, current);
  }

  bool isFavorite(String id) {
    return _storage.readJsonList(StorageKeys.localFavorites).any(
          (e) => e['id'] == id || e['result']?['id'] == id,
        );
  }
}

class UserRepository {
  Future<UserProfile?> profile() async => null;

  Future<UsageStats> usage() async {
    return const UsageStats(used: 0, limit: 50, remaining: 50, isPro: false);
  }

  Future<SubscriptionInfo> subscription() async {
    return const SubscriptionInfo(isPro: false);
  }

  Future<SubscriptionInfo> verify(Map<String, dynamic> payload) async {
    return const SubscriptionInfo(isPro: false);
  }

  Future<void> deleteAccount() async {}
}
