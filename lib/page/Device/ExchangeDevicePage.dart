import 'package:flutter/material.dart';
import 'package:hpfuapp/fm/components/card/FmCard.dart';
import 'package:hpfuapp/fm/components/cell/FmCell.dart';
import 'package:hpfuapp/fm/components/list/FmList.dart';
import 'package:hpfuapp/fm/components/wrap/FmWrap.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hpfuapp/helper/PrefixHelper.dart';
import 'package:hpfuapp/model/Device.dart';
import '../../helper/HttpHelper.dart';
import '../../model/Page.dart' as PageNew;

class ExchangeDevicePage extends StatefulWidget {
  @override
  _ExchangeDevicePageState createState() => _ExchangeDevicePageState();
}

class _ExchangeDevicePageState extends State<ExchangeDevicePage> {
  void onLogin() async {
    HttpHelper.post(ApiHelper.DeviceQuery, {},
        (Map<String, dynamic> data) async {
      var page = PageNew.Page.fromJson(data);

      print(page.totalCount);

      List<Device> l = page.list.map((e) => Device.fromJson(e)).toList();
      print(l.length);
    });
  }

  @override
  void initState() {
    super.initState();
    // onLogin();
  }

  Widget newCard1() {
    return Container(
        height: 185,
        margin: EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
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
              margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "0.00",
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
                    "当前兑换机具总台数(台)",
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
    return FmWrap.all(
      all: 0,
      child: FmCard(
          body: FmList(
        children: [
          FmCell(
              prefix: PrefixHelper.ic_mine_forme,
              title: "未激活",
              subtitle: '1222',
              isLink: true),
          FmCell(
              prefix: PrefixHelper.ic_mine_shezhi,
              title: "已激活",
              subtitle: '1222',
              isLink: true),
          FmCell(
              prefix: PrefixHelper.ic_mine_shezhi,
              title: "已划拨",
              subtitle: '1222',
              isLink: true),
          FmCell(
              prefix: PrefixHelper.ic_mine_shezhi,
              title: "已禁用",
              subtitle: '1222',
              isLink: true),
          FmCell(
              prefix: PrefixHelper.ic_mine_shezhi,
              title: "本级及下级已激活",
              subtitle: '1222',
              isLink: true),
        ],
      )),
    );
  }

  Widget setting1(BuildContext context) {
    return FmWrap.only(
      top: 15,
      bottom: 15,
      child: FmCard(
          body: FmList(
        children: [
          FmCell(
              prefix: PrefixHelper.ic_mine_forme,
              title: "申请设置VIP记录",
              isLink: true),
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
        body: Container(
          // decoration: new BoxDecoration(color: Color(0xffF5F5F5)),
          child: Column(
            children: <Widget>[
              newCard1(),
              setting(context),
              setting1(context),
            ],
          ),
        ));
  }
}
