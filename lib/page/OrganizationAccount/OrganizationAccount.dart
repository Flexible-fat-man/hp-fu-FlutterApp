import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/utils/numer_util.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';

import 'package:hpfuapp/model/ProfitModel.dart' as ProfitModelNew;
import 'package:hpfuapp/model/ProfitModel.dart';

import 'package:hpfuapp/utils/date_util.dart';

import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';

import 'package:flutter_picker/flutter_picker.dart';
import 'package:hpfuapp/page/Profits/ProfitsHelper.dart';
import 'package:hpfuapp/page/MessageCenter/FLEmptyView.dart';
import 'package:hpfuapp/utils/toast_util.dart';

import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/model/Agent.dart';

// ignore: must_be_immutable
class OrganizationAccount extends StatefulWidget {
  OrganizationAccount({Key key, this.startDate = '', this.endDate = ''})
      : super(key: key);
  String startDate;
  String endDate;

  @override
  _OrganizationAccountState createState() =>
      _OrganizationAccountState(startDate: startDate, endDate: endDate);
}

class _OrganizationAccountState extends State<OrganizationAccount>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String startDate;
  String endDate;
  _OrganizationAccountState({this.startDate, this.endDate});

  String profitsType;

  RefreshController refreshController = RefreshController(initialRefresh: true);
  ScrollController scrollController = ScrollController();
  List<ProfitDetailModel> list;
  int pageNum = 1;
  static const int pageSize = 20;

  Agent agentBean;

  @override
  void initState() {
    if (startDate.length == 0) {
      startDate = '2018-01-01';
    }
    if (endDate.length == 0) {
      endDate = DateUtil.getNowDateStr3();
    }
    if (profitsType == null || profitsType.length == 0) {
      profitsType = ProfitsHelper.profitsTypeList[0];
    }
    super.initState();
  }

  void _requestDatas() {
    HttpManager().post(
      url: '/agent/AgentMoney/query',
      data: {
        "pageNum": '$pageNum',
        "pageSize": "$pageSize",
        "dateStart": startDate.replaceAll('-', ''),
        "dateEnd": endDate.replaceAll('-', ''),
        'settleAccountType': '3',
      },
      successCallback: (data) {
        var page = ProfitModelNew.ProfitModel.fromJson(data);
        List<ProfitDetailModel> mList =
        page.list.map((e) => ProfitDetailModel.fromJson(e)).toList();

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
    if (_showEmpty()) { return 2 + 1; }
    if (list == null) { return 2; }
    return 2 + list.length;
  }

  @override
  void dispose() {
    // 听说没必要加这两行了
    this.scrollController.dispose();
    this.refreshController.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: gfAppBar(),
      body: SmartRefresher(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          controller: this.scrollController,
          itemCount: _listItemCount(), //this.list.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return this.withDrawCell();
            } else if (index == 1) {
              return this.dealTitleCell(context);
            } else {
              if (_showEmpty()) {
                return FLEmptyWidget();
              }
              ProfitDetailModel model = list[index - 2];
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
          height: 15,
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
                        '创建时间',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff383838),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '收益金额',
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

  Widget dealListCell(BuildContext context, ProfitDetailModel model) {
    return Container(
      color: Colors.white,
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateUtil.getDateStrByMillisecond(model.createTime * 1000)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff4a4a4a),
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Text(
                    '备注：${model.remark}',
                    maxLines: 100,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xffa1a1a1),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 15,
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${NumberUtil.formatNum(model.money.toDouble()/100)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xfff4261c),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  height: 5,
                ),
                // Text(
                //   '收益类型：${model.moneyType}',
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Color(0xffd5c07b),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget withDrawCell() {
    return Container(
        child: Container(
          height: 106,
          //设置背景图片
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(
                "images/ic_withdraw_bg.png",
              ),
              fit: BoxFit.fill,
            ),
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
                          color: Colors.white, fontSize: 20),
                    ),
                    Container(
                      height: 5,
                    ),
                    Text(
                      "分润可提现",
                      style: TextStyle(
                          color: Colors.white, fontSize: 14),
                    )
                  ],
                ),
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
                          color: Colors.white, fontSize: 20),
                    ),
                    Container(
                      height: 5,
                    ),
                    Text(
                      "返现可提现",
                      style: TextStyle(
                          color: Colors.white, fontSize: 14),
                    )
                  ],
                ),
              ),
            ],
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
        "机构账户",
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
}
