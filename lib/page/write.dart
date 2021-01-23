import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ytnotes/entity/note.dart';
import 'package:ytnotes/utils/event_bus.dart';
import 'package:ytnotes/utils/note_db_helper.dart';
import 'package:ytnotes/utils/tost_utils.dart';

///编辑页
class WritePage extends StatefulWidget {

  const WritePage({
    Key key,
    @required this.noteDbHelpter,
    @required this.id,
  }) : super(key: key);

  final NoteDbHelper noteDbHelpter;//note数据库实例
  final int id; // 初值-1用于判断

  @override
  State<StatefulWidget> createState() {
    return WritePageState();
  }
}

class WritePageState extends State<WritePage> {
  String notes = "";//新建的记事页为空
  bool _isCollect = true; // false为收藏

  @override
  void initState() {
    super.initState();
    if (widget.id != -1) {
      widget.noteDbHelpter.getNoteById(widget.id).then((note) {
        setState(() {
          notes = note.content;
          _isCollect = note.star==1 ? false : true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(233, 233, 233, 1),
          title: Text("书写唷呔"),
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
          ],),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                    color: Colors.white,
                    constraints: BoxConstraints(
                       minHeight: MediaQuery.of(context).size.height,
                       minWidth: MediaQuery.of(context).size.width,
                    ),
                    padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 4.0),
                      child: TextField(
                        controller: TextEditingController.fromValue(TextEditingValue(
                      // 设置内容
                        text: notes,
                      // 保持光标在最后
                        selection: TextSelection.fromPosition(TextPosition(
                            affinity: TextAffinity.downstream,
                            offset: notes.length)))),
                    onChanged: (text) {
                    setState(() {
                      notes = text;
                    });
                  },
                  maxLines: null,
                  style: TextStyle(),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration.collapsed(
                    hintText: "点此记录你的时光",
                  ),
                ),
              )),
              Row(
                children: <Widget>[
                  Container(
                    child: IconButton(
                        icon: Icon(
                          Icons.wb_sunny,
                          color: Colors.grey,
                        ),
                        onPressed: () {}),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        _isCollect ? Icons.star_border : Icons.star,
                      ),
                      onPressed: () => setState(() {
                        _isCollect = !_isCollect;
                        Toast.show("收藏成功");
                      }),
                  ),)],
              )],
          ),
        ));
  }

  void save(BuildContext context) {
    if (notes.trim().length == 0) {
      Toast.show("不能为空");
      return;
    }
    Toast.show("唷呔已保存");
    Note note = Note();
    note.title = "时光笔记";
    note.content = notes;
    note.time = DateTime.now().millisecondsSinceEpoch;
    if(!_isCollect){
      note.star = 1;
    } else{
      note.star = 0;
    }
    note.weather = 0;
    if (widget.id != -1) {
        note.id = widget.id;
        widget.noteDbHelpter.update(note);
      } else {
        widget.noteDbHelpter.insert(note);
        // 发送事件、数据
        eventBus.fire(NoteEvent(widget.id));
      }
    Navigator.pop(context);
    }

  @override
  void dispose() {
    super.dispose();
  }

}
