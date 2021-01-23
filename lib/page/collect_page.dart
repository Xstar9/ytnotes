import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ytnotes/config/constant.dart';
import 'package:ytnotes/entity/note.dart';
import 'package:ytnotes/page/read.dart';
import 'package:ytnotes/utils/event_bus.dart';
import 'package:ytnotes/utils/note_db_helper.dart';
import 'package:ytnotes/utils/time_utils.dart';


class CollectPage extends StatefulWidget {
  const CollectPage({
    Key key,
    @required this.noteDbHelpter,
  }) : super(key: key);

  final NoteDbHelper noteDbHelpter;

  @override
  State<StatefulWidget> createState() {
    return _CollectPageState();
  }
}

class _CollectPageState extends State<CollectPage> with AutomaticKeepAliveClientMixin{
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 5, keepScrollOffset: true);
  int _size = 0;
  List<Note> _noteList = List();
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    //获取数据库star=1即为收藏的数据初始化
    widget.noteDbHelpter.getDatabase().then((database) {
      database
          .query('notes', orderBy: 'time DESC')
          .then((List<Map<String, dynamic>> records) {
        _size = records.length;
        //print(_size);
        //print(records);
        _noteList.clear();
        for (int i = 0; i < records.length; i++) {
          if(records[i]['star']==1){
            print(records[i]['star']);
            _noteList.add(Note.fromMap(records.elementAt(i)));
          }
        }
        setState(() {
          _size = _noteList.length;
          print(_noteList.length);
        });
      });
    });
    _scrollController.addListener(() {
      ///滚动监听
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('收藏'),
        ),
        body:Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image:AssetImage("assets/bkg1.jpg"),
                  fit:BoxFit.fill,
                )
            ),
          child:
             ListView.builder(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              shrinkWrap: false,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(child:
                    _buildItem(index),
                 );
          },
          itemCount: _size
    )));
  }

  Widget _buildItem(int index) {
    var content = _noteList[index];
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return ReadPage(
                  id: _noteList.elementAt(index).id,
                  noteDbHelpter: widget.noteDbHelpter,
                );
              }));
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border:
            Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5))),
          ),
          child: ListTile(
            leading: Icon(Icons.star,color: Colors.lightBlue,),
            title: Text(content.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,style: TextStyle(color:Color.fromRGBO(149, 149, 148, 1)),),
            subtitle: Text('${Constant.getDateTime(content.time)}  ',style: TextStyle(color:Color.fromRGBO(149, 149, 148, 1)),
            ),),)
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  bool get wantKeepAlive => true;
  // _showBottomSheet(int index, BuildContext c) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return new Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             ListTile(
  //               leading: Icon(Icons.content_copy),
  //               title: Text("复制"),
  //               onTap: () async {
  //                 Clipboard.setData(
  //                     ClipboardData(text: _noteList.elementAt(index).content));
  //                 Scaffold.of(c).showSnackBar(SnackBar(
  //                   content: Text("已经复制到剪贴板"),
  //                   backgroundColor: Colors.black87,
  //                   duration: Duration(
  //                     seconds: 2,
  //                   ),
  //                 ));
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             ListTile(
  //               leading: Icon(Icons.delete_sweep),
  //               title: Text("删除"),
  //               onTap: () async {
  //                 widget.noteDbHelpter
  //                     .deleteById(_noteList.elementAt(index).id);
  //                 setState(() {
  //                   _noteList.removeAt(index);
  //                   _size = _noteList.length;
  //                 });
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }
}
