class Constant {
  static const String userAccount = 'user_account';
  static const String userPassword = 'user_password';

  static const String dbName = 'bddisk.db';
  static const int dbVersion = 1;
  static final String searchHistoryTable = 'search_history';

  static final String keyUserInfo = 'json_user_info';
  static final String keyDiskQuota = 'json_disk_quota';
  static final String keyBdOAuthToken = 'json_baiu_oauth2_token';

  /// Android Q api 29 开始Android系统使用沙盒，无法直接获取存储卡目录。
  ///
  /// 使用getExternalStorageDirectory 返回如：
  /// /storage/emulated/0/Android/data/cn.edu.swust.bddisk/files
  static const String defaultExternalStorageDirectoryPrefix = '/storage/emulated/0/Android/data/cn.edu.swust.baidudisk/files';//'/Android/data/';

  static String getFileSize(int fileSize, {int fixed = 2}) {
    String str = '';
    if (fileSize < 1024) {
      str = '${fileSize} B';
    } else if (1024 <= fileSize && fileSize < 1048576) {
      str = '${(fileSize / 1024).toStringAsFixed(fixed)} K';
    } else if (1048576 <= fileSize && fileSize < 1073741824) {
      str = '${(fileSize / 1048576).toStringAsFixed(fixed)} M';
    } else if (1073741824 <= fileSize) {
      str = '${(fileSize / 1073741824).toStringAsFixed(fixed)} G';
    }
    return str;
  }

  static String getDateTime(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

}
