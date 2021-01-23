import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ytnotes/config/constant.dart';
import 'package:ytnotes/logic/user_repository.dart';
import 'package:ytnotes/model/bd_disk_quota.dart';
import 'package:ytnotes/model/bd_disk_user.dart';
import 'package:ytnotes/page/everyday.dart';
import 'package:ytnotes/utils/note_db_helper.dart';
import 'package:ytnotes/utils/tost_utils.dart';

import 'about.dart';
import 'collect_page.dart';


class PersonalCenter extends StatefulWidget {
  NoteDbHelper noteDbHelpter;
  UserRepository userRepository;//用户信息缓存实例

  PersonalCenter({UserRepository userRepository,this.noteDbHelpter})
      : this.userRepository = userRepository ?? UserRepository();

  @override
  State<StatefulWidget> createState() => _PersonalCenterState();
}

class _PersonalCenterState extends State<PersonalCenter> {
  final _normalFont = const TextStyle(fontSize: 18.0,color:Color.fromRGBO(149, 149, 148, 1));

  final String authoremail = "yudp739@163.com";//反馈邮箱

  BdDiskUser _bdDiskUser;
  BdDiskQuota _bdDiskQuota;

  @override
  void initState() {
    _requestBdData();
  }

  void _requestBdData() {
    widget.userRepository
        .getUserInfo()
        .then((user) => setState(() => _bdDiskUser = user));
    widget.userRepository
        .getDiskQuota()
        .then((quota) => setState(() => _bdDiskQuota = quota));
  }


  Widget _cell(int row, IconData iconData, String title, bool isShowBottomLine) {//String describe
    return GestureDetector(
        onTap: () {
          _click(row);
      },
        child:InkWell(
          child: new Container(
            color: Color(0xFFFFFF),
            height: 55.0,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.all(0.0),
                    height: (isShowBottomLine ? 49.0 : 50.0),
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Container(
                            margin: new EdgeInsets.only(left: 15.0),
                            child: new Row(
                              children: <Widget>[
                                new Icon(iconData, color: Colors.orange),
                                new Container(
                                  margin: new EdgeInsets.only(left: 15.0),
                                  child: new Text(title, style: TextStyle(color: Color(0xFF777777), fontSize: 17.0)),
                                )
                              ],),
                          ),
                          new Container(
                            child: new Row(
                              children: <Widget>[
                                // new Text(describe, style: TextStyle(color: Color(0xFFD5A670), fontSize: 14.0)),
                                new Icon(Icons.keyboard_arrow_right, color: Color(0xFF777777)),
                              ],),
                          ),
                        ])),
                _bottomLine(isShowBottomLine),//底部线
              ],),
          ),),
      );
  }

  Widget _bottomLine(bool isShowBottomLine) {
    if (isShowBottomLine) {
      return new Container(
          margin: new EdgeInsets.all(0.0),
          child: new Divider(
              height: 1.0,
              color: Colors.black
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0)
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image:AssetImage("assets/bkg1.jpg"),
              fit:BoxFit.fitHeight,
            )
        ),
        //margin: EdgeInsets.only( top: 5),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30,),
            Row(
              children: <Widget>[

                ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/user-head.jpg',
                    image: _bdDiskUser?.avatarUrl ??
                        'https://ss0.bdstatic.com/7Ls0a8Sm1A5BphGlnYG'
                            '/sys/portrait/item/45c39016.jpg',
                    width: 64,
                    height: 64,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                    child: Container(
                      height: 55,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                _bdDiskUser?.baiduName ?? '',
                                style: _normalFont,
                              ),
                              SizedBox(width: 2),
                              Image.asset(
                                  'assets/user-level${_bdDiskUser?.vipType ?? 0}.png',
                                  height: 20,
                                  width: 20),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                            child: LinearProgressIndicator(
                              value: _bdDiskQuota?.percentage ?? 0.3,
                              backgroundColor: Colors.amberAccent,
                              valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          Text(
                            _bdDiskQuota == null || _bdDiskQuota.used == null
                                ? '加载中'
                                : '${Constant.getFileSize(_bdDiskQuota.used, fixed: 0)}B'
                                '/${Constant.getFileSize(_bdDiskQuota.total, fixed: 0)}B',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],),
                    )),
                ],),
            SizedBox(height: 50,),
            Container(
              //color: Colors.white70,
              height: MediaQuery.of(context).size.height-300,
              child: new ListView.builder(
                physics: new NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                 if (index == 0) {
                    return _cell(index, Icons.wb_sunny, "唷呔知识", true);
                  } else if (index ==1) {
                    return _cell(index, Icons.star, "收藏唷呔", true);
                  }  else if (index == 2) {
                    return _cell(index, Icons.settings_system_daydream, "唷呔换肤", true);
                  } else if (index == 3) {
                    return _cell(index, Icons.feedback, "反馈唷呔", true);
                  }  else if (index == 4) {
                    return _cell(index, Icons.people, "关于唷呔",  true);
                  } else {
                    return new Container(
                      height: MediaQuery.of(context).size.height-300,
                      color: Colors.white,
                    );
                  }
                },
                itemCount: 5,
              ),
            ),
          ],),
      ),
    );
  }

  //跳转
  void _launchURL() async {
    String url='mailto:'+authoremail;
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      print('不能访问');
      Toast.show("打开本地电子邮件失败~");
    }
  }

  //各选项点击事件
  void _click(int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EveryDay();
        }));
        break;
      case 1:
        widget.noteDbHelpter = NoteDbHelper();
        widget.noteDbHelpter.open("/data/user/0/com.example.ytnotes/databases/notesDb.db");
        widget.noteDbHelpter.getDatabase();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CollectPage(
            noteDbHelpter: widget.noteDbHelpter,
          );
        }));
        break;
      case 2:
        Toast.show("唷呔色彩正在收集中，敬请期待~");
        break;
      case 3:_launchURL();
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AboutPage();
        }));
        break;
    }
  }

}
