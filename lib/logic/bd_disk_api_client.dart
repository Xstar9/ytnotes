import 'dart:convert';
import 'dart:io';

import 'package:ytnotes/config/app_config.dart';
import 'package:ytnotes/model/bd_disk_quota.dart';
import 'package:ytnotes/model/bd_disk_user.dart';

class BdDiskApiClient {
  final HttpClient httpClient;

  final protocal = "https";
  final host = "pan.baidu.com";
  final userInfoPath = '/rest/2.0/xpan/nas';
  final diskQuotaPath = '/api/quota';
  final diskFilePath = '/rest/2.0/xpan/file';

  get accessToken async {
    var token = await AppConfig.instance.token;
    return token.accessToken;
  }

  BdDiskApiClient({HttpClient httpClient})
      : this.httpClient = httpClient ?? HttpClient();

  Future<BdDiskUser> getUserInfo() async {
    // Step 1: get HttpClientRequest
    HttpClientRequest request = await httpClient.getUrl(Uri.https(
        host,
        userInfoPath,
        {'method': 'uinfo', 'access_token': '${await accessToken}'}));
    // Step2: get HttpClientResponse
    HttpClientResponse response = await request.close();
    // Step3: consume HttpClientResponse
    var responseBody = await response.transform(Utf8Decoder()).join();
    // Stemp4: decode json response
    var json = jsonDecode(responseBody);

    return BdDiskUser.fromJson(json);
  }

  Future<BdDiskQuota> getDiskQuota() async {
    HttpClientRequest request = await httpClient.getUrl(Uri.https(
        host, diskQuotaPath, {'access_token': '${await accessToken}'}));

    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(Utf8Decoder()).join();
    var json = jsonDecode(responseBody);

    return BdDiskQuota.fromJson(json);
  }

  // Future<BdDiskQuota> createDiskFile() async {
  //   HttpClientRequest request = await httpClient.getUrl(Uri.https(
  //       host, diskFilePath, {'create': '${await accessToken}'}));
  //
  //   HttpClientResponse response = await request.close();
  //   var responseBody = await response.transform(Utf8Decoder()).join();
  //   var json = jsonDecode(responseBody);
  //
  //   return BdDiskQuota.fromJson(json);
  // }
}
