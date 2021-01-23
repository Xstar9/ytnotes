import 'dart:io';

import 'package:ytnotes/config/constant.dart';
import 'package:ytnotes/model/bd_oauth2_token.dart';
import 'package:ytnotes/config/shared_preferences_extension.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

class AppConfig {
  factory AppConfig() => _getInstance();

  static AppConfig get instance => _getInstance();
  static AppConfig _instance;

  AppConfig._internal();

  static AppConfig _getInstance() {
    if (_instance == null) {
      _instance = new AppConfig._internal();
    }
    return _instance;
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String defaultFilesRootPath = '/';

  bool showAllFiles = false;

  static final String baiduClientId = 'HuRvLaPDUV04yZENLpmBKgRi';//'ZdZbev0SLGE31RarHcfNei8v';

  static final String baiduOAuth2Url =
        'https://openapi.baidu.com/oauth/2.0/authorize?response_type=token&redirect_uri=oob&display=mobile&client_id=HuRvLaPDUV04yZENLpmBKgRi&scope=basic%20netdisk';

  BdOAuth2Token _bdOAuth2Token;

  Future<BdOAuth2Token> get token async {
    if (_bdOAuth2Token != null) return _bdOAuth2Token;

    var prefs = await _prefs;
    if (!prefs.containsKey(Constant.keyBdOAuthToken)) return null;

    var json = prefs.getJson(Constant.keyBdOAuthToken);
    _bdOAuth2Token = BdOAuth2Token.fromJson(json);
    return _bdOAuth2Token;
  }

  void initApp() {
    requestPermissions();

    initUMeng();

    initBugly();
  }

  void initPlatformFileSystem() {
    Platform.isAndroid
        ? getExternalStorageDirectory().then((dir) {
            int endIndex = dir.path
                .indexOf(Constant.defaultExternalStorageDirectoryPrefix);
            if (endIndex > -1)
              AppConfig.instance.defaultFilesRootPath =
                  dir.path.substring(0, endIndex);
          })
        : getLibraryDirectory().then((dir) {
            AppConfig.instance.defaultFilesRootPath = dir.path;
          });
  }

  Future<bool> requestPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    List<bool> results = permissions.values.toList().map((status) {
      return status == PermissionStatus.granted;
    }).toList();

    return !results.contains(false);
  }

  initUMeng() {
    UmengAnalyticsPlugin.init(
      androidKey: '5e816573570df3ac010002b7',
      iosKey: '5e8165d30cafb280ef000281',
    );
  }

  initBugly() {
    FlutterBugly.init(
      androidAppId: "6b9e74e3eb",
      iOSAppId: "42fce847d9",
    );
  }
}
