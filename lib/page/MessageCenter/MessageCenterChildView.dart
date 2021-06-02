import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';

import 'package:hpfuapp/model/MessageModel.dart' as MessageModelNew;
import 'package:hpfuapp/model/MessageModel.dart';

import 'package:hpfuapp/utils/date_util.dart';
import 'package:hpfuapp/page/MessageCenter/FLEmptyView.dart';
import 'package:hpfuapp/utils/toast_util.dart';

class MessageCenterChildView extends StatefulWidget {
  MessageCenterChildView({Key key, this.type}) : super(key: key);
  final String type;

  @override
  _MessageCenterChildViewState createState() =>
      _MessageCenterChildViewState(type: type);
}

class _MessageCenterChildViewState extends State<MessageCenterChildView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final String type;
  _MessageCenterChildViewState({this.type});

  RefreshController refreshController = RefreshController(initialRefresh: true);
  ScrollController scrollController = ScrollController();
  List<MessageDetailModel> list;
  int pageNum = 1;
  static const int pageSize = 20;

  @override
  void initState() {
    super.initState();
  }

  void _requestDatas() {
    HttpManager().post(
      url: '/agent/AgentMessage/query',
      data: {
        "pageNum": '$pageNum',
        "pageSize": "$pageSize",
        "messageType": type == 'system_msg' ? "1" : '2', //1全局 2自己
        "readStatus": "",
      },
      successCallback: (data) {
        var page = MessageModelNew.MessageModel.fromJson(data);
        List<MessageDetailModel> mList =
            page.list.map((e) => MessageDetailModel.fromJson(e)).toList();

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
      tag: "message_center_refresh",
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
    if (_showEmpty()) { return 1; }
    if (list == null) { return 0; }
    return list.length;
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
    return SmartRefresher(
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
      child: ListView.builder(
        controller: this.scrollController,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()
        ),
        itemCount: _listItemCount(),
        itemBuilder: (context, index) {
          if (_showEmpty()) {
            return FLEmptyWidget();
          }
          MessageDetailModel model = list[index];
          return this.renderCell(model);
        },
      ),
    );
  }

  Widget renderCell(MessageDetailModel model) {
    return Container(
      // margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Color(0x00000000),
        // borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          this.renderTimeAndContent(model),
        ],
      ),
    );
  }

  Widget renderTimeAndContent(MessageDetailModel model) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffacacac),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: EdgeInsets.all(8),
            child: Text(
              '${DateUtil.getDateStrByMillisecond(model.createTime)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1f000000),
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(15, 12, 15, 20),
            margin: EdgeInsets.fromLTRB(30, 15, 30, 0),
            child: Column(
              children: [
                Text(
                  model.title ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  height: 8,
                ),
                Text(
                  model.content ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
