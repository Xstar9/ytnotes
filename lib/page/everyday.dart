import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EveryDay extends StatefulWidget {
  @override
  EveryDayState createState() => EveryDayState();
}

class EveryDayState extends State<EveryDay>
    with SingleTickerProviderStateMixin {

  Map zhihuDaily = {'title': ''};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('唷呔知识'),),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image:AssetImage("assets/bkg1.jpg"),
                fit:BoxFit.fill,
              )
          ),
        child: _buildZhihuDaily(),
    ),
    );
  }

  _buildZhihuDaily() {
    final height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      child: SingleChildScrollView(
          child: Container(
              color: Colors.white70,
              height: height,
              padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
              alignment: Alignment.center,
              child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child:Text(
                        '下拉刷新页面~~~\n点击文字可进入页面~~~',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                    ),
                      Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.6),
                          child: InkWell(
                              child: Text(
                                zhihuDaily['title'],
                                style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 20,
                                  height: 1.3,
                                ),
                              ),
                              onTap: () => launch('https://daily.zhihu.com/story/' +
                                                    zhihuDaily["id"].toString())
                          ))],
                  )))),
      onRefresh: () async {
        _loadZhihuDaily();
      },
    );
  }

  _loadZhihuDaily() {
    getzhihuDaily().then((obj) {
      setState(() {
        zhihuDaily = obj;
      });
    });
  }

//请求数据
  Future<Map> getzhihuDaily() async {
    String url = "https://news-at.zhihu.com/api/4/news/latest";
    String body = await get(url);
    Map data = json.decode(body);
    List stories = data['stories'];
    stories.addAll(data['top_stories']);
    int index = new Random().nextInt(10);
    Map repo = stories[index];
    return repo;
  }

  Future<String> get(String url, {Map<String, String> params}) async {
    if (params != null && params.isNotEmpty) {
      // 如果参数不为空，则将参数拼接到URL后面
      StringBuffer stringBuffer = StringBuffer("?");
      params.forEach((key, value) {
        stringBuffer.write("$key" + "=" + "$value" + "&");
      });
      String paramStr = stringBuffer.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;//拼接
    }
    http.Response res = await http.get(url);
    return res.body;
  }

  @override
  void dispose() {
    super.dispose();
  }
}