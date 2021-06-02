import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/MerchantStatistic.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';

import 'MerchantList.dart';

class MerchantManage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MerchantManageState();
  }
}

class _MerchantManageState extends State<MerchantManage> {
  MerchantStatistic dataBean;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() {
    HttpManager().post(
      url: ApiHelper.statisticByMerchant,
      data: {
        "containType": "7",
      },
      successCallback: (data) {
        setState(() {
          dataBean = MerchantStatistic.fromJson(data);
        });
      },
    );
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
                    dataBean == null ? "0" : (dataBean.notLess0.toString()),
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 32,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "商户总数量(个)",
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 0, top: 25, right: 0, bottom: 0),
              child: InkWell(
                  //单击事件响应
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MerchantList(
                          minMoneyText: "0", maxMoneyText: "infinity");
                    }));
                  },
                  child: Container(
                    height: 36,
                    width: 160,
                    decoration: new BoxDecoration(
                      //背景
                      color: Color(0xFFFFFFFF),
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                      boxShadow: [
                        BoxShadow(color: Color(0x29257efc), blurRadius: 2)
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "查看详情",
                        style: TextStyle(
                            color: Color(0xFF257EFC),
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  )),
            )
          ],
        ));
  }

  Widget newCard2() {
    return Container(
        margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
        // padding: EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 0),
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
        ),
        child: Column(
          children: [
            InkWell(
                //单击事件响应
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MerchantList(
                        minMoneyText: "0", maxMoneyText: "500000");
                  }));
                },
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      Container(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataBean == null
                                  ? "0"
                                  : (dataBean.less500000.toString()),
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            ),
                            Container(height: 2),
                            Text(
                              "交易总金额小于5000元的商户",
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "images/ic_mine_arrow.png",
                        fit: BoxFit.scaleDown,
                        width: 9,
                        height: 14,
                      ),
                      Container(width: 20),
                    ],
                  ),
                )),
            WidgetHelper.lineHorizontal2(20.0, 0.0, 0.0, 0.0),
            InkWell(
                //单击事件响应
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MerchantList(
                        minMoneyText: "500000", maxMoneyText: "1000000");
                  }));
                },
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      Container(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataBean == null
                                  ? "0"
                                  : (dataBean.less1000000.toString()),
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            ),
                            Container(height: 2),
                            Text(
                              "交易总金额大于等于5000元的商户",
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "images/ic_mine_arrow.png",
                        fit: BoxFit.scaleDown,
                        width: 9,
                        height: 14,
                      ),
                      Container(width: 20),
                    ],
                  ),
                )),
            WidgetHelper.lineHorizontal2(20.0, 0.0, 0.0, 0.0),
            InkWell(
                //单击事件响应
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MerchantList(
                        minMoneyText: "1000000", maxMoneyText: "3000000");
                  }));
                },
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      Container(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataBean == null
                                  ? "0"
                                  : (dataBean.less3000000.toString()),
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            ),
                            Container(height: 2),
                            Text(
                              "交易总金额大于等于10000元的商户",
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "images/ic_mine_arrow.png",
                        fit: BoxFit.scaleDown,
                        width: 9,
                        height: 14,
                      ),
                      Container(width: 20),
                    ],
                  ),
                )),
            WidgetHelper.lineHorizontal2(20.0, 0.0, 0.0, 0.0),
            InkWell(
                //单击事件响应
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MerchantList(
                        minMoneyText: "3000000", maxMoneyText: "infinity");
                  }));
                },
                child: Container(
                  height: 60,
                  child: Row(
                    children: [
                      Container(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataBean == null
                                  ? "0"
                                  : (dataBean.notLess3000000.toString()),
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800),
                            ),
                            Container(height: 2),
                            Text(
                              "交易总金额大于等于30000元的商户",
                              style: TextStyle(
                                  color: Color(0xFF1A1A1A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "images/ic_mine_arrow.png",
                        fit: BoxFit.scaleDown,
                        width: 9,
                        height: 14,
                      ),
                      Container(width: 20),
                    ],
                  ),
                )),
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
          "商户管理",
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "",
                style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
              ),
            ],
          ),
          Container(
            width: 15,
          )
        ],
      ),
      backgroundColor: ColorHelper.backgroundColor,
      body: Column(
        children: [
          Container(
            height: 20,
          ),
          newCard1(),
          newCard2(),
        ],
      ),
    );
  }
}
