import 'package:flutter/material.dart';
import 'package:hpfuapp/fm/components/cell/FmCell.dart';
import 'package:hpfuapp/fm/components/list/FmList.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hpfuapp/router/RouterFluro.dart';

class DevicePage extends StatefulWidget {
  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  // Widget _getCardBlock(String text, double width, Color color) {
  //   return Container(
  //     width: width,
  //     height: 44,
  //     color: color,
  //     child: Center(
  //         child: Text(
  //       text,
  //       style: TextStyle(color: Colors.white),
  //     )),
  //   );
  // }

  // 头部card
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
                    "当前机具总台数(台)",
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

  // 采购机具and兑换机具
  Widget newCard2() {
    return Container(
        margin: EdgeInsets.only(left: 15, top: 30, right: 15, bottom: 0),
        // padding: EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 0),
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: FmList(
          children: [
            FmCell(
              title: "采购的机具",
              subtitle: "19434",
              isLink: true,
              onTapCall: () =>
                  RouterFluro.navigateTo(context, "/PurchaseDevicePage"),
            ),
            FmCell(
              title: "兑换的机具",
              subtitle: "2230",
              isLink: true,
              onTapCall: () =>
                  RouterFluro.navigateTo(context, "/ExchangeDevicePage"),
            ),
          ],
        ));
  }

  // 采购的云商宝
  Widget newCard3() {
    return Container(
        margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
        // padding: EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 0),
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: FmList(
          children: [
            FmCell(
              title: "采购的云商宝",
              subtitle: "19434",
              isLink: true,
              onTapCall: () =>
                  RouterFluro.navigateTo(context, "/PurchaseYsbDevicePage"),
            ),
          ],
        ));
  }

  /* 
  采购机具转换成兑换机具and采购机具转换成记录
   */
  Widget newCard4() {
    return Container(
        margin: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
        // padding: EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 0),
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: FmList(
          children: [
            FmCell(
              title: "采购机具转换成兑换机具",
              isLink: true,
              onTapCall: () =>
                  RouterFluro.navigateTo(context, "/PurchaseYsbDevicePage"),
            ),
            FmCell(
              title: "采购机具转换成记录",
              isLink: true,
              onTapCall: () =>
                  RouterFluro.navigateTo(context, "/PurchaseYsbDevicePage"),
            ),
          ],
        ));
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
          primary: false,
          child: Column(
            children: [
              newCard1(),
              newCard2(),
              newCard3(),
              newCard4(),
              Container(height: 20),
            ],
          ),
        ));
  }
}
