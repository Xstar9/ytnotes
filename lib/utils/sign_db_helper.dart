import 'package:ytnotes/entity/sign.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ytnotes/utils/time_utils.dart';

// 数据库操作工具类
class SignDbHelper {
  Database db;

  Future open(String path) async {
    // 打开/创建数据库
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $tableName (
          $columnId INTEGER PRIMARY KEY autoincrement, 
          $columnTime INTEGER not null,
          $columnStatus INTEGER not null)
          ''');
          print("Table is created------------------------------------------------------------------");
        });
  }

  Future<Database> getDatabase() async {
    Database database = await db;
    return database;
  }

  // 增加一条数据
  Future<Sign> insert(Sign sign) async {
    sign.id = await db.insert("sign", sign.toMap());
    return sign;
  }

  // 通过ID查询一条数据
  Future<Sign> getSignById(int id) async {
    List<Map> maps = await db.query('sign',
        columns: [
          columnId,
          columnStatus,
          columnTime,
        ],
        where: '_id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Sign.fromMap(maps.first);
    }
    return null;
  }


  Future<String> getSignOfLast(int begintime) async {
    List<Sign> _signList = List();
    List<Map> maps = await db.query('sign',
        columns: [
          columnId,
          columnStatus,
          columnTime,
        ],
        where: 'status = 1  ORDER BY time DESC',);
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        _signList.add(Sign.fromMap(maps.elementAt(i)));
      }
      DateTime datetime= DateTime.fromMicrosecondsSinceEpoch(_signList[0].signintime);
      return TimeUtils.getDateTime(datetime);
    }
    return null;
  }


  // 通过ID删除一条数据
  Future<int> deleteById(int id) async {
    return await db.delete('sign', where: '_id = ?', whereArgs: [id]);
  }

  // 更新数据
  Future<int> update(Sign sign) async {
    return await db
        .update('sign', sign.toMap(), where: '_id = ?', whereArgs: [sign.id]);
  }

  // 关闭数据库
  Future close() async => db.close();
}
