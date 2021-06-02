import 'package:flutter/material.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/RankingList.dart';
import 'package:hpfuapp/utils/date_util.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';

class ActivateToday extends StatefulWidget {
  final int type;

  ActivateToday({Key key, @required this.type}) : super(key: key);

  @override
  _PageState createState() => _PageState(type: type);
}

class _PageState extends State<ActivateToday>
    with AutomaticKeepAliveClientMixin {
  final int type;

  _PageState({this.type});

  List<RankingList> beanList = [];

  // type== 1 团队日激活  2 团队月激活  3 个人日激活  4 个人月激活

  void _initData() {
    String requestUrl = "";
    var parmData = {};
    if (type == 1) {
      requestUrl = ApiHelper.groupDayDeviceRank;
    }
    if (type == 2) {
      parmData = {"month": DateUtil.getNowDateStr4()};
      requestUrl = ApiHelper.groupMonthDeviceRank;
    }
    if (type == 3) {
      requestUrl = ApiHelper.singleDayDeviceRank;
    }
    if (type == 4) {
      parmData = {"month": DateUtil.getNowDateStr4()};
      requestUrl = ApiHelper.singleMonthDeviceRank;
    }

    HttpManager().post(
      data: parmData,
      url: requestUrl,
      successCallback: (data) {
        List<RankingList> mList = (data as List<dynamic>)
            .map((e) => RankingList.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        setState(() {
          if (mList != null && mList.isNotEmpty) {
            beanList.addAll(mList);
          }
        });
      },
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Widget itemWidget(int index) {
    RankingList agent = beanList[index];

    return Container(
        child: Column(
      children: [
        Container(
          height: 50,
          child: Row(
            children: [
              Container(
                width: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: ColorHelper.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  agent.agentName,
                  style: TextStyle(
                      color: Color(0xff383838),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                agent.countEnableDate.toString() + "台",
                style: TextStyle(
                    color: Color(0xffF4261C),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                width: 15,
              )
            ],
          ),
        ),
        WidgetHelper.lineHorizontal(),
      ],
    ));
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Builder(
          builder: (c) {
            return ListView.builder(
              itemBuilder: (c, i) => itemWidget(i),
              reverse: false,
              itemCount: beanList.length,
            );
          },
        )),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
