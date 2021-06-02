import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/SharedPreferenceUtil.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Invite extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InviteState();
  }
}

class _InviteState extends State<Invite> {
  Agent agentBean;

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

  @override
  void initState() {
    _initData();

    super.initState();
  }

  /*
   * 标题栏
   */
  Widget titleBar() {
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 0, top: 45, right: 0, bottom: 0),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "二维码分享",
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
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
        height: 440,
        margin: EdgeInsets.only(left: 30, top: 60, right: 30, bottom: 0),
        //设置背景图片
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage(
              "images/ic_invite_card.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 26,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 15,
                  ),
                  Image.asset(
                    "images/ic_mine_touxiang.png",
                    fit: BoxFit.scaleDown,
                    width: 54,
                    height: 54,
                  ),
                  Container(
                    width: 15,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (agentBean?.agentName ?? "") + "的二维码",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color(0xFF2A3247),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        "邀请您一起赚钱",
                        style: TextStyle(
                            color: Color(0xFFB0B4BB),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
                  Container(
                    width: 12,
                  ),
                ],
              ),
            ),
            Expanded(child: Text("")),
            new QrImage(
              data: ApiHelper.base +
                  ApiHelper.AgentInvite +
                  "?parentAgentNo=" +
                  (agentBean?.agentNo ?? ""),
              size: 230.0,
            ),
            Container(
              height: 46,
            ),
          ],
        ));
  }

  /*
   *
   */
  Widget newCard2() {
    return Container(
        margin: EdgeInsets.only(left: 0, top: 19, right: 0, bottom: 0),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/ic_invite_left.png",
                    fit: BoxFit.scaleDown,
                    width: 19,
                    height: 2,
                  ),
                  Container(
                    width: 5,
                  ),
                  Text(
                    "更多分享方式",
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Container(
                    width: 5,
                  ),
                  Image.asset(
                    "images/ic_invite_right.png",
                    fit: BoxFit.scaleDown,
                    width: 19,
                    height: 2,
                  ),
                ],
              ),
            ),
            Container(
              height: 17,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text("")),
                  Column(
                    children: [
                      Image.asset(
                        "images/ic_invite_weixin.png",
                        fit: BoxFit.scaleDown,
                        width: 38,
                        height: 38,
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        "微信好友",
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Expanded(child: Text("")),
                  Column(
                    children: [
                      Image.asset(
                        "images/ic_invite_pengyouquan.png",
                        fit: BoxFit.scaleDown,
                        width: 38,
                        height: 38,
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        "微信朋友圈",
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Expanded(child: Text("")),
                  Column(
                    children: [
                      Image.asset(
                        "images/ic_invite_xiazai.png",
                        fit: BoxFit.scaleDown,
                        width: 38,
                        height: 38,
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        "下载到手机",
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Expanded(child: Text("")),
                ],
              ),
            ),
            Container(
              height: 20,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorHelper.backgroundColor,
        body: SingleChildScrollView(
          primary: false,
          child: Container(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height - 56),
            //设置背景图片
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage(
                  "images/ic_invite_bg.png",
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                titleBar(),
                newCard1(),
//                newCard2(),
              ],
            ),
          ),
        ));
  }
}
