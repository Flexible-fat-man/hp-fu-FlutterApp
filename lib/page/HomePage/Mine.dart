import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/PrefixHelper.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/utils/SharedPreferenceUtil.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';

import '../../fm/componse/card/FmCard.dart';
import '../../fm/componse/cell/FmCell.dart';
import '../../fm/componse/wrap/FmWrap.dart';
import '../../router/RouterFluro.dart';

class Mine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineState();
  }
}

class _MineState extends State<Mine> {
  Agent agentBean;

  void _initData() {
    HttpManager().post(
      url: ApiHelper.AgentMe,
      data: {},
      successCallback: (data) {
        if (mounted){
          setState(() {
            agentBean = Agent.fromJson(data);
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

  /*
   * 弹出框
   */
  void showAlertDialog() {
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
                    "确认退出登录？",
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

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Widget topHome() {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 15, top: 79, right: 15, bottom: 0),
          height: 236,
          //设置背景图片
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(
                "images/ic_mine_me_bg.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    "images/ic_mine_touxiang.png",
                    fit: BoxFit.scaleDown,
                    width: 54,
                    height: 54,
                  ),
                  Container(
                    //设置背景图片
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Color(0x1a257efc), blurRadius: 3)
                      ],
                    ),
                    margin:
                        EdgeInsets.only(left: 40, top: 42, right: 0, bottom: 0),
                    child: Image.asset(
                      "images/ic_mine_v.png",
                      fit: BoxFit.scaleDown,
                      width: 14,
                      height: 14,
                    ),
                  ),
                ],
              ),
              Container(
                width: 15,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            agentBean?.agentName ?? "",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      Container(
                        height: 6,
                      ),
                      Text(
                        // agentBean == null
                        //     ? ""
                        //     : (agentBean.agentMobile.substring(0, 3) +
                        //         "****" +
                        //         agentBean.agentMobile.substring(8, 11)),
                        ' ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )
//                      Stack(
//                        children: [
//                          Container(
//                              margin: EdgeInsets.only(
//                                  left: 8, top: 5, right: 0, bottom: 0),
//                              height: 20,
//                              width: 76,
//                              //设置背景图片
//                              decoration: new BoxDecoration(
//                                image: new DecorationImage(
//                                  image: new AssetImage(
//                                    "images/ic_mine_tuoyuan.png",
//                                  ),
//                                  fit: BoxFit.fill,
//                                ),
//                                boxShadow: [
//                                  BoxShadow(
//                                      color: Color(0x1a257efc), blurRadius: 3)
//                                ],
//                              ),
//                              child: Row(
//                                children: [
//                                  Expanded(child: Text("")),
//                                  Text(
//                                    "分润等级",
//                                    style: TextStyle(
//                                        color: Color(0xFF4A4A4A),
//                                        fontSize: 11,
//                                        fontWeight: FontWeight.w400),
//                                  ),
//                                  Container(
//                                    width: 8,
//                                  ),
//                                ],
//                              )),
//                          Container(
//                              height: 30,
//                              width: 31,
//                              padding: EdgeInsets.only(
//                                  left: 0, top: 7, right: 0, bottom: 0),
//                              //设置背景图片
//                              decoration: new BoxDecoration(
//                                image: new DecorationImage(
//                                  image: new AssetImage(
//                                    "images/ic_mine_bianxing.png",
//                                  ),
//                                  fit: BoxFit.fill,
//                                ),
//                                boxShadow: [
//                                  BoxShadow(
//                                      color: Color(0x1a257efc), blurRadius: 3)
//                                ],
//                              ),
//                              child: Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: [
//                                  Stack(
//                                    children: [
//                                      Container(
//                                        margin: EdgeInsets.only(
//                                            left: 0,
//                                            top: 0,
//                                            right: 0,
//                                            bottom: 8),
//                                        child: Image.asset(
//                                          "images/ic_mine_heiv.png",
//                                          fit: BoxFit.fill,
//                                          width: 11,
//                                          height: 10,
//                                        ),
//                                      ),
//                                      Container(
//                                        margin: EdgeInsets.only(
//                                            left: 7,
//                                            top: 2,
//                                            right: 0,
//                                            bottom: 0),
//                                        child: Text(
//                                          "1",
//                                          style: TextStyle(
//                                              color: Color(0xFF2A3247),
//                                              fontSize: 11,
//                                              fontWeight: FontWeight.w800),
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ],
//                              )),
//                        ],
//                      )
                    ]),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 153),
          child: order(),
        ),
      ],
    );
  }

  bool showOrganizationCell() {
    if (agentBean != null && agentBean.depth == 2) {
      return true;
    } else {
      return false;
    }
  }

  Widget organizationCell() {
    if (showOrganizationCell()) {
      return FmCell(
          height: 60,
          isShowBorder: false,
          prefixWidget: PrefixHelper.ic_me_daichuli,
          title: "机构账户",
          isLink: true,
          onTap: () => RouterFluro.navigateTo(context, "/OrganizationAccount",
              replace: false));
    } else {
      return Container();
    }
  }

  Widget order() {
    return FmWrap.all(
        15,
        FmCard(
            body: Column(
          children: [
            FmCell(
                height: 60,
                isShowBorder: showOrganizationCell(),
                prefixWidget: PrefixHelper.ic_me_shouyizonglian,
                title: "我的结算价",
                isLink: true,
                onTap: () => RouterFluro.navigateTo(
                    context, "/SettleManage/MySettle",
                    replace: false)),
            organizationCell(),
          ],
        )));
  }

  Widget setting(BuildContext context) {
    return FmWrap.all(
      15,
      FmCard(
          body: Column(
        children: [
          FmCell(
              height: 60,
              prefixWidget: PrefixHelper.ic_mine_forme,
              title: "关于我们",
              isLink: true,
              onTap: () =>
                  RouterFluro.navigateTo(context, "/AboutUs", replace: false)),
          FmCell(
              height: 60,
              prefixWidget: PrefixHelper.ic_mine_shezhi,
              title: "设置",
              isLink: true,
              onTap: () =>
                  RouterFluro.navigateTo(context, "/Setting", replace: false)),
          FmCell(
              height: 60,
              isShowBorder: false,
              prefixWidget: PrefixHelper.ic_mine_tuichu,
              title: "退出",
              isLink: true,
              onTap: () {
                showAlertDialog();
              }),
        ],
      )),
    );
  }

  Widget order2() {
    return FmWrap.all(
        15,
        FmCard(
            body: Column(
          children: [
            FmCell(
                height: 60,
                isShowBorder: false,
                prefixWidget: PrefixHelper.ic_mine_tuichu,
                title: "模拟交易",
                isLink: true,
                onTap: () => RouterFluro.navigateTo(context, "/FlmOrder",
                    replace: false)),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorHelper.backgroundColor,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            children: [
              topHome(),
              setting(context),
            ],
          ),
        ));
  }
}
