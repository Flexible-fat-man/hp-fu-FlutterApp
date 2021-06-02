import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/fm/componse/button/FmButton.dart';
import 'package:hpfuapp/fm/componse/button/FmButtonShap.dart';
import 'package:hpfuapp/fm/componse/wrap/FmWrap.dart';
import 'package:hpfuapp/fm/element/FmColor.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/numer_util.dart';
import 'package:hpfuapp/utils/toast_util.dart';

import '../LoginFormCode.dart';
import 'WithdrawList.dart';

class Withdraw extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WithdrawState();
  }
}

class _WithdrawState extends State<Withdraw> {
  String withdrawMoney = "";
  String code = "123456";
  final moneyController = TextEditingController();
  final codeController = TextEditingController();
  Agent agentBean;
  String withdrawType = "分润";

  void _initData() {
    /**
     * 个人信息
     */
    HttpManager().post(
      url: ApiHelper.AgentMe,
      data: {},
      successCallback: (data) {
        setState(() {
          agentBean = Agent.fromJson(data);
        });
      },
    );
  }

  void _requestData() {
    if (withdrawMoney == "") {
      EasyLoading.showToast("请输入提现金额");
      return;
    }
    if (code == "") {
      EasyLoading.showToast("请输入验证码");
      return;
    }
    String type = "1";
    if (withdrawType == "返现") {
      type = "2";
    }
    EasyLoading.show();
    HttpManager().post(
      url: ApiHelper.AgentWithdrawAdd,
      data: {
        "withdrawType": type,
        "withdrawMoney": int.parse(withdrawMoney) * 100,
        "code": code,
      },
      successCallback: (data) {
        EasyLoading.dismiss();
        EasyLoading.showToast("提交成功");
        _initData();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return WithdrawList();
        }));
      },
      errorCallback: (HttpError error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.message);
      },
    );
  }

  void _sendVerifyCode() {
    HttpManager().post(
      url: ApiHelper.sendVerifyCode,
      data: {
        "mobile": agentBean.agentMobile,
        "type": "2",
      },
      successCallback: (data) {
        Toast.toast(context, "发送成功");
      },
      errorCallback: (HttpError error) {
        Toast.toast(context, error.message);
      },
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
            height: 150.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('分润', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '分润');
                    setState(() {
                      withdrawType = "分润";
                    });
                  },
                ),
                WidgetHelper.lineHorizontal(),
                ListTile(
                  title: Text('返现', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '返现');
                    setState(() {
                      withdrawType = "返现";
                    });
                  },
                ),
                WidgetHelper.lineHorizontal(),
              ],
            ),
          );
        });

    print(option);
  }

  @override
  Widget build(BuildContext context) {
    moneyController.addListener(() {
      print('input ${moneyController.text}');
      setState(() {
        withdrawMoney = moneyController.text;
      });
    });
    codeController.addListener(() {
      print('input ${codeController.text}');
      setState(() {
        code = codeController.text;
      });
    });

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
            "提现",
            style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    //单击事件响应
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return WithdrawList();
                      }));
                    },
                    child: Text(
                      "提现记录",
                      style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
                    )),
              ],
            ),
            Container(
              width: 15,
            )
          ],
        ),
        backgroundColor: ColorHelper.backgroundColor,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
                child: Text(
                  "账户余额(元)",
                  style:
                      TextStyle(color: ColorHelper.primaryText, fontSize: 16),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 106,
                    //设置背景图片
                    decoration: new BoxDecoration(
                      //背景
                      color: Colors.white,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      //设置四周边框
                      border: new Border.all(width: 1, color: Colors.white),
                    ),
                    margin: EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                agentBean == null
                                    ? ""
                                    : NumberUtil.formatNum(
                                        (agentBean.canWithdrawalMoney / 100)),
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 20),
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                "分润可提现",
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 1,
                          color: ColorHelper.dividerColor,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                agentBean == null
                                    ? ""
                                    : NumberUtil.formatNum(
                                        (agentBean.fxCanWithdrawalMoney / 100)),
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 20),
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                "返现可提现",
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            _openModalBottomSheet();
                          },
                          child: Container(
                            height: 60,
                            child: Row(
                              children: [
                                Container(
                                  width: 15,
                                ),
                                Container(
                                  width: 90,
                                  child: Text(
                                    "提现类型",
                                    style: TextStyle(
                                        color: ColorHelper.primaryText,
                                        fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  withdrawType,
                                  style: TextStyle(
                                      color: ColorHelper.primaryText,
                                      fontSize: 16),
                                )),
                                Image.asset(
                                  "images/ic_mine_arrow.png",
                                  fit: BoxFit.scaleDown,
                                  width: 9,
                                  height: 14,
                                ),
                                Container(
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
              WidgetHelper.lineHorizontal(),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    margin:
                        EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                              ),
                              Container(
                                width: 90,
                                child: Text(
                                  "提现金额",
                                  style: TextStyle(
                                      color: ColorHelper.primaryText,
                                      fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: moneyController,
                                  style: TextStyle(
                                      color: Color(0xFF383838), fontSize: 16),
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    hintText: "请输入提现金额",
                                    hintStyle: TextStyle(
                                        color: Color(0xFFCCCCCC), fontSize: 16),
                                  ),
                                ),
                              ),
                              Container(
                                width: 15,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                ],
              ),
              WidgetHelper.lineHorizontal(),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    margin:
                        EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                              ),
                              Container(
                                width: 90,
                                child: Text(
                                  "手机号码",
                                  style: TextStyle(
                                      color: ColorHelper.primaryText,
                                      fontSize: 16),
                                ),
                              ),
                              Text(
                                agentBean == null ? "" : agentBean.agentMobile,
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 16),
                              ),
                              Container(
                                width: 15,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                ],
              ),
//              WidgetHelper.lineHorizontal(),
//              Row(
//                children: [
//                  Expanded(
//                      child: Container(
//                    color: Colors.white,
//                    margin:
//                        EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        Container(
//                          height: 60,
//                          child: Row(
//                            children: [
//                              Container(
//                                width: 15,
//                              ),
//                              Container(
//                                width: 90,
//                                child: Text(
//                                  "验证码",
//                                  style: TextStyle(
//                                      color: ColorHelper.primaryText,
//                                      fontSize: 16),
//                                ),
//                              ),
//                              Expanded(
//                                child: TextField(
//                                  inputFormatters: [
//                                    FilteringTextInputFormatter.digitsOnly
//                                  ],
//                                  keyboardType: TextInputType.number,
//                                  controller: codeController,
//                                  style: TextStyle(
//                                      color: Color(0xFF383838), fontSize: 16),
//                                  decoration: InputDecoration(
//                                    isCollapsed: true,
//                                    border: InputBorder.none,
//                                    hintText: "请输入验证码",
//                                    hintStyle: TextStyle(
//                                        color: Color(0xFFCCCCCC), fontSize: 16),
//                                  ),
//                                ),
//                              ),
//                              LoginFormCode(
//                                onTapCallback: () {
//                                  _sendVerifyCode();
//                                }, // 回调下一步方法，比如调用验证码接口
//                                available: true, // 只有是true才能激活倒计时
//                              ),
//                              Container(
//                                width: 15,
//                              ),
//                            ],
//                          ),
//                        )
//                      ],
//                    ),
//                  )),
//                ],
//              ),
              Container(
                margin:
                    EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
                child: Text(
                  "1、每次最小提现金额10元。\n2、缴税金额＝提现金额×8%，即提现100元缴纳个人所得税8元。\n3、提现手续费3元/笔。",
                  style:
                      TextStyle(color: ColorHelper.secondaryText, fontSize: 12),
                ),
              ),
              Container(height: 10),
              FmWrap.all(
                  20,
                  FmButton(
                      title: "立即提现",
                      shap: FmButtonShap.pill,
                      bgColor: FmColor.primary,
                      onTap: () {
                        _requestData();
                      })),
            ],
          ),
        ));
  }
}
