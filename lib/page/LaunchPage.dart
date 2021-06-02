//启动页面
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/page/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage/IndexPage.dart';

class LaunchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LaunchPageWidget();
  }
}

class LaunchPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LaunchState();
}

class LaunchState extends State<LaunchPageWidget> {
  int _countdown = 2;
  Timer _countdownTimer;
  var loginState;

  Future _validateLogin() async {
    Future<dynamic> future = Future(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("AccessToken");
    });
    future.then((val) {
      if (val == null || val == "") {
        setState(() {
          loginState = 0;
        });
      } else {
        setState(() {
          loginState = 1;
        });
      }
    }).catchError((_) {
      print("catchError");
    });
  }

  @override
  void initState() {
    super.initState();
    _validateLogin();
    _startRecordTime();
    print('初始化启动页面');
  }

  @override
  void dispose() {
    super.dispose();
    print('启动页面结束');
    if (_countdownTimer != null && _countdownTimer.isActive) {
      _countdownTimer.cancel();
    }
  }

  void _startRecordTime() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown <= 1) {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return initHome();
          }));
          _countdownTimer.cancel();
        } else {
          _countdown -= 1;
        }
      });
    });
  }

  Widget initHome() {
    if (loginState == 0) {
      return LoginPage();
    } else {
      return IndexPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
      ),
      body: Column(
        children: <Widget>[
          new Expanded(child: Text("")),
          new Row(
            children: <Widget>[
              new Expanded(child: Text("")),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "images/ic_splash_logo.png",
                  fit: BoxFit.fill,
                  width: 80,
                  height: 80,
                ),
              ),
              new Expanded(child: Text("")),
            ],
          ),
          new Container(
            height: 80,
          ),
        ],
      ),
    );
  }
}
