class BdDiskQuota {
  int errno;
  int total;
  int requestId;
  bool expire;
  int used;

  /// 已使用空间占比：used / total
  double get percentage => ((used ?? 0) / (total ?? 1));

  BdDiskQuota({this.errno, this.total, this.requestId, this.expire, this.used});

  BdDiskQuota.fromJson(Map<String, dynamic> json) {
    errno = json['errno'];
    total = json['total'];
    requestId = json['request_id'];
    expire = json['expire'];
    used = json['used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errno'] = this.errno;
    data['total'] = this.total;
    data['request_id'] = this.requestId;
    data['expire'] = this.expire;
    data['used'] = this.used;
    return data;
  }
}
