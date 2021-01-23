import 'dart:async';

import 'package:ytnotes/config/app_config.dart';
import 'package:ytnotes/config/constant.dart';
import 'package:ytnotes/model/bd_oauth2_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';
import '../config/shared_preferences_extension.dart';


class BaiduOAuth2Page extends StatefulWidget{
  @override
  State createState() {
    return _BaiduOAuth2PageState();
  }
}


class _BaiduOAuth2PageState extends State<BaiduOAuth2Page> {
  WebViewController _controller;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('百度账户授权登录'),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: AppConfig.baiduOAuth2Url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          onPageFinished: (String url) {
            print('onPageFinished : $url');
            _checkOAuth2Result(context, url);
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }

  _checkOAuth2Result(BuildContext context, String url) async {
    url = url.replaceFirst('#', '?');
    Uri uri = Uri.parse(url);
    if (uri == null) return;

    if (uri.pathSegments.contains('login_success') &&
        uri.queryParameters.containsKey('access_token')) {
      var prefs = await _prefs;

      var token = BdOAuth2Token(uri.queryParameters['access_token'],
          expiresIn: int.parse(uri.queryParameters['expires_in']));
      prefs.setJson(Constant.keyBdOAuthToken, token.toJson());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }
}
