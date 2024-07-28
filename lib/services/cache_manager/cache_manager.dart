import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheManager {
  static const String _cacheKeyPrefix = 'api_cache_';
  static const Duration _cacheDuration = Duration(hours: 4);

  Future<void> setCache(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = DateTime.now().toIso8601String();
    final cacheData = {
      'timestamp': timestamp,
      'data': data,
    };
    prefs.setString(_cacheKeyPrefix + key, jsonEncode(cacheData));
  }

  Future<dynamic> getCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheString = prefs.getString(_cacheKeyPrefix + key);

    if (cacheString == null) {
      return null;
    }

    final cacheData = jsonDecode(cacheString);
    final cacheTimestamp = DateTime.parse(cacheData['timestamp']);
    final currentTime = DateTime.now();

    if (currentTime.difference(cacheTimestamp) > _cacheDuration) {
      return null;
    }

    return cacheData['data'];
  }
}
