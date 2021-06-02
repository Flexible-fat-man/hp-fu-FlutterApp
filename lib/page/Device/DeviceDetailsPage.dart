import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hpfuapp/fm/components/DeviceListCell/FmDeviceListCell.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/DeviceDetails.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';

class DeviceDetailsPage extends StatefulWidget {
  final String deviceNo;

  const DeviceDetailsPage({Key key, this.deviceNo}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DeviceDetailsPageState();
  }
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  DeviceDetails deviceDetails;
  List<String> typeList = ['', '未考核', '考核已达标', '考核未达标'];
  void _initData() {
    print('deviceNo');
    print(widget.deviceNo);
    HttpManager().post(
      url: ApiHelper.deviceFind,
      data: {"containType": '1', 'deviceNo': widget.deviceNo},
      successCallback: (data) {
        print('data+++++++++++++++++++++++++++');
        print(data);
        setState(() {
          deviceDetails = DeviceDetails.fromJson(data);
        });
      },
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Widget itemWidget() {
    if (null == deviceDetails) return Container();

    return Container(
      child: Column(
        children: [
          FmDeviceListCell(
              title: '序列号', subtitle: deviceDetails.snNo, isCopy: true),
          FmDeviceListCell(title: '商户名称', subtitle: deviceDetails.memName),
          FmDeviceListCell(title: '商户编号', subtitle: deviceDetails.memNo),
          FmDeviceListCell(title: '商户手机号', subtitle: deviceDetails.memPhone),
          FmDeviceListCell(
              title: '交易总金额',
              subtitle: (deviceDetails.transAmtTotal / 100).toString()),
          // FmDeviceListCell(title: '综合类费率', subtitle: deviceDetails.compreRate),
          // FmDeviceListCell(title: '高端类费率', subtitle: deviceDetails.highRate),
          // FmDeviceListCell(title: '普通类费率', subtitle: deviceDetails.normalRate),
          // FmDeviceListCell(
          //     title: '云闪付小额/支付宝/微信费率', subtitle: deviceDetails.lowRate),
          FmDeviceListCell(
              title: '绑定状态',
              subtitle: deviceDetails.bindStatus == 1 ? '已绑定' : '未绑定'),
          FmDeviceListCell(title: '绑定时间', subtitle: deviceDetails.bindDate),
          FmDeviceListCell(
              title: '激活状态',
              subtitle: deviceDetails.enableStatus == 1 ? '已激活' : '未激活'),
          FmDeviceListCell(title: '激活时间', subtitle: deviceDetails.enableDate),
          FmDeviceListCell(title: '激活截止时间', subtitle: deviceDetails.untilDate),
          FmDeviceListCell(
              title: '激活达标奖励',
              subtitle: deviceDetails.enableTargeStatus == 1 ? "已达标" : "未达标"),
          FmDeviceListCell(
              title: '第一月奖励' + deviceDetails.monthFirst,
              subtitle: typeList[deviceDetails.monthFirstRewardStatus]),
          FmDeviceListCell(
              title: '第二月奖励' + deviceDetails.monthSecond,
              subtitle: typeList[deviceDetails.monthSecondRewardStatus]),
          FmDeviceListCell(
              title: '第三月奖励' + deviceDetails.monthThird,
              subtitle: typeList[deviceDetails.monthThirdRewardStatus]),
          FmDeviceListCell(
              title: '第四月奖励' + deviceDetails.monthFourth,
              subtitle: typeList[deviceDetails.monthFourthRewardStatus]),
          FmDeviceListCell(
              title: '第五月奖励' + deviceDetails.monthFifth,
              subtitle: typeList[deviceDetails.monthFifthRewardStatus]),
          FmDeviceListCell(
              title: '半年活跃奖励' +
                  deviceDetails.halfYearStart +
                  '-' +
                  deviceDetails.halfYearEnd,
              subtitle: typeList[deviceDetails.halfYearRewardStatus]),
          FmDeviceListCell(
              title: '年活跃奖励' +
                  deviceDetails.yearStart +
                  '-' +
                  deviceDetails.yearEnd,
              subtitle: typeList[deviceDetails.yearRewardStatus]),
        ],
      ),
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
            "详情",
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
              itemWidget(),
              Container(height: 20),
            ],
          ),
        ));
  }
}
