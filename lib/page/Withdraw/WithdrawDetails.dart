import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/Withdraw.dart';
import 'package:hpfuapp/utils/date_util.dart';
import 'package:hpfuapp/utils/numer_util.dart';

class WithdrawDetails extends StatefulWidget {
  final Withdraw dateBean;

  WithdrawDetails({Key key, @required this.dateBean}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WithdrawState(dateBean: dateBean);
  }
}

class _WithdrawState extends State<WithdrawDetails> {
  final Withdraw dateBean;
  String withdrawStatus = "";

  _WithdrawState({this.dateBean});

  void _initData() {
    setState(() {
      if (dateBean.withdrawStatus == 1) {
        withdrawStatus = "已申请";
      } else if (dateBean.withdrawStatus == 2) {
        withdrawStatus = "打款成功";
      } else if (dateBean.withdrawStatus == 3) {
        withdrawStatus = "打款失败";
      }
    });
  }

  @override
  void initState() {
    _initData();
    super.initState();
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
          "提现记录",
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: ColorHelper.backgroundColor,
      body: Column(
        children: [
          Container(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Column(
                  children: [
                    WidgetHelper.lineHorizontal(),
                    Container(
                      height: 44,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 15),
                          Expanded(
                            child: Text(
                              "ID",
                              style: TextStyle(
                                  color: ColorHelper.primaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            dateBean.agentWithdrawNo,
                            style: TextStyle(
                                color: ColorHelper.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(width: 15),
                        ],
                      ),
                    ),
                    WidgetHelper.lineHorizontal(),
                    Container(
                      height: 44,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 15),
                          Expanded(
                            child: Text(
                              "所属合伙人",
                              style: TextStyle(
                                  color: ColorHelper.primaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            dateBean.agentName == null
                                ? ""
                                : dateBean.agentName,
                            style: TextStyle(
                                color: ColorHelper.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(width: 15),
                        ],
                      ),
                    ),
                    WidgetHelper.lineHorizontal(),
                    Container(
                      height: 44,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 15),
                          Expanded(
                            child: Text(
                              "申请状态",
                              style: TextStyle(
                                  color: ColorHelper.primaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            withdrawStatus,
                            style: TextStyle(
                                color: ColorHelper.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(width: 15),
                        ],
                      ),
                    ),
                    WidgetHelper.lineHorizontal(),
                    Container(
                      height: 44,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 15),
                          Expanded(
                            child: Text(
                              "申请金额",
                              style: TextStyle(
                                  color: ColorHelper.primaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            NumberUtil.formatNum(
                                (dateBean.withdrawMoney / 100)),
                            style: TextStyle(
                                color: ColorHelper.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(width: 15),
                        ],
                      ),
                    ),
                    WidgetHelper.lineHorizontal(),
                    Container(
                      height: 44,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 15),
                          Expanded(
                            child: Text(
                              "创建时间",
                              style: TextStyle(
                                  color: ColorHelper.primaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            DateUtil.getDateStrByMillisecond(
                                dateBean.createTime * 1000,
                                format: DateFormat.NORMAL),
                            style: TextStyle(
                                color: ColorHelper.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(width: 15),
                        ],
                      ),
                    ),
                    WidgetHelper.lineHorizontal(),
                    Container(
                      height: 44,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 15),
                          Expanded(
                            child: Text(
                              "备注",
                              style: TextStyle(
                                  color: ColorHelper.primaryText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            dateBean.remark == null
                                ? ""
                                : dateBean.remark,
                            style: TextStyle(
                                color: ColorHelper.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(width: 15),
                        ],
                      ),
                    ),
                    WidgetHelper.lineHorizontal(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
