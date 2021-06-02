import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/utils/numer_util.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';

import 'package:hpfuapp/model/Order.dart' as OrderNew;
import 'package:hpfuapp/model/Order.dart';

import 'package:hpfuapp/model/StatisticByDate.dart';

import 'package:hpfuapp/utils/date_util.dart';

import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';

import 'package:flutter_picker/flutter_picker.dart';
import 'package:hpfuapp/page/TransactionInquiry/TransactionDetailView.dart';
import 'package:hpfuapp/page/MessageCenter/FLEmptyView.dart';
import 'package:hpfuapp/utils/toast_util.dart';

// ignore: must_be_immutable
class TransactionInquiryView extends StatefulWidget {
  TransactionInquiryView({Key key, this.startDate = '', this.endDate = ''})
      : super(key: key);
  String startDate;
  String endDate;

  @override
  _TransactionInquiryViewState createState() =>
      _TransactionInquiryViewState(startDate: startDate, endDate: endDate);
}

class _TransactionInquiryViewState extends State<TransactionInquiryView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String startDate;
  String endDate;

  _TransactionInquiryViewState({this.startDate, this.endDate});

  StatisticByDate _dailyDataModel;

  RefreshController refreshController = RefreshController(initialRefresh: true);
  ScrollController scrollController = ScrollController();
  List<OrderDetail> list;
  int pageNum = 1;
  static const int pageSize = 20;

  @override
  void initState() {
    if (startDate.length == 0) {
      startDate = '2018-01-01';
    }
    if (endDate.length == 0) {
      endDate = DateUtil.getNowDateStr3();
    }
    _dailyDataModel = StatisticByDate(countTransAmt: 0, sumTransAmt: 0);
    super.initState();
  }

  void _requestDatas() {
    HttpManager().post(
      url: '/agent/Order/query',
      data: {
        "pageNum": '$pageNum',
        "pageSize": "$pageSize",
        "dateStart": startDate.replaceAll('-', ''),
        "dateEnd": endDate.replaceAll('-', ''),
        "containType": "7",
      },
      successCallback: (data) {
        var page = OrderNew.Order.fromJson(data);
        List<OrderDetail> mList =
            page.list.map((e) => OrderDetail.fromJson(e)).toList();

        setState(() {
          if (list == null) { list = []; }

          if (mList != null) {
            if (pageNum == 1) {
              list.clear();
            }
            list.addAll(mList);
          }

          _requestCompletion(false,mList);
        });
      },
      errorCallback: (HttpError error) {
        _requestCompletion(true);
        Toast.toast(context, error.message);
      },
      tag: "trans_inquiry_refresh",
    );

    HttpManager().post(
      url: ApiHelper.statisticByDate,
      data: {
        "dateStart": startDate.replaceAll('-', ''),
        "dateEnd": endDate.replaceAll('-', ''),
        "containType": "7",
      },
      successCallback: (data) {
        var model = StatisticByDate.fromJson(data);
        _dailyDataModel = model;
        setState(() {});
      },
      errorCallback: (HttpError error) {
        Toast.toast(context, error.message);
      },
      tag: "trans_inquiry_money",
    );
  }

  void _requestCompletion(bool isError,[List items = const[]]) {
    if (refreshController.headerStatus == RefreshStatus.refreshing) {
      refreshController.refreshCompleted(resetFooterState: false);
    }
    if (refreshController.footerStatus == LoadStatus.loading) {
      refreshController.loadComplete();
    }
    if (isError) { return; }
    if (items == null) {
      refreshController.loadNoData();
    }
    if (items.length<pageSize) {
      refreshController.loadNoData();
    }
  }

  _headerRefresh() {
    if (refreshController.footerStatus == LoadStatus.loading) {
      refreshController.refreshCompleted();
      return;
    }
    pageNum = 1;
    _requestDatas();
  }

  _footerRefresh() {
    if (refreshController.headerStatus == RefreshStatus.refreshing) {
      refreshController.loadComplete();
      return;
    }
    pageNum++;
    _requestDatas();
  }

  bool _showEmpty() {
    if (list == null) { return false; }
    if (list.length == 0) { return true; }
    return false;
  }
  int _listItemCount() {
    if (_showEmpty()) { return 4 + 1; }
    if (list == null) { return 4; }
    return 4 + list.length;
  }

  @override
  void dispose() {
    print('>>>dispose');
    this.scrollController.dispose();
    this.refreshController.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.backgroundColor,
      appBar: gfAppBar(),
      body: SmartRefresher(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          controller: this.scrollController,
          itemCount: _listItemCount(), //this.list.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return this.headerCell(context);
            } else if (index == 1) {
              return this.searchCell(context);
            } else if (index == 2) {
              return this.timeAndMoneyCell(context);
            } else if (index == 3) {
              return this.dealTitleCell(context);
            } else {
              if (_showEmpty()) {
                return FLEmptyWidget();
              }
              OrderDetail model = list[index - 4];
              return this.dealListCell(context, model);
            }
          },
        ),
        controller: this.refreshController,
        onRefresh: _headerRefresh,
        onLoading: _footerRefresh,
        header: ClassicHeader(
          releaseText: '松开刷新',
          idleText: '下拉刷新',
          refreshingText: '加载中...',
          completeText: '加载成功',
          refreshStyle: RefreshStyle.Follow,
        ),
        footer: ClassicFooter(
          canLoadingText: '松开加载',
          idleText: '上拉加载',
          loadingText: '加载中...',
          noDataText: _showEmpty()?'暂无数据':'没有更多数据',
          loadStyle: LoadStyle.ShowAlways,
        ),
        enablePullDown: true,
        enablePullUp: true,
      ),
    );
  }

  Widget headerCell(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Color(0xff257efc),
      ),
      padding: EdgeInsets.fromLTRB(15, 30, 15, 15),
      child: Column(
        children: [
          Text(
            '${NumberUtil.formatNum(_dailyDataModel.sumTransAmt.toDouble() / 100)}',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            height: 10,
          ),
          Text(
            '本级交易总金额(元)',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Expanded(child: Container(),),
          Row(
            children: [
              Container(
                width: 5,
              ),
              Text(
                '提示：交易数据可能有一分钟延迟',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget searchCell(BuildContext context) {
    return Container(
      height: 0,
    );
    // return Container(
    //   height: 60,
    //   decoration: new BoxDecoration(
    //     //背景
    //     color: Colors.white,
    //   ),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Container(
    //         width: 15,
    //       ),
    //       Expanded(
    //         child: Container(
    //           height: 30,
    //           decoration: new BoxDecoration(
    //             //背景
    //             color: Color(0xFFF3F3F3),
    //             //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
    //             borderRadius: BorderRadius.all(Radius.circular(15.0)),
    //           ),
    //           child: Row(
    //             children: [
    //               Container(
    //                 width: 15,
    //               ),
    //               Image.asset(
    //                 "images/ic_shop_search.png",
    //                 fit: BoxFit.fill,
    //                 width: 14,
    //                 height: 14,
    //               ),
    //               Container(
    //                 width: 10,
    //               ),
    //               Expanded(
    //                 child: TextField(
    //                   style: TextStyle(color: Color(0xFF383838), fontSize: 14),
    //                   decoration: InputDecoration(
    //                     isCollapsed: true,
    //                     border: InputBorder.none,
    //                     hintText: "商户名搜索",
    //                     hintStyle:
    //                         TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
    //                   ),
    //                 ),
    //               ),
    //               Container(
    //                 width: 10,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Container(
    //         width: 15,
    //       ),
    //       Text(
    //         "搜索",
    //         style: TextStyle(color: Color(0xFF383838), fontSize: 14),
    //       ),
    //       Container(
    //         width: 15,
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget timeAndMoneyCell(BuildContext context) {
    return Container(
      height: 137,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: Text(
                  '当前时间筛选',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff4a4a4a),
                    fontWeight: FontWeight.w700,
                  ),
                )),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    print('时间选择');
                    showPickerDateRange(context);
                  },
                  child: Container(
                    width: 190,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$startDate 至 $endDate',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff4a4a4a),
                              ),
                            ),
                            Image.asset(
                              'images/ic_trade_arrow_down.png',
                              fit: BoxFit.fill,
                              width: 7.0,
                              height: 4.2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 24,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  moneyTitle('${NumberUtil.formatNum(_dailyDataModel.sumTransAmt.toDouble() / 100)}',
                      '交易总金额'),
                  verticalLine(1),
                  moneyTitle('${_dailyDataModel.countTransAmt}', '交易笔数'),
                  verticalLine(1),
                  moneyTitle(
                      '${_dailyDataModel.countTransAmt == 0 ? NumberUtil.formatNum(0) :
                      NumberUtil.formatNum((_dailyDataModel.sumTransAmt.toDouble() / _dailyDataModel.countTransAmt / 100))}',
                      '笔单价'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget moneyTitle(String money, String title) {
    return Container(
      width: 100,
      child: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            top: 0.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Text(
              '$money',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Color(0xfff4261c),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            top: 37.0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Text(
              '$title',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff4a4a4a),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ],
      ),
    );
  }

  Widget verticalLine(double width) {
    return Container(
      // margin: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      width: width,
      decoration: new BoxDecoration(
        //背景
        color: Color(0xffF2f2f2),
      ),
    );
  }

  Widget horizontalSpace(double height, Color color) {
    return Container(
      // margin: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
      height: height,
      decoration: new BoxDecoration(
        //背景
        color: color,
      ),
    );
  }

  Widget dealTitleCell(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: Color(0xfffafafa),
          ),
        ),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '商户交易时间',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff383838),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '交易金额',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff383838),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dealListCell(BuildContext context, OrderDetail model) {
    return InkWell(
      onTap: () {
        print('${model.transAmt}');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TransactionDetailView(
            orderModel: model,
          );
        }));
      },
      child: Container(
        color: Colors.white,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.memName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff4a4a4a),
                    ),
                  ),
                  Text(
                    '+${NumberUtil.formatNum(model.transAmt.toDouble() / 100)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xfff4261c),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              horizontalSpace(2, Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateUtil.getDateStr(model.transDate, model.transTime)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xffa1a1a1),
                    ),
                  ),
                  Text(
                    '${model.transTypeText}${model.transTypeFlag}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xffd5c07b),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gfAppBar() {
    return GFAppBar(
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
        "交易查询",
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF4A4A4A),
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }

  showPickerDateRange(BuildContext context) {
    Picker ps = Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
            type: PickerDateTimeType.kYMD, isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          DateTime dt = (picker.adapter as DateTimePickerAdapter).value;
          String startDt = DateUtil.getDateStrByDateTime3(dt);
          startDate = startDt;
          // 在下面的pe里刷新状态
          // setState(() {});
          print(startDt);
        });

    Picker pe = Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(
            type: PickerDateTimeType.kYMD, isNumberMonth: true),
        onConfirm: (Picker picker, List value) {
          DateTime dt = (picker.adapter as DateTimePickerAdapter).value;
          String endDt = DateUtil.getDateStrByDateTime3(dt);
          endDate = endDt;
          setState(() {
            refreshController.requestRefresh();
          });
          print(endDt);
        });

    List<Widget> actions = [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('取消')),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
            ps.onConfirm(ps, ps.selecteds);
            pe.onConfirm(pe, pe.selecteds);
          },
          child: Text('确定'))
    ];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("选择日期"),
            actions: actions,
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("开始日期:"),
                  ps.makePicker(),
                  Text("结束日期:"),
                  pe.makePicker()
                ],
              ),
            ),
          );
        });
  }
}
