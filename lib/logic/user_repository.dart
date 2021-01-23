import 'package:ytnotes/config/constant.dart';
import 'package:ytnotes/model/bd_disk_quota.dart';
import 'package:ytnotes/model/bd_disk_user.dart';
import 'package:ytnotes/config/shared_preferences_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bd_disk_api_client.dart';

class UserRepository {
  final BdDiskApiClient apiClient;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  UserRepository({BdDiskApiClient apiClient})
      : this.apiClient = apiClient ?? BdDiskApiClient();

  /// 获取用户信息，网络异常时，返回缓存信息
  Future<BdDiskUser> getUserInfo() async {
    BdDiskUser user;
    var prefs = await _prefs;

    try {
      user = await apiClient.getUserInfo();
    } catch (e) {
      if (prefs.containsKey(Constant.keyUserInfo))
        return BdDiskUser.fromJson(prefs.getJson(Constant.keyUserInfo));
      return null;
    }

    prefs.setJson(Constant.keyUserInfo, user.toJson());
    return user;
  }

  /// 获取网盘信息，网络异常时，返回缓存信息
  Future<BdDiskQuota> getDiskQuota() async {
    var prefs = await _prefs;
    BdDiskQuota quota;

    try {
      quota = await apiClient.getDiskQuota();
    } catch (e) {
      if (prefs.containsKey(Constant.keyDiskQuota))
        return BdDiskQuota.fromJson(prefs.getJson(Constant.keyDiskQuota));
      return null;
    }

    prefs.setJson(Constant.keyDiskQuota, quota.toJson());
    return quota;
  }

}
