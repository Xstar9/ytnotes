final String tableName = 'sign'; // 表名
final String columnId = '_id'; // 属性名
final String columnTime = "time"; //属性名
final String columnStatus = "status"; //属性名

//签到实体类
class Sign {
  int id;
  int signintime;//记录时间
  int status;//签到状态

  // 将实体对象类转为数据集合
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId:id,
      columnStatus:status,
      columnTime: signintime
    };
    return map;
  }

  // 构造方法/实例化方法
  Sign();

  // 通过数据集合返回一个实体对象
  Sign.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    status = map[columnStatus];
    signintime = map[columnTime];
  }
}