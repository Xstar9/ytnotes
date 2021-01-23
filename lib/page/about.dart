import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        title: Text('关于唷呔'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image:AssetImage("assets/bkg1.jpg"),
              fit:BoxFit.fill,
            )
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            FlutterLogo(
              size: 100.0,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15.0),
              padding: const EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
              constraints: BoxConstraints(
                  maxHeight: double.infinity,
                  minHeight: 50.0
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                    bottom: Divider.createBorderSide(
                        context, color: Colors.grey, width: 0.6),
                  )
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 150),
                child: Text(
                    '版本号 v1.0',
                  ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.only(left: 20.0,right: 20),
              child:Text(
              '应用简介：实现一个兼具简洁签到、记账功能的记事本。',
              style: TextStyle(fontSize: 16,color:Color.fromRGBO(149, 149, 148, 1),),
            ),
            ),
          SizedBox(height: 300,),
          Container(
          margin: const EdgeInsets.only(left: 15.0,right: 15),

            child:Text(
              "copyright© 2021 YTNotes All Right Reserved",
              style: TextStyle(color:Colors.grey,fontSize: 14),
            ),
        )],
        ),
      ),
    );
  }
}
