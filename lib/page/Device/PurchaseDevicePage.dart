import 'package:flutter/material.dart';
import 'package:hpfuapp/fm/components/bottom/FmBottom.dart';
import 'package:hpfuapp/fm/componse/button/FmButton.dart';
import 'package:hpfuapp/fm/components/card/FmCard.dart';
import 'package:hpfuapp/fm/components/cell/FmCell.dart';
import 'package:hpfuapp/fm/components/list/FmList.dart';
import 'package:hpfuapp/fm/components/wrap/FmWrap.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hpfuapp/helper/PrefixHelper.dart';
import 'package:hpfuapp/model/DeviceStatistics.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';

class PurchaseDevicePage extends StatefulWidget {
  @override
  _PurchaseDevicePageState createState() => _PurchaseDevicePageState();
}

class _PurchaseDevicePageState extends State<PurchaseDevicePage> {
  DeviceStatistics deviceStatistics;
  DeviceStatistics deviceStatistics2;

  void _initData() {
    HttpManager().post(
      url: ApiHelper.DeviceStatisticByDevice,
      data: {"containType": '1'},
      successCallback: (data) {
        // List<Device> mList = page.list.map((e) => Device.fromJson(e)).toList();

        setState(() {
          deviceStatistics = DeviceStatistics.fromJson(data);
        });
      },
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
    HttpManager().post(
      url: ApiHelper.DeviceStatisticByDevice,
      data: {"containType": '2'},
      successCallback: (data) {
        // List<Device> mList = page.list.map((e) => Device.fromJson(e)).toList();

        setState(() {
          deviceStatistics2 = DeviceStatistics.fromJson(data);
        });
      },
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Widget newCard1() {
    return Container(
        height: 185,
        margin: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 0),
        //设置背景图片
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage(
              "images/ic_yeji_bg.png",
            ),
            fit: BoxFit.fill,
          ),
          boxShadow: [BoxShadow(color: Color(0x1a257efc), blurRadius: 3)],
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 0, top: 30, right: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    deviceStatistics == null
                        ? '0'
                        : deviceStatistics.all.toString(),
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 32,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "当前采购机具总台数(台)",
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget setting(BuildContext context) {
    return FmWrap.only(
      top: 15,
      left: 15,
      right: 15,
      child: FmCard(
//          header: FmCell(
//            prefix: PrefixHelper.ic_mine_forme,
//            title: '我的设备',
//          ),
          body: FmList(
        children: [
          FmCell(
            height: 60,
            prefix: PrefixHelper.ic_mine_forme,
            title: deviceStatistics == null
                ? '未激活未绑定'
                : deviceStatistics.unEnableAndUnBindText.toString(),
            subtitle: deviceStatistics == null
                ? '0'
                : deviceStatistics.unEnableAndUnBind.toString(),
            isLink: true,
            onTapCall: () => RouterFluro.navigateTo(context,
                "/NoActivationPage?enableStatus=2&bindStatus=2&containType=1"),
          ),
          FmCell(
            height: 60,
            prefix: PrefixHelper.ic_mine_shezhi,
            title: deviceStatistics == null
                ? '未激活已绑定'
                : deviceStatistics.unEnableAndBindText.toString(),
            subtitle: deviceStatistics == null
                ? '0'
                : deviceStatistics.unEnableAndBind.toString(),
            isLink: true,
            onTapCall: () => RouterFluro.navigateTo(context,
                "/ActivationPage?enableStatus=2&bindStatus=1&containType=1"),
          ),
          FmCell(
            height: 60,
            prefix: PrefixHelper.ic_mine_shezhi,
            title: deviceStatistics == null
                ? '已激活未绑定'
                : deviceStatistics.enableAndUnBindText.toString(),
            subtitle: deviceStatistics == null
                ? '0'
                : deviceStatistics.enableAndUnBind.toString(),
            isLink: true,
            onTapCall: () => RouterFluro.navigateTo(context,
                "/ActivationPage?enableStatus=1&bindStatus=2&containType=1"),
          ),
          FmCell(
            height: 60,
            prefix: PrefixHelper.ic_mine_shezhi,
            title: deviceStatistics == null
                ? '已激活已绑定'
                : deviceStatistics.enableAndBindText.toString(),
            subtitle: deviceStatistics == null
                ? '0'
                : deviceStatistics.enableAndBind.toString(),
            isLink: true,
            onTapCall: () => RouterFluro.navigateTo(context,
                "/ActivationPage?enableStatus=1&bindStatus=1&containType=1"),
          ),
          FmCell(
            height: 60,
            prefix: PrefixHelper.ic_mine_shezhi,
            title: deviceStatistics == null
                ? '所有'
                : deviceStatistics.allText.toString(),
            subtitle: deviceStatistics == null
                ? '0'
                : deviceStatistics.all.toString(),
            isLink: true,
            onTapCall: () => RouterFluro.navigateTo(context, "/ActivationPage?enableStatus=0&bindStatus=0&containType=1"),
          ),
        ],
      )),
    );
  }

  Widget setting1(BuildContext context) {
    return FmWrap.only(
      top: 15,
      left: 15,
      right: 15,
      child: FmCard(
          body: FmList(
        children: [
          FmCell(
            height: 60,
            prefix: PrefixHelper.ic_mine_shezhi,
            title: '我下级的机具',
            isLink: true,
            onTapCall: () => RouterFluro.navigateTo(context, "/TransferPage"),
          ),
        ],
      )),
    );
  }

  Widget listButton(BuildContext context) {
    return FmWrap.only(
      top: 15,
      left: 15,
      right: 15,
      child: FmCard(
          body: FmList(
            children: [
              FmCell(
                height: 60,
                prefix: PrefixHelper.ic_mine_shezhi,
                title: '划拨记录',
                isLink: true,
                onTapCall: () => RouterFluro.navigateTo(context, "/TransferRecordPage"),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          leading: GFIconButton(
            icon: Image.asset(
              "images/ic_back_black.png",
              fit: BoxFit.fill,
              width: 12,
              height: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            splashColor: Colors.transparent,
            disabledColor: Colors.transparent,
            highlightColor: Colors.transparent,
            type: GFButtonType.transparent,
          ),
          elevation: 0,
          brightness: Brightness.light,
          title: Text(
            "机具",
            style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        backgroundColor: ColorHelper.backgroundColor,
        body: SingleChildScrollView(
          // decoration: new BoxDecoration(color: Color(0xffF5F5F5)),
          child: Column(
            children: <Widget>[
              newCard1(),
              setting(context),
              setting1(context),
              listButton(context),
              Container(
                height: 50,
              )
            ],
          ),
        ));
  }
}

class FmBotton {}
