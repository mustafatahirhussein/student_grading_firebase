import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfiguration {

  final rc = FirebaseRemoteConfig.instance;

  Future<String> init() async {
    await rc.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 1),
      minimumFetchInterval: Duration(seconds: 1),
    ));
    await rc.fetchAndActivate();

    String response = rc.getString('remote_json');
    return response;
  }
}