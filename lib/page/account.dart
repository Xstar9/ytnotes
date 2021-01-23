import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ytnotes/entity/note.dart';
import 'package:ytnotes/utils/event_bus.dart';
import 'package:ytnotes/utils/note_db_helper.dart';
import 'package:ytnotes/utils/tost_utils.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key key,
    @required this.noteDbHelpter,
    @required this.id,
  }) : super(key: key);
  final NoteDbHelper noteDbHelpter;//数据库实例
  final int id;
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String notes = "";

  bool eat=true,shop=false,trip=false,salary=false;
  String _titleText = '';
  String _billText = '';
  String _noteText = '';
  var _titleController = TextEditingController();
  var _billController = TextEditingController();
  var _noteController = TextEditingController();

  Widget _buildTitleEditTextField(){
    return Container(
      margin: EdgeInsets.only(top: 10,left: 20,right: 20),
      child: TextField(
        controller: _titleController,// 绑定输入框接收对象
        onChanged: (text) {
          _titleText = text;
        },
        style: TextStyle(fontSize: 17),
        decoration: InputDecoration(
            hintText: '账单详情',
            filled: true,
            fillColor: Color.fromARGB(233, 233, 233, 240),
            contentPadding: EdgeInsets.only(left: 18),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,borderRadius: BorderRadius.circular(10)
            )
        ),
      ),
    );
  }

  Widget _buildBillEditTextField(){
    return Container(
      margin: EdgeInsets.only(top: 10,left: 20,right: 20),
      child: TextField(
        controller: _billController,// 绑定输入框接收对象
        onChanged: (text) {
          _billText = text;
        },
        style: TextStyle(fontSize: 17),
        decoration: InputDecoration(
            hintText: '收支金额(支出请输入-)',
            filled: true,
            fillColor: Color.fromARGB(233, 233, 233, 240),
            contentPadding: EdgeInsets.only(left: 18),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,borderRadius: BorderRadius.circular(10)
            )
        ),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly
        ],
      ),
    );
  }

  Widget _buildNoteEditTextField(){
    return Container(
      margin: EdgeInsets.only(top: 10,left: 20,right: 20),
      child: TextField(
        controller: _noteController,// 绑定输入框接收对象
        onChanged: (text) {
          _noteText = text;
        },
        style: TextStyle(fontSize: 17),
        decoration: InputDecoration(
            hintText: '备注',
            filled: true,
            fillColor: Color.fromARGB(233, 233, 233, 240),
            contentPadding: EdgeInsets.only(left: 18),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,borderRadius: BorderRadius.circular(10)
            )
        ),
      ),
    );
  }

  Widget _buildTypeItem() {
    return Row(
        children:[
          SizedBox(width: 30,),
          Text("类型：",style: TextStyle(fontSize: 17,color:Color.fromRGBO(149, 149, 148, 1))),
          SizedBox(width: 15,),
          InkWell(
            onTap: ()=> setState(() {eat=true;shop=false;trip=false;salary=false;}),
            child:Column(
              children: <Widget>[
                Icon(
                  eat==false?Icons.star_border:Icons.star,
                color: Colors.blue,
                size: 30,
              ),
              Text("餐饮",style: TextStyle(fontSize: 13,color:Color.fromRGBO(149, 149, 148, 1)))
             ],),),
          SizedBox(width: 30,),
          InkWell(
          onTap: ()=>setState(() {eat=false;shop=true;trip=false;salary=false;}),
          child:Column(
            children: <Widget>[
              Icon(
                shop==false?Icons.bookmark_border:Icons.bookmark,
                color: Colors.blue,
                size: 30,
              ),
              Text("购物",style: TextStyle(fontSize: 13,color:Color.fromRGBO(149, 149, 148, 1)))
            ],),),
          SizedBox(width: 30,),
          InkWell(
            onTap: ()=>setState(() {eat=false;shop=false;trip=true;salary=false;}),
            child:Column(
            children: <Widget>[
              Icon(
                trip==false?Icons.favorite_border:Icons.favorite,
                color: Colors.blue,
                size: 30,
              ),
              Text("差旅",style: TextStyle(fontSize: 13,color:Color.fromRGBO(149, 149, 148, 1)))
            ],),),
          SizedBox(width: 30,),
          InkWell(
          onTap: ()=>setState(() {eat=false;shop=false;trip=false;salary=true;}),
            child:Column(
              children: <Widget>[
              Icon(
                salary==false?Icons.hourglass_empty:Icons.hourglass_full,
                color: Colors.blue,
                size: 30,
              ),
              Text("收入",style: TextStyle(fontSize: 13,color:Color.fromRGBO(149, 149, 148, 1)),)
            ],),),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('日常记账'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "保存",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                save(context);
              },
              splashColor: Colors.white,
            )
          ],
        ),
        body:Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image:AssetImage("assets/bkg5.jpg"),
                fit:BoxFit.fill,
              )
          ),
            child:
            Column(
                children: [
                  SizedBox(height: 20,),
                  _buildTypeItem(),
                  _buildTitleEditTextField(),
                  _buildBillEditTextField(),
                  _buildNoteEditTextField(),
                ]),
        )
    );
  }

  void save(BuildContext context) {

    Toast.show("记账成功");
    Note note = Note();
    note.title = "记账日记";
    String type="";
    if(eat) type="餐饮";
    else if(shop) type="购物";
    else if(trip) type="差旅";
    else type="收入";
    note.content = "类型: ${type}\n标题:  ${_titleText}\n金额:  ${_billText}\n备注: ${_noteText}\n";
    note.time = DateTime.now().millisecondsSinceEpoch;
    note.star = 0;
    note.weather = 0;
    if (widget.id != -1) {
      note.id = widget.id;
      widget.noteDbHelpter.update(note);
    } else {
      widget.noteDbHelpter.insert(note);
      // 发送事件和数据 ,id为数据的索引
      eventBus.fire(NoteEvent(widget.id));
    }
    Navigator.pop(context);
  }

}