import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/Achievement.dart';
import 'package:hpfuapp/page/TransactionInquiry/TransactionInquiryView.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/SharedPreferenceUtil.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/numer_util.dart';

import '../../fm/componse/card/FmCard.dart';
import '../../fm/componse/cell/FmCell.dart';
import '../../fm/componse/wrap/FmWrap.dart';
import '../MerchantList.dart';
import 'PerformanceQuery.dart';

class Performance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PerformanceState();
  }
}

class _PerformanceState extends State<Performance> {
  Achievement dataBean;
/*
   * 弹出框
   */
  void showLoginDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              '提示',
              style: TextStyle(color: ColorHelper.primaryText, fontSize: 16),
            ),
            //可滑动
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  Text(
                    "登录过期，请重新登录",
                    style:
                    TextStyle(color: ColorHelper.primaryText, fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  '取消',
                  style:
                  TextStyle(color: ColorHelper.primaryText, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new TextButton(
                child: new Text(
                  '确定',
                  style:
                  TextStyle(color: ColorHelper.colorPrimary, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  SharedPreferenceUtil.clearToken();
                  RouterFluro.navigateTo(context, "/LoginPage", replace: true);
                },
              ),
            ],
          );
        });
  }
  void _initData() {
    HttpManager().post(
      url: ApiHelper.achievement,
      data: {},
      successCallback: (data) {
        if (mounted){
          setState(() {
            dataBean = Achievement.fromJson(data);
          });
        }
      },
      errorCallback: (HttpError error) {
        EasyLoading.showToast(error.message);
        if ("400" == error.code || "300" == error.code) {
          showLoginDialog();
        }
      },
      tag: "tag",
    );
  }

  @override
  void initState() {
    _initData();

    super.initState();
  }

  Future _openModalBottomSheet() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('按日查询', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '按日查询');
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PerformanceQuery(cycleType: "day");
                    }));
                  },
                ),
                WidgetHelper.lineHorizontal(),
                ListTile(
                  title: Text('按月查询', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '按月查询');
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PerformanceQuery(cycleType: "month");
                    }));
                  },
                ),
                WidgetHelper.lineHorizontal(),
                ListTile(
                  title: Text('取消', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '取消');
                  },
                ),
              ],
            ),
          );
        });

    print(option);
  }

  /*
   * 标题栏
   */
  Widget titleBar() {
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "业绩总览",
                      style: TextStyle(
                          color: Color(0xff2A3247),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(""),
                    ),
                    InkWell(
                      //单击事件响应
                        onTap: () {
                          _openModalBottomSheet();
                        },
                        child: Text(
                          "详细查询",
                          style: TextStyle(
                              color: Color(0xff2A3247),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                )
              ],
            )),
      ],
    );
  }

  /*
   *
   */
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
              margin: EdgeInsets.only(left: 0, top: 20, right: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "合伙人交易总金额(元)",
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
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
                    "￥",
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    dataBean == null
                        ? "0"
                        : NumberUtil.formatNum((dataBean.sumTransAmt / 100)),
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 32,
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
                      return TransactionInquiryView();
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
                        "查看明细",
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

  /*
   *
   */
  Widget newCard2() {
    return FmWrap.all(
        15,
        FmCard(
            body: Column(
              children: [
                FmCell(
                  height: 60,
                  title: "合伙人总数(个)",
                  subtitle: dataBean == null ? "0" : dataBean.countAgent
                      .toString(),
                  isLink: true,
                    onTap: () =>
                        RouterFluro.navigateTo(context, "/Performance/AllAgentList", replace: false)
                ),
                FmCell(
                  height: 60,
                  title: "今日新增合伙人数(个)",
                  subtitle: "0",
                  isLink: true,
                ),
                FmCell(
                  height: 60,
                  title: "交易笔数(笔)",
                  subtitle:
                  dataBean == null ? "0" : dataBean.countTransAmt.toString(),
                  isLink: true,
                  onTap: (){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TransactionInquiryView();
                    }));
                  },
                ),
                FmCell(
                  height: 60,
                  title: "交易总金额(元)",
                  subtitle: dataBean == null
                      ? "0"
                      : NumberUtil.formatNum((dataBean.sumTransAmt / 100)),
                  isLink: true,
                  onTap: (){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TransactionInquiryView();
                    }));
                  },
                ),
                FmCell(
                  height: 60,
                  isShowBorder: false,
                  title: "机具开通数量(台)",
                  subtitle:
                  dataBean == null ? "0" : dataBean.countDevice.toString(),
                  isLink: true,
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MerchantList(
                          minMoneyText: "0", maxMoneyText: "infinity");
                    }));
                  },
                ),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFFF9F9FB),
          brightness: Brightness.light,
          title: titleBar(),
        ),
        backgroundColor: ColorHelper.backgroundColor,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            children: [
              newCard1(),
              newCard2(),
              Container(height: 20),
            ],
          ),
        ));
  }
}
