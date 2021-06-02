import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/toast_util.dart';

class UpdateName extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UpdateNameState();
  }
}

class _UpdateNameState extends State<UpdateName> {
  String agentName = "";
  final nameController = TextEditingController();
  Agent agentBean;

  void _initData() {
    HttpManager().post(
      url: ApiHelper.AgentMe,
      data: {},
      successCallback: (data) {
        setState(() {
          agentBean = Agent.fromJson(data);
          agentName = agentBean.agentName;
          nameController.value = nameController.value.copyWith(
            text: agentName,
            selection: TextSelection(
                baseOffset: agentName.length, extentOffset: agentName.length),
            composing: TextRange.empty,
          );
        });
      },
    );
  }

  void _requestData() {
    if (agentName == "") {
      EasyLoading.showToast("请输入名称");
      return;
    }
    EasyLoading.show();
    HttpManager().post(
      url: ApiHelper.updateAgentName,
      data: {
        "agentName": agentName,
      },
      successCallback: (data) {
        EasyLoading.dismiss();
        EasyLoading.showToast("提交成功");
        Navigator.of(context).pop();
      },
      errorCallback: (HttpError error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.message);
      },
    );
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nameController.addListener(() {
      print('input ${nameController.text}');

      setState(() {
        agentName = nameController.text;
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
          "修改名称",
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
                      width: 15,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          "名称",
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 14),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: nameController,
                        style:
                            TextStyle(color: Color(0xFF383838), fontSize: 14),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: "请输入名称",
                          hintStyle:
                              TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                        ),
                      ),
                    ),
                    Container(
                      width: 15,
                    ),
                  ],
                ),
              ),
              WidgetHelper.lineHorizontal(),
            ]),
          ),
          Container(
            height: 36,
            margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
                color: ColorHelper.colorPrimary,
                borderRadius: BorderRadius.circular(18)),
            child: TextButton(
              child: Text(
                '提交',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () {
                _requestData();
              },
            ),
          ),
        ],
      ),
    );
  }
}
