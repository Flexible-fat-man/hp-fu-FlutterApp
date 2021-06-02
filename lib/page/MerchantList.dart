import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/Device.dart';
import 'package:hpfuapp/utils/date_util.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/numer_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/Page.dart' as PageNew;
import 'MerchantDetails.dart';

class MerchantList extends StatefulWidget {
  final String minMoneyText;
  final String maxMoneyText;

  MerchantList(
      {Key key, @required this.minMoneyText, @required this.maxMoneyText})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MerchantListState(
        minMoneyText: minMoneyText, maxMoneyText: maxMoneyText);
  }
}

class _MerchantListState extends State<MerchantList> {
  final String minMoneyText;
  final String maxMoneyText;

  _MerchantListState({this.minMoneyText, this.maxMoneyText});

  List<Widget> items = [];
  RefreshController _refreshController;

  int pageNum = 1;

  List<Device> beanList = [];
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = new ScrollController();
    _refreshController = RefreshController();
    Future.delayed(Duration(milliseconds: 3000)).then((_) {
//      _jumpTo(0.0);
    });

    _initData();

    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _initData() {
    HttpManager().post(
      url: ApiHelper.DeviceQuery,
      data: {
        "bindStatus": "1",
        "minMoneyText": minMoneyText,
        "maxMoneyText": maxMoneyText,
        "pageNum": pageNum.toString(),
        "pageSize": "20",
        "containType": "7"
      },
      successCallback: (data) {
        var page = PageNew.Page.fromJson(data);
        List<Device> mList = page.list.map((e) => Device.fromJson(e)).toList();

        setState(() {
          if (mList != null && mList.isNotEmpty) {
            if (pageNum == 1) {
              beanList.clear();
            }
            beanList.addAll(mList);
          }
        });

        if (pageNum == 1) {
          this._refreshController.refreshCompleted();
        } else {
          if (mList != null && mList.length > 0) {
            this._refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        }
      },
    );
  }

  Widget itemWidget(Device bean) {
    return InkWell(
        //单击事件响应
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MerchantDetails(dateBean: bean);
          }));
        },
        child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Container(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "商户名称：" + bean.memName,
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                height: 8,
                              ),
                              Text(
                                "商户编号：" + bean.memNo,
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                height: 8,
                              ),
                              Text(
                                "设备编号：" + bean.deviceNo,
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                height: 8,
                              ),
                              Text(
                                "手机号码：" + bean.memPhone,
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                height: 8,
                              ),
                              Text(
                                "创建时间：" +
                                    DateUtil.getDateStr(
                                        bean.bindDate, bean.bindTime),
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                height: 8,
                              ),
                              Text(
                                "交易总金额：" +
                                    NumberUtil.formatNum(
                                        (bean.transAmtTotal / 100)) +
                                    "元",
                                style: TextStyle(
                                    color: ColorHelper.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 15,
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    WidgetHelper.lineHorizontal(),
                  ],
                )),
                Image.asset(
                  "images/ic_mine_arrow.png",
                  fit: BoxFit.fill,
                  width: 9,
                  height: 14,
                ),
                Container(width: 15),
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
          "商户列表",
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: ColorHelper.backgroundColor,
      body: Column(
        children: [
          WidgetHelper.lineHorizontal(),
          Expanded(child: Builder(
            builder: (c) {
              List<Widget> list = beanList.map((e) => itemWidget(e)).toList();

              return SmartRefresher(
                  child: ListView.builder(
                    itemBuilder: (c, i) => list[i],
                    controller: _scrollController,
                    reverse: false,
                    itemCount: list.length,
                  ),
                  onRefresh: _onRefresh,
                  onLoading: () {
                    _onLoading(c);
                  },
                  header: ClassicHeader(
                      releaseText: '松开刷新',
                      idleText: '下拉刷新',
                      refreshingText: '加载中...',
                      completeText: '加载成功',
                      refreshStyle: RefreshStyle.Follow),
                  footer: ClassicFooter(
                    canLoadingText: '松开加载',
                    idleText: '上拉加载',
                    loadingText: '加载中...',
                    noDataText: '没有更多数据',
                    loadStyle: LoadStyle.ShowAlways,
                  ),
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: _refreshController);
            },
          )),
        ],
      ),
    );
  }

  _onRefresh() {
    print("onRefresh");
    pageNum = 1;
    _initData();
  }

  _onLoading(BuildContext context) {
    print("onLoading");
    pageNum++;
    _initData();
  }
}
