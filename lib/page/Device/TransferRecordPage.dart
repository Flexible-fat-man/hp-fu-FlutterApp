import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hpfuapp/fm/components/card/FmCard.dart';
import 'package:hpfuapp/fm/components/cell/FmCell.dart';
import 'package:hpfuapp/fm/components/list/FmList.dart';
import 'package:hpfuapp/fm/components/wrap/FmWrap.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/model/TransferRecordPage.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/Page.dart' as PageNew;

class TransferRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransferRecordPageState();
  }
}

class _TransferRecordPageState extends State<TransferRecordPage> {
  bool isCheck = false;
  List<Widget> items = [];
  List<String> snNos = [];
  RefreshController _refreshController;
  int pageNum = 1;

  List<TransferRecord> beanList = [];

  List<Agent> allSonList = [];
  String transferPartner = ''; //选择的划拨合伙人
  String transferPartneragentNo = ''; //选择的划拨合伙人编号
  ScrollController _scrollController;

  void _initData() {
    HttpManager().post(
      url: ApiHelper.deviceTransferQuery,
      data: {
        "pageNum": pageNum.toString(),
        "pageSize": 20,
      },
      successCallback: (data) {
        var page = PageNew.Page.fromJson(data);
        List<TransferRecord> mList =
            page.list.map((e) => TransferRecord.fromJson(e)).toList();
        setState(() {
          if (mList != null) {
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
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
  }

  @override
  void initState() {
    _scrollController = new ScrollController();
    _refreshController = RefreshController();
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Widget itemWidget(TransferRecord transferRecord) {
    return FmWrap.only(
      top: 15,
      left: 15,
      right: 15,
      child: FmCard(
          body: FmList(
        children: [
          FmCell(
            title: '合伙人姓名',
            subtitle: transferRecord == null
                ? ''
                : transferRecord.agentName.toString(),
          ),
          FmCell(
            title: '合伙人编号',
            subtitle: transferRecord == null
                ? '0'
                : transferRecord.agentNo.toString(),
          ),
          FmCell(
            title: '下级合伙人',
            subtitle: transferRecord == null
                ? ''
                : transferRecord.subAgentName.toString(),
          ),
          FmCell(
            title: '下级合伙人编号',
            subtitle: transferRecord == null
                ? '0'
                : transferRecord.subAgentNo.toString(),
          ),
          FmCell(
            title: '类型',
            subtitle: transferRecord == null
                ? ''
                : transferRecord.actionType == 'transferAwayByList'
                    ? '划拨'
                    : '撤回',
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text('${transferRecord.remark}'),
              ],
            ),
          )
        ],
      )),
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
          "划拨记录",
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
    pageNum = 1;
    _initData();
  }

  _onLoading(BuildContext context) {
    pageNum++;
    _initData();
  }
}
