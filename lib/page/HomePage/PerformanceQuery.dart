import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/fm/componse/card/FmCard.dart';
import 'package:hpfuapp/fm/componse/wrap/FmWrap.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/model/Achievement.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/date_util.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/numer_util.dart';
import '../../fm/componse/card/FmCard.dart';
import '../../fm/componse/cell/FmCell.dart';
import '../../fm/componse/wrap/FmWrap.dart';
import '../MerchantList.dart';

import 'package:hpfuapp/page/TransactionInquiry/TransactionInquiryView.dart';

class PerformanceQuery extends StatefulWidget {
  final String cycleType;

  PerformanceQuery({Key key, @required this.cycleType}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PerformanceState(cycleType: cycleType);
  }
}

class _PerformanceState extends State<PerformanceQuery> {
  final String cycleType;
  String titleName = "";
  String dateTime = "";
  String dateStart = "";
  String dateEnd = "";

  _PerformanceState({this.cycleType});

  Achievement dataBean;

  void _initData() {
    HttpManager().post(
      url: ApiHelper.achievement,
      data: {
        "dateStart": dateStart,
        "dateEnd": dateEnd,
        "dateTime": dateTime,
      },
      successCallback: (data) {
        if (mounted){
          setState(() {
            dataBean = Achievement.fromJson(data);
          });
        }
      },
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
  }

  @override
  void initState() {
    if ("day" == cycleType) {
      titleName = "业绩(按日)";
      dateTime = DateUtil.getNowDateStr3();
      dateStart = dateTime;
      dateEnd = dateTime;
    } else {
      titleName = "业绩(按月)";
      dateTime = DateUtil.getNowDateStr5();

      //yyyy-MM
      DateTime dateTime2 = new DateTime(int.parse(dateTime.substring(0, 4)),
          int.parse(dateTime.substring(5, 7)), 01);

      dateStart =
          DateUtil.getDateStrByDateTime3(DateUtil.firstDayOfMonth(dateTime2));

      dateEnd =
          DateUtil.getDateStrByDateTime3(DateUtil.lastDayOfMonth(dateTime2));
    }
    _initData();
    super.initState();
  }

  void setData(DateTime date) {
    if ("day" == cycleType) {
      dateTime = DateUtil.getDateStrByDateTime3(date);
      dateStart = dateTime;
      dateEnd = dateTime;
    } else {
      dateTime = DateUtil.getDateStrByDateTime5(date);
      //yyyy-MM
      DateTime dateTime2 = new DateTime(int.parse(dateTime.substring(0, 4)),
          int.parse(dateTime.substring(5, 7)), 01);

      dateStart =
          DateUtil.getDateStrByDateTime3(DateUtil.firstDayOfMonth(dateTime2));

      dateEnd =
          DateUtil.getDateStrByDateTime3(DateUtil.lastDayOfMonth(dateTime2));
    }
    _initData();
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
                      return TransactionInquiryView(startDate: dateStart, endDate: dateEnd,);
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
                    subtitle:
                    dataBean == null ? "0" : dataBean.countAgent.toString(),
                    isLink: true,
                    onTap: () =>
                        RouterFluro.navigateTo(
                            context, "/Performance/AllAgentList",
                            replace: false)),
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
                      return TransactionInquiryView(startDate: dateStart, endDate: dateEnd,);
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
                      return TransactionInquiryView(startDate: dateStart, endDate: dateEnd,);
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
            titleName,
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
                      DatePicker.showDatePicker(context,
                          // 是否展示顶部操作按钮
                          showTitleActions: true,
                          // 最小时间
                          minTime: DateTime(2018, 3, 5),
                          // 最大时间
                          maxTime: DateTime(2099, 6, 7),
                          // change事件
                          onChanged: (date) {
                            print('change $date');
                          },
                          // 确定事件
                          onConfirm: (date) {
                            print('confirm $date');
                            setData(date);
                          },
                          // 当前时间
                          currentTime: DateTime.now(),
                          // 语言
                          locale: LocaleType.zh);
                    },
                    child: Text(
                      dateTime,
                      style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A)),
                    )),
                Image.asset(
                  "images/ic_arrow_down.png",
                  fit: BoxFit.scaleDown,
                  width: 16,
                  height: 16,
                ),
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
            children: [
              newCard1(),
              newCard2(),
              Container(height: 20),
            ],
          ),
        ));
  }
}
