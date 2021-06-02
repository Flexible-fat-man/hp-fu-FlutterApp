import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/page/iOSUpdate/IOSappUpdateTool.dart';

import '../../fm/componse/button/FmButton.dart';
import 'Invite.dart';
import 'Mine.dart';
import 'Performance.dart';
// 引入四个文件
import 'home.dart';

// 动态的Widget
class IndexPage extends StatefulWidget {
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bootomTabs = [
    BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: Image.asset(
          "images/ic_home_shouye.png",
          fit: BoxFit.fill,
          width: 21,
          height: 21,
        ),
        activeIcon: Image.asset(
          "images/ic_home_shouye_check.png",
          fit: BoxFit.fill,
          width: 22,
          height: 22,
        ),
        label: "首页"),
    BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: Image.asset(
          "images/ic_home_yeji.png",
          fit: BoxFit.fill,
          width: 21,
          height: 21,
        ),
        activeIcon: Image.asset(
          "images/ic_home_yeji_check.png",
          fit: BoxFit.fill,
          width: 22,
          height: 22,
        ),
        label: "业绩"),
    BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: Image.asset(
          "images/ic_home_yaoqing.png",
          fit: BoxFit.fill,
          width: 21,
          height: 21,
        ),
        activeIcon: Image.asset(
          "images/ic_home_yaoqing_check.png",
          fit: BoxFit.fill,
          width: 22,
          height: 22,
        ),
        label: "邀请"),
    BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: Image.asset(
          "images/ic_home_my.png",
          fit: BoxFit.fill,
          width: 21,
          height: 21,
        ),
        activeIcon: Image.asset(
          "images/ic_home_my_check.png",
          fit: BoxFit.fill,
          width: 22,
          height: 22,
        ),
        label: "我的"),
  ];
  final List tabBodies = [
    Home(),
    Performance(),
    Invite(),
    Mine(),
  ];
  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    // 检查更新
    FlutterXUpdate.checkUpdate(
        url: ApiHelper.version,
        overrideGlobalRetryStrategy: true,
        enableRetry: true,
        retryContent: "下载速度太慢了，是否考虑切换蒲公英下载？",
        retryUrl: "https://www.pgyer.com/dSsz");

    currentPage = tabBodies[currentIndex];
    IOSUpdateAlert();
    super.initState();
  }

  void IOSUpdateAlert() {
    if (Platform.isAndroid) {

    } else {
      IOSappUpdateTool.showUpdateAlertIfNeeded(context);
    }
  }

  // 弹窗确认是否安装更新
  Future<bool> showInstallUpdateDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("检测到新版本",
              style: TextStyle(color: ColorHelper.primaryText, fontSize: 16)),
          content: Text("已准备好更新，确认安装新版本?",
              style: TextStyle(color: ColorHelper.primaryText, fontSize: 14)),
          actions: <Widget>[
            Container(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      child: FmButton(
                    titleColor: ColorHelper.primaryText,
                    bgColor: Colors.transparent,
                    title: "取消",
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )),
                  Container(
                    width: 10,
                  ),
                  Expanded(
                      child: FmButton(
                    titleColor: ColorHelper.primaryText,
                    bgColor: Colors.transparent,
                    title: "确认",
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                  ))
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Color.fromARGB(244,25,5,1),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: ColorHelper.colorPrimary,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bootomTabs,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[currentIndex];
          });
        },
      ),
      body: currentPage,
    );
  }
}
