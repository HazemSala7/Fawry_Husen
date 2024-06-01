import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigClass {
  final remoteConfig = FirebaseRemoteConfig.instance;
  Future initilizeConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 10)));
    await remoteConfig.fetchAndActivate();
    var temp = remoteConfig.getString("season");
    return temp;
  }

  Future getDomain() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 10)));
    await remoteConfig.fetchAndActivate();
    var temp = remoteConfig.getString("domain");
    return temp;
  }

  Future getCategoryIDKey1() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 10)));
    await remoteConfig.fetchAndActivate();
    var temp = remoteConfig.getString("FeaturesUrl_1");
    return temp;
  }

  Future getCategoryIDKey2() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 10)));
    await remoteConfig.fetchAndActivate();
    var temp = remoteConfig.getString("FeaturesUrl_2");
    return temp;
  }

  Future getCategoryIDKey3() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration(seconds: 10)));
    await remoteConfig.fetchAndActivate();
    var temp = remoteConfig.getString("FeaturesUrl_3");
    return temp;
  }
}
