import 'package:event_bus/event_bus.dart';
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
import 'package:hpfuapp/model/EventFn.dart';
import 'package:hpfuapp/utils/event_manager.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';

class AuthName extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthNameState();
  }
}

class _AuthNameState extends State<AuthName> {
  String settleCardNo = "";
  String settleIdCard = "";
  String settleMobile = "";
  String settleName = "";
  Agent agentBean;

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final idCardController = TextEditingController();
  final cardNoController = TextEditingController();

  void _initData() {
    HttpManager().post(
      url: ApiHelper.AgentMe,
      data: {},
      successCallback: (data) {
        if (mounted){
          setState(() {
            agentBean = Agent.fromJson(data);
            settleName = agentBean.settleName;
            settleMobile = agentBean.settleMobile;
            settleIdCard = agentBean.settleIdCard;
            settleCardNo = agentBean.settleCardNo;
            nameController.value = nameController.value.copyWith(
              text: settleName,
              selection: TextSelection(
                  baseOffset: settleName.length, extentOffset: settleName.length),
              composing: TextRange.empty,
            );
            mobileController.value = mobileController.value.copyWith(
              text: settleMobile,
              selection: TextSelection(
                  baseOffset: settleMobile.length,
                  extentOffset: settleMobile.length),
              composing: TextRange.empty,
            );
            idCardController.value = idCardController.value.copyWith(
              text: settleIdCard,
              selection: TextSelection(
                  baseOffset: settleIdCard.length,
                  extentOffset: settleIdCard.length),
              composing: TextRange.empty,
            );
            cardNoController.value = cardNoController.value.copyWith(
              text: settleCardNo,
              selection: TextSelection(
                  baseOffset: settleCardNo.length,
                  extentOffset: settleCardNo.length),
              composing: TextRange.empty,
            );
          });
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

  void _requestData() {
    if (settleName == "") {
      EasyLoading.showToast("请输入姓名");
      return;
    }
    if (settleMobile == "") {
      EasyLoading.showToast("请输入手机号");
      return;
    }
    if (settleIdCard == "") {
      EasyLoading.showToast("请输入身份证号");
      return;
    }
    if (settleCardNo == "") {
      EasyLoading.showToast("请输入结算银行卡号");
      return;
    }
    EasyLoading.show();
    HttpManager().post(
      url: ApiHelper.AgentSettle,
      data: {
        "settleCardNo": settleCardNo,
        "settleIdCard": settleIdCard,
        "settleMobile": settleMobile,
        "settleName": settleName,
      },
      successCallback: (data) {
        EventManager().post(EventFn(type: "home"));
        // 调用 eventBus.fir 发送事件信息
        EasyLoading.dismiss();
        EasyLoading.showToast("提交成功");
        Navigator.of(context).pop();
      },
      errorCallback: (HttpError error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.message);
      },
      tag: "tag",
    );
  }

  Widget buildTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    nameController.addListener(() {
      print('input ${nameController.text}');

      setState(() {
        settleName = nameController.text;
      });
    });

    mobileController.addListener(() {
      print('input ${mobileController.text}');
      setState(() {
        settleMobile = mobileController.text;
      });
    });

    idCardController.addListener(() {
      print('input ${idCardController.text}');
      setState(() {
        settleIdCard = idCardController.text;
      });
    });

    cardNoController.addListener(() {
      print('input ${cardNoController.text}');

      setState(() {
        settleCardNo = cardNoController.text;
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
          "实名认证",
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: ColorHelper.backgroundColor,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(children: [
              WidgetHelper.lineHorizontal(),
              Container(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "姓名",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: nameController,
                        style:
                            TextStyle(color: Color(0xFF383838), fontSize: 14),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "请输入姓名",
                          hintStyle:
                              TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                  ],
                ),
              ),
              WidgetHelper.lineHorizontal2(10.0, 0.0, 10.0, 0.0),
              Container(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "手机号",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        //限定数字键盘
                        controller: mobileController,
                        style:
                            TextStyle(color: Color(0xFF383838), fontSize: 14),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "请输入手机号",
                          hintStyle:
                              TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                  ],
                ),
              ),
              WidgetHelper.lineHorizontal2(10.0, 0.0, 10.0, 0.0),
              Container(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "身份证号",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: idCardController,
                        style:
                            TextStyle(color: Color(0xFF383838), fontSize: 14),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "请输入身份证号",
                          hintStyle:
                              TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                  ],
                ),
              ),
              WidgetHelper.lineHorizontal2(10.0, 0.0, 10.0, 0.0),
              Container(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "结算银行卡号",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        //限定数字键盘
                        controller: cardNoController,
                        style:
                            TextStyle(color: Color(0xFF383838), fontSize: 14),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "请输入结算银行卡号",
                          hintStyle:
                              TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                  ],
                ),
              ),
              WidgetHelper.lineHorizontal(),
            ]),
          ),
          Container(height: 10),
          FmWrap.all(
              20,
              FmButton(
                  title: "提交",
                  shap: FmButtonShap.pill,
                  bgColor: FmColor.primary,
                  onTap: () {
                    _requestData();
                  })),
        ],
      ),
    );
  }
}
