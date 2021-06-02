import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:hpfuapp/utils/event_manager.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/http/lcfarm_log_interceptor.dart';

import 'helper/ApiHelper.dart';
import 'helper/ColorHelper.dart';
import 'page/LaunchPage.dart';
import 'router/RouterFluro.dart';

void main() {
  //初始化 Http，
  HttpManager().init(
    baseUrl: ApiHelper.base,
    interceptors: [
      LcfarmLogInterceptor(),
    ],
  );
  //加载路由
  RouterFluro.init();
  //运行
  runApp(MyApp());

  //修改状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  initXUpdate();
}

///初始化
void initXUpdate() {
  if (Platform.isAndroid) {
    FlutterXUpdate.init(

            ///是否输出日志
            debug: true,

            ///是否使用post请求
            isPost: false,

            ///post请求是否是上传json
            isPostJson: false,

            ///是否开启自动模式
            isWifiOnly: false,

            ///是否开启自动模式
            isAutoMode: false,

            ///需要设置的公共参数
            supportSilentInstall: false,

            ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
            enableRetry: false)
        .then((value) {})
        .catchError((error) {
      print(error);
    });
    FlutterXUpdate.setErrorHandler(
        onUpdateError: (Map<String, dynamic> message) async {
      print(message);
    });
  } else {

  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '付临门助手',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      theme: ThemeData(
          primaryColor: ColorHelper.colorPrimary,

          ///全局解决ios键盘默认颜色dark
          brightness: Brightness.light,
          primaryColorBrightness: Brightness.light,
          accentColorBrightness: Brightness.light),
      darkTheme: ThemeData(
        primaryColor: ColorHelper.colorPrimary,
        brightness: Brightness.light,
      ),
      home: LaunchPage(),
      builder: EasyLoading.init(),
    );
  }
}