import 'package:ytnotes/config/app_config.dart';
import 'package:ytnotes/config/constant.dart';
import 'package:ytnotes/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ytnotes/page/bd_oauth2_page.dart';
import 'package:ytnotes/utils/event_bus.dart';

class LoginPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String _accountText = "";
  String _pwdText = "";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _acccontroller = TextEditingController();// 获取输入框输入
  var _pwdcontroller = TextEditingController();// 获取输入框输入

  final _biggerFont =
      const TextStyle(color:Colors.white,fontSize: 28.0,fontWeight: FontWeight.w500);
  final _smallerFont =
   const TextStyle(color:Colors.white,fontSize: 15.0, fontWeight: FontWeight.w500);
  final _normalFont = const TextStyle(fontSize: 18.0);
  final _borderRadius = BorderRadius.circular(40);

  bool _obscureText = true;
  bool _isEnableLogin = false;

  //顶部文字
  Widget _buildTopWidget(){
    return Container(
      margin: EdgeInsets.only(top: 70,left: 25),
      alignment: Alignment.topLeft,//文本顶部左端
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,// crossAxisAlignment交叉轴
        children: <Widget>[
          Text(
            'Welcome',
            style: _biggerFont,
          ),
          Text(
            '欢迎使用唷太日记',
            style: _smallerFont,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountEditTextField(){
    return Container(
      margin: EdgeInsets.only(top: 40,left: 20,right: 20),
      child: TextField(
        //controller: AccController,// 绑定输入框接收对象
        onChanged: (text) {
          _checkUserInput();
          _accountText = text;
        },
        style: _normalFont,
        decoration: InputDecoration(
            hintText: '请输入用户名/账号',
            filled: true,
            fillColor: Color.fromARGB(64, 240, 240, 240),
            contentPadding: EdgeInsets.only(left: 18),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,borderRadius: _borderRadius
            )
        ),
      ),
    );
  }

  Widget _buildPwdEditTextField(){
    return Container(
      margin: EdgeInsets.only(top: 15,left: 20,right: 20),
      //color: Colors.transparent,
      child: TextField(
        //controller: PwdController,// 绑定输入框接收对象
        onChanged: (text) {
          _checkUserInput();
          _pwdText = text;
        },
        style: _normalFont,
        obscureText: _obscureText,
        autofocus: false,
        decoration: InputDecoration(
            hintText: '请输入登录密码',
            filled: true,
            fillColor: Color.fromARGB(64, 240, 240, 240),
            contentPadding: EdgeInsets.only(left: 18),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,borderRadius: _borderRadius
            ),
            suffixIcon: IconButton(
              onPressed: ()=> setState(()=> _obscureText =! _obscureText),
              icon: Image.asset(
                _obscureText ? 'assets/hide.png' : 'assets/open.png', width: 20, height: 20,),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
        )),),
    );
  }

  Widget _buildLoginButton(){
    return Container(
      margin: EdgeInsets.only(top: 20,left: 100,right: 100),
      width: MediaQuery.of(context).size.width - 10,
      height: 40,
      child: RaisedButton(
        child: Text("登 录", style: _normalFont,),
        color: Colors.white38,
        disabledColor: Colors.white10,
        textColor: Colors.black54,
        disabledTextColor: Colors.black12,
        shape: RoundedRectangleBorder(
            borderRadius: _borderRadius
        ),
        onPressed: _getLoginButtonPressed(),
      ),
    );
  }

  Widget _buildOtherLoginButton() {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.only(top: 250,left: 100,right: 100),
        width: MediaQuery.of(context).size.width - 10,
        height: 40,
        child:OutlineButton(

          onPressed: _getOtherButtonPressed(),

          child: Text("使用百度云盘登录"),
          textColor: Colors.white70,
          splashColor: Colors.grey,
          highlightColor: Colors.white60,
          shape:RoundedRectangleBorder(
              borderRadius: _borderRadius
          ),
        ),
    );
  }

   _getOtherButtonPressed(){
     AppConfig.instance.initApp();
    return() async {
      var token = await AppConfig.instance.token;
      if (token == null || token.isExpired){
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) =>  BaiduOAuth2Page()),);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,//防止弹起键盘溢出
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text('LoginPage'),
      // ),
      body: Container(
        //margin: EdgeInsets.only(left: 25,right: 25),
        decoration: BoxDecoration(
          image: DecorationImage(
            image:AssetImage("assets/background.jpg"),
            fit:BoxFit.fitHeight,
          )
        ),
        child: Column(
          children: <Widget>[
            _buildTopWidget(),
            _buildAccountEditTextField(),
            _buildPwdEditTextField(),
            _buildLoginButton(),
            _buildOtherLoginButton()
          ],
        ))
    );
  }


  void _checkUserInput(){
    if(_accountText.isNotEmpty || _pwdText.isNotEmpty) {
      if (_isEnableLogin) return;
    }else{
      if(!_isEnableLogin) return;
    }
    setState(() {
      _isEnableLogin = !_isEnableLogin;
    });
  }

  _getLoginButtonPressed() {

    if(!_isEnableLogin) return null;

    return (){
    // async{
    //
    //   final SharedPreferences prefs = await _prefs;
    //   prefs.setString(Constant.userAccount, _accountText);
    //   prefs.setString(Constant.userPassword, _pwdText);
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) =>  MyHomePage()),);
    };
  }
  // @override
  // void initState() {
  //
  //   _prefs.then((prefs) {
  //       _accountText = prefs.getString(Constant.userAccount)??null;
  //       _acccontroller.text = _accountText;
  //       _pwdText = prefs.getString(Constant.userPassword)??null;
  //       _pwdcontroller.text = _pwdText;
  //       _checkUserInput();
  //   });
  // }

}
