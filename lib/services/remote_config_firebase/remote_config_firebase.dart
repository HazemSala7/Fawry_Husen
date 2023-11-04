import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigClass {
  final remoteConfig = FirebaseRemoteConfig.instance;
  Future initilizeConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 1),
        minimumFetchInterval: Duration(seconds: 1)));
    await remoteConfig.fetchAndActivate();
    var temp = remoteConfig.getString("season");
    return temp;
  }
}
