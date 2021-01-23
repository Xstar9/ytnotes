import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/widget/calendar_view.dart';

import 'package:ytnotes/entity/sign.dart';
import 'package:ytnotes/utils/sign_db_helper.dart';
import 'package:ytnotes/utils/tost_utils.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({
    Key key,
    @required this.signDbHelpter,
    this.id,
  }) : super(key: key);

  final SignDbHelper signDbHelpter;
  final int id;

  @override
  State<StatefulWidget> createState() {
    return _SigninPageState();
  }
}

class _SigninPageState extends State<SigninPage> with AutomaticKeepAliveClientMixin{
  bool issign = false;//签到标记 true为签到状态
  List<Sign> _signList = List();//从数据库获取签到数据

  int BeginTime;
  int ThisTime;
  int signday=0;

  CalendarController calendarController;

  @override
  void initState() {
    super.initState();
     //ThisTime = BeginTime+86400000;
    //int nowTime = DateTime.now().millisecondsSinceEpoch;
    //issign = nowTime>BeginTime&&nowTime<ThisTime ? false:true;
    // print(ThisTime);
    calendarController = CalendarController();
    // widget.signDbHelpter = SignDbHelper();
    //widget.signDbHelpter.open("/data/user/0/com.example.ytnotes/databases/signDb.db");
    widget.signDbHelpter.getDatabase().then((database) {
      database
          .query('sign')
          .then((List<Map<String, dynamic>> records) {

        _signList.clear();
        for (int i = 0; i < records.length; i++) {
            _signList.add(Sign.fromMap(records.elementAt(i)));
        }
        setState(() {});
      });
    });
    ///滑动日历监听
    calendarController.addMonthChangeListener(
          (year, month) {
        setState(() {});
      },
    );
    calendarController.addOnCalendarSelectListener((dateModel) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image:AssetImage("assets/bkg3.jpg"),
              fit:BoxFit.fill,
            )
        ),
        child:Column(
        children:[
          Container(
              margin: EdgeInsets.only(top: 10),
              child:Center(
                child: InkWell(
                  onTap: ()=> setState(() {
                    if(!issign){
                      issign = !issign;
                      Toast.show("打卡成功~");
                      signday+=1;
                    }else Toast.show("今天已打卡咯~");
                    signin(context);
                  }),
                  child:  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      issign == false ? "assets/signin.jpg":"assets/signed.jpg",
                      width: 120,
                      height: 120,
                    ),
                  ),),)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("本月已坚持打卡 ${signday} 天",style: TextStyle(fontSize: 15,color:Color.fromRGBO(149, 149, 148, 1)),)],),
          SizedBox(height: 10,),
          Expanded(
            child:CalendarViewWidget(
              calendarController: calendarController,
        )),

        ])
    );
  }

  void signin(BuildContext context) {

    Sign sign = Sign();
    if (widget.id != -1) {
      sign.id = widget.id;
      widget.signDbHelpter.update(sign);
    } else {
      widget.signDbHelpter.insert(sign);
    }
    sign.signintime = DateTime.now().millisecondsSinceEpoch;
    BeginTime = sign.signintime-1;
    if(!issign){
      sign.status = 1;
    } else{
      sign.status = 0;
    }
    widget.signDbHelpter.insert(sign);

    setState(() {});
    //Navigator.pop(context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
