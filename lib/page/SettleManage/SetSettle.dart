import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/fm/componse/button/FmButton.dart';
import 'package:hpfuapp/fm/componse/button/FmButtonShap.dart';
import 'package:hpfuapp/fm/componse/field/FmFieldMy.dart';
import 'package:hpfuapp/fm/componse/wrap/FmWrap.dart';
import 'package:hpfuapp/fm/element/FmColor.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/model/SettleValue.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/toast_util.dart';

import 'dart:convert';

class Values {
  String value1;
  String value2;
  String value3;

  Values({
    this.value1 = "",
    this.value2 = "",
    this.value3 = "",
  });

  Values.fromJson(Map<String, dynamic> json) {
    value1 = json['value1'];
    value2 = json['value2'];
    value3 = json['value3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value1'] = this.value1;
    data['value1'] = this.value2;
    data['value3'] = this.value3;
    return data;
  }
}

class SetSettle extends StatefulWidget {
  final String agentNo;

  const SetSettle({Key key, this.agentNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SetSettleState(agentNo: agentNo);
  }
}

class _SetSettleState extends State<SetSettle> {
  final String agentNo;

  _SetSettleState({this.agentNo});

  Agent agentBean;

  //高端服务费率(标准类)
  Values highValue = Values();

  //综合服务费率(标准类)
  Values compreValue = Values();

  //高端服务费率(D0交易)
  Values highValueD0 = Values();

  //综合服务费率(D0交易)
  Values compreValueD0 = Values();

  //云闪付
  Values yunValue = Values();

  //银联扫码D0(1千以上)
  Values bank1ValueD0 = Values();

  //银联扫码D0(1千以下)
  Values bankValueD0 = Values();

  //支付宝微信扫码D0
  Values payValueD0 = Values();

  //分润比例
  Values shareValue = Values();

  //流量卡返现
  Values flowValue = Values();

  //激活达标
  Values activateValue = Values();

  Map<String, String> rateMap;

  void _initData() {
    HttpManager().post(
      url: ApiHelper.queryAllSub,
      data: {
        "subAgentNo": agentNo,
      },
      successCallback: (data) {
        List<SettleValue> mList = (data as List<dynamic>)
            .map((e) => SettleValue.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        if (mounted){
          setState(() {
            if (mList != null && mList.isNotEmpty) {
              for (SettleValue bean in mList) {
                if (bean.type == 1) {
                  highValue.value1 = bean.rate;
                }
                if (bean.type == 2) {
                  highValue.value2 = bean.rate;
                }
                if (bean.type == 3) {
                  highValue.value3 = bean.rate;
                }
                if (bean.type == 4) {
                  compreValue.value1 = bean.rate;
                }
                if (bean.type == 5) {
                  compreValue.value2 = bean.rate;
                }
                if (bean.type == 6) {
                  compreValue.value3 = bean.rate;
                }
                if (bean.type == 7) {
                  highValueD0.value1 = bean.rate;
                }
                if (bean.type == 8) {
                  highValueD0.value3 = bean.rate;
                }
                if (bean.type == 9) {
                  compreValueD0.value1 = bean.rate;
                }
                if (bean.type == 10) {
                  compreValueD0.value3 = bean.rate;
                }
                if (bean.type == 11) {
                  yunValue.value1 = bean.rate;
                }
                if (bean.type == 12) {
                  yunValue.value3 = bean.rate;
                }
                if (bean.type == 13) {
                  bank1ValueD0.value1 = bean.rate;
                }
                if (bean.type == 14) {
                  bankValueD0.value1 = bean.rate;
                }
                if (bean.type == 15) {
                  payValueD0.value1 = bean.rate;
                }
                if (bean.type == 16) {
                  shareValue.value1 = bean.rate;
                }
                if (bean.type == 17) {
                  flowValue.value2 = bean.rate;
                }
                if (bean.type == 18) {
                  activateValue.value2 = bean.rate;
                }
              }
            }
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
    rateMap = {
      "1": highValue.value1,
      "2": highValue.value2,
      "3": highValue.value3,
      "4": compreValue.value1,
      "5": compreValue.value2,
      "6": compreValue.value3,
      "7": highValueD0.value1,
      "8": highValueD0.value3,
      "9": compreValueD0.value1,
      "10": compreValueD0.value3,
      "11": yunValue.value1,
      "12": yunValue.value3,
      "13": bank1ValueD0.value1,
      "14": bankValueD0.value1,
      "15": payValueD0.value1,
      "16": shareValue.value1,
      "17": flowValue.value2,
      "18": activateValue.value2,
    };
    EasyLoading.show();
    HttpManager().post(
      url: ApiHelper.setValueForSub,
      data: {"subAgentNo": agentNo, "valueStr": jsonEncode(rateMap)},
      successCallback: (data) {
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

  Widget itemWidget(
      String title, String name1, String name2, String name3, Values values) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 0),
      padding: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 15, right: 0, bottom: 0),
          child: Text(
            title,
            style: TextStyle(
                color: ColorHelper.colorPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800),
          ),
        ),
        name1 == ""
            ? Container()
            : Container(
                margin:
                    EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          name1,
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      height: 34,
                      width: 150,
                      padding: EdgeInsets.only(
                          left: 10, top: 0, right: 10, bottom: 0),
                      decoration: new BoxDecoration(
                        //背景
                        color: Color(0xFFF6F6F6),
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: FmFieldMy(
                              placeholder: "",
                              value: values.value1,
                              onChanged: (text) {
//                                setState(() => values.value1 = text);
                                values.value1 = text;
                              },
                            ),
                          ),
                          Text(
                            "%",
                            style: TextStyle(
                                color: Color(0xFF383838), fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        name2 == ""
            ? Container()
            : Container(
                margin:
                    EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          name2,
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      height: 36,
                      width: 150,
                      padding: EdgeInsets.only(
                          left: 10, top: 0, right: 10, bottom: 0),
                      decoration: new BoxDecoration(
                        //背景
                        color: Color(0xFFF6F6F6),
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: FmFieldMy(
                              placeholder: "",
                              value: values.value2,
                              onChanged: (text) {
//                                setState(() => values.value2 = text);
                                values.value2 = text;
                              },
                            ),
                          ),
                          Text(
                            "元",
                            style: TextStyle(
                                color: Color(0xFF383838), fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        name3 == ""
            ? Container()
            : Container(
                margin:
                    EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          name3,
                          style:
                              TextStyle(color: Color(0xFF383838), fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      height: 36,
                      width: 150,
                      padding: EdgeInsets.only(
                          left: 10, top: 0, right: 10, bottom: 0),
                      decoration: new BoxDecoration(
                        //背景
                        color: Color(0xFFF6F6F6),
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: FmFieldMy(
                              placeholder: "",
                              value: values.value3,
                              onChanged: (text) {
//                                setState(() => values.value3 = text);
                                values.value3 = text;
                              },
                            ),
                          ),
                          Text(
                            "%",
                            style: TextStyle(
                                color: Color(0xFF383838), fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ]),
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
            "结算管理",
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
              itemWidget(
                "高端服务费率(标准类)",
                "借记卡成本扣率",
                "借记卡封顶成本",
                "贷记卡成本扣率",
                highValue,
              ),
              itemWidget(
                "综合服务费率(标准类)",
                "借记卡成本扣率",
                "借记卡封顶成本",
                "贷记卡成本扣率",
                compreValue,
              ),
              itemWidget(
                "高端服务费率(D0交易)",
                "借记卡成本扣率",
                "",
                "贷记卡成本扣率",
                highValueD0,
              ),
              itemWidget(
                "综合服务费率(D0交易)",
                "借记卡成本扣率",
                "",
                "贷记卡成本扣率",
                compreValueD0,
              ),
              itemWidget(
                "云闪付",
                "借记卡成本扣率",
                "",
                "贷记卡成本扣率",
                yunValue,
              ),
              itemWidget(
                "银联扫码D0(1千以上)",
                "借记卡成本扣率",
                "",
                "",
                bank1ValueD0,
              ),
              itemWidget(
                "银联扫码D0(1干以下)",
                "借记卡成本扣率",
                "",
                "",
                bankValueD0,
              ),
              itemWidget(
                "支付宝微信扫码D0",
                "借记卡成本扣率",
                "",
                "",
                payValueD0,
              ),
              itemWidget(
                "分润比例",
                "0元-999999999元",
                "",
                "",
                shareValue,
              ),
              itemWidget(
                "流量卡返现",
                "",
                "流量卡返现",
                "",
                flowValue,
              ),
              itemWidget(
                "激活达标",
                "",
                "激活达标",
                "",
                activateValue,
              ),
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
        ));
  }
}
