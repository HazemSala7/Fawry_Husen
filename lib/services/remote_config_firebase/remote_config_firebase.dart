import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseRemoteConfigClass {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final int cacheDuration = 86400; // 24 hours in seconds

  Future<String> initilizeConfig() async {
    return _getCachedOrFetch('season', _fetchSeason);
  }

  Future<String> getDomain() async {
    return _getCachedOrFetch('domain', _fetchDomain);
  }

  Future<String> getCategoryIDKey1() async {
    return _getCachedOrFetch('FeaturesUrl_1', _fetchCategoryIDKey1);
  }

  Future<String> getCategoryIDKey2() async {
    return _getCachedOrFetch('FeaturesUrl_2', _fetchCategoryIDKey2);
  }

  Future<String> getCategoryIDKey3() async {
    return _getCachedOrFetch('FeaturesUrl_3', _fetchCategoryIDKey3);
  }

  Future<String> getMenPrice() async {
    return _getCachedOrFetch('MenPrice', _fetchMenPrice);
  }

  Future<String> getOtherPrice() async {
    return _getCachedOrFetch('OtherPrice', _fetchOtherPrice);
  }

  Future<String> getWomenPrice() async {
    return _getCachedOrFetch('WomenPrice', _fetchWomenPrice);
  }

  Future<String> getBigPrice() async {
    return _getCachedOrFetch('BigPrice', _fetchBigPrice);
  }

  Future<String> getKidsPrice() async {
    return _getCachedOrFetch('KidsPrice', _fetchKidsPrice);
  }

  Future<String> _getCachedOrFetch(
      String key, Future<String> Function() fetchFunction) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Check if cache is valid
    final cachedTime = prefs.getInt('${key}_cache_time') ?? 0;
    if (currentTime - cachedTime < cacheDuration) {
      return prefs.getString(key) ?? '';
    }

    // Fetch from Firebase Remote Config
    final fetchedValue = await fetchFunction();

    // Save to cache
    prefs.setString(key, fetchedValue);
    prefs.setInt('${key}_cache_time', currentTime);

    return fetchedValue;
  }

  Future<String> _fetchSeason() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('season');
  }

  Future<String> _fetchDomain() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('domain');
  }

  Future<String> _fetchCategoryIDKey1() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('FeaturesUrl_1');
  }

  Future<String> _fetchCategoryIDKey2() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('FeaturesUrl_2');
  }

  Future<String> _fetchCategoryIDKey3() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('FeaturesUrl_3');
  }

  Future<String> _fetchKidsPrice() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('KidsPrice');
  }

  Future<String> _fetchMenPrice() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('MenPrice');
  }

  Future<String> _fetchOtherPrice() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('OtherPrice');
  }

  Future<String> _fetchWomenPrice() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('WomenPrice');
  }

  Future<String> _fetchBigPrice() async {
    await _configureRemoteConfig();
    return remoteConfig.getString('BigPrice');
  }

  Future<void> _configureRemoteConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 100),
        minimumFetchInterval: Duration(seconds: 100)));
    await remoteConfig.fetchAndActivate();
  }
}
