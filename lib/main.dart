import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ytnotes/page/account.dart';


import 'package:ytnotes/page/list.dart';
import 'package:ytnotes/page/login_page.dart';
import 'package:ytnotes/page/personal_center.dart';
import 'package:ytnotes/page/search.dart';
import 'package:ytnotes/page/sign_in_page.dart';
import 'package:ytnotes/page/write.dart';
import 'package:ytnotes/utils/note_db_helper.dart';
import 'package:ytnotes/utils/sign_db_helper.dart';
import 'package:ytnotes/utils/tost_utils.dart';

import 'config/app_config.dart';

// /data/user/0/com.example.ytnotes/databases+/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.instance.initApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child:
        MaterialApp(
          title: 'YTNotes',
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          home: LoginPage(),
        ),
        backgroundColor: Colors.black54,
        textPadding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.bottom);
  }
}


///safeArea  安全布局，适配不同的屏幕，防止顶部溢出
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  var _pageController = new PageController(initialPage: 0);
  int last = 0;
  int index = 0;

  NoteDbHelper noteDbHelpter;
  SignDbHelper signDbHelper;

  @override
  void initState() {
    super.initState();

    ///初始化数据库
    noteDbHelpter = NoteDbHelper();
    signDbHelper = SignDbHelper();
    getDatabasesPath().then((string) {
      String path = join(string, 'notesDb.db');
      noteDbHelpter.open(path);
    });
//获取数据库在本地的路径，然后拼接数据库
    getDatabasesPath().then((string) {
      String path = join(string, 'signDb.db');
      //print(path);
      signDbHelper.open(path);
    });
    _pageController.addListener(() {});
  }

  // 返回键拦截执行方法
  Future<bool> _onWillPop() {
    int now = DateTime.now().millisecondsSinceEpoch;
    print(now - last);
    if (now - last > 1000) {
      last = now;
      Toast.show("再按一次返回键退出");
      return Future.value(false); //不退出
    } else {
      return Future.value(true); //退出
    }
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope
    return WillPopScope(
      // 编写onWillPop逻辑
        onWillPop: _onWillPop,
        child: Material(
          child: SafeArea(
              child: Scaffold(
                appBar: PreferredSize(
                    child: Offstage(
                      offstage: _selectedIndex == 2 ? true : false,
                      child: AppBar(
                        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
                        title: Text('YTNotes'),
                        primary: true,
                        automaticallyImplyLeading: false,
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.search),
                            tooltip: '搜索',
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return SearchPage(
                                      noteDbHelpter: noteDbHelpter,
                                    );
                                  }));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.attach_money),
                            tooltip: '记账',
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return AccountPage(
                                      noteDbHelpter: noteDbHelpter,
                                      id: -1,);
                                  }));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            tooltip: '笔记',
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return WritePage(
                                      noteDbHelpter: noteDbHelpter,
                                      id: -1,
                                    );
                                  }));
                            },
                          ),
                        ],),
                    ),
                    preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.07)),
                // 绑定数据
                body: SafeArea(
                    child: PageView(
                      // 监听控制类
                      controller: _pageController,
                      onPageChanged: _onItemTapped,
                      physics: ScrollPhysics(),````````````````````
                      children: <Widget>[
                        ListPage(
                          noteDbHelpter: noteDbHelpter,
                        ),
                        SigninPage(signDbHelpter: signDbHelper),
                        PersonalCenter(noteDbHelpter: noteDbHelpter,),
                      ],
                    )),
                // 底部导航栏用CupertinoTabBar
                bottomNavigationBar: CupertinoTabBar(
                  // 导航集合
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        activeIcon: Icon(
                          Icons.event_note,
                          color: Colors.blue[300],
                        ),
                        icon: Icon(Icons.event_note),
                        title: Text('记录')),
                    BottomNavigationBarItem(
                        activeIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue[300],
                        ),
                        icon: Icon(Icons.calendar_today),
                        title: Text('日历')),
                    BottomNavigationBarItem(
                        activeIcon: Icon(
                          Icons.person,
                          color: Colors.blue[300],
                        ),
                        icon: Icon(Icons.person),
                        title: Text('我的')),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: setPageViewItemSelect,
                ),
              )),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 底部点击切换
  void setPageViewItemSelect(int indexSelect) {
    _pageController.animateToPage(indexSelect,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}