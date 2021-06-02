import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:package_info/package_info.dart';
import 'package:launch_review/launch_review.dart';

class IOSappUpdateTool {
  static showUpdateAlertIfNeeded(widgetContext) async {
    Response response;
    var dio = Dio();
    response = await dio.post(ApiHelper.version, data: {});
    String jsonStr = response.data.toString();

    var map = Map<String, dynamic>.from(jsonDecode(response.toString()));
    print(response.toString());
    print('-------------------------- iOS版本更新接口response:\n$map');

    String versionKey = 'VersionNameIOS';//IOS
    if (map.containsKey(versionKey)) {
      String versionNew = map[versionKey];

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String versionOld = packageInfo.version;

      bool hasNew = hasNewVersion(versionNew,versionOld);
      print('weather has new version:$hasNew');
      if (hasNew) {
        String content = '请更新App至最新版本';
        String contentKey = 'ModifyContentIOS';//IOS
        if (map.containsKey(contentKey)) {
          content = map[contentKey];
        }
        int force = 0;
        String forceKey = 'UpdateStatusIOS';//IOS
        if (map.containsKey(forceKey)) {
          force = map[forceKey];
        }
        _showDialog(widgetContext,content,force);
      }
      print('--------------------------最新版本:$versionNew，当前版本:$versionOld');
    }

    /**
        http://flm.zhengzhouwannengbang.com/index/Callback/version
        {
        ApkMd5 = "";
        ApkSize = 2048;
        Code = 0;
        DownloadUrl = "https://s9.pstatp.com/package/apk/news_article/1001_8270/news_article_juyouliang_toutiao_and1_v1001_8270_ff1e_1622186942.apk?v=1622186945";
        ModifyContent = "1\U3001\U4f18\U5316api\U63a5\U53e3\U3002
        \n2\U3001\U6dfb\U52a0\U4f7f\U7528demo\U6f14\U793a\U3002
        \n3\U3001\U65b0\U589e\U81ea\U5b9a\U4e49\U66f4\U65b0\U670d\U52a1API\U63a5\U53e3\U3002
        \n4\U3001\U4f18\U5316\U66f4\U65b0\U63d0\U793a\U754c\U9762\U3002";
        Msg = "";
        UpdateStatus = 0;
        VersionCode = 1;
        VersionName = "1.0.0";
        UpdateStatusIOS:0;
        VersionNameIOS:1.0.0;
        ModifyContentIOS:"更新内容";
        }
     */
  }

  static void _showDialog(widgetContext,content,force) {
    if (force == 0) {
      showCupertinoDialog(
        context: widgetContext,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('发现新版本'),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text('去更新'),
                onPressed: () {
                  updateApp();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: widgetContext,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('发现新版本'),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('去更新'),
                onPressed: () {
                  updateApp();
                },
              ),
            ],
          );
        },
      );
    }
  }

  static void updateApp() {
    LaunchReview.launch(androidAppId: "com.wannengbang.hpfuapp",
        iOSAppId: "1570188403",writeReview: false);
  }

  static bool hasNewVersion(String newVersion, String old) {
    if (newVersion == null || newVersion.isEmpty || old == null || old.isEmpty)
      return false;
    int newVersionInt, oldVersion;
    var newList = newVersion.split('.');
    var oldList = old.split('.');
    if (newList.length == 0 || oldList.length == 0) {
      return false;
    }
    for (int i = 0; i < newList.length; i++) {
      newVersionInt = int.parse(newList[i]);
      oldVersion = int.parse(oldList[i]);
      if (newVersionInt > oldVersion) {
        return true;
      } else if (newVersionInt < oldVersion) {
        return false;
      }
    }

    return false;
  }
}