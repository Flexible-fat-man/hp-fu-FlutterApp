import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../model/Page.dart' as PageNew;

class LevelSubordinateActivationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LevelSubordinateActivationPageState();
  }
}

/*
   * 头部搜索栏
   */
Widget topSearch(BuildContext context) {
  return Container(
    height: 60,
    decoration: new BoxDecoration(
      //背景
      color: Colors.white,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 15,
        ),
        Expanded(
          child: Container(
            height: 30,
            decoration: new BoxDecoration(
              //背景
              color: Color(0xFFF3F3F3),
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 15,
                ),
                Image.asset(
                  "images/ic_shop_search.png",
                  fit: BoxFit.fill,
                  width: 14,
                  height: 14,
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Color(0xFF383838), fontSize: 14),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: "请输入序列号",
                      hintStyle:
                          TextStyle(color: Color(0xFFCCCCCC), fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 15,
        ),
        Text(
          "搜索",
          style: TextStyle(color: Color(0xFF383838), fontSize: 14),
        ),
        Container(
          width: 15,
        ),
      ],
    ),
  );
}

class _LevelSubordinateActivationPageState
    extends State<LevelSubordinateActivationPage> {
  List<Widget> items = [];
  RefreshController _refreshController;

  int pageNum = 1;

  List<Agent> beanList = [];
  ScrollController _scrollController;

  void _initData() {
    HttpManager().post(
      url: ApiHelper.AgentQuery,
      data: {"pageNum": pageNum.toString(), "pageSize": 20, "containType": 2},
      successCallback: (data) {
        var page = PageNew.Page.fromJson(data);
        List<Agent> mList = page.list.map((e) => Agent.fromJson(e)).toList();

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
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
  }

  @override
  void initState() {
    _scrollController = new ScrollController();
    _refreshController = RefreshController();
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Widget itemWidget(Agent agent) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: new BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5))),
      ),
      child: Row(
        children: [
          // FmDeviceListCell(
          //   title: "序列号",
          //   serialNumber: '000006026282552328',
          //   descriptive: '采购的机具',
          //   type: '高端类',
          //   subtitle: '复制',
          //   isLink: true,
          //   // onTapCall: ,
          // ),

          Container(
              width: 100,
              child: Column(
                children: [
                  Text('序列号',
                      style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                  Text(''),
                ],
              )),
          Expanded(
              child: InkWell(
            onTap: () => RouterFluro.navigateTo(context, "/DeviceDetailsPage"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 50,
                ),
                Container(
                  alignment: Alignment(-1, 0),
                  child: Text(
                    '00005002200420680050055388',
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 4, top: 2, right: 4, bottom: 2),
                        decoration:
                            new BoxDecoration(border: Border.all(width: 1)),
                        child: Text(
                          '采购的机具',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      Container(width: 10),
                      Container(
                        padding: EdgeInsets.only(
                            left: 4, top: 2, right: 4, bottom: 2),
                        decoration:
                            new BoxDecoration(border: Border.all(width: 1)),
                        child: Text(
                          '高端类',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
          Container(
            child: Column(
              children: [
                Text('复制',
                    style: TextStyle(color: Color(0xFFD5C07B), fontSize: 12))
              ],
            ),
          ),
          Container(
            child: Column(
              children: [Icon(Icons.chevron_right, color: Color(0xff999999))],
            ),
          )
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
          "机具",
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // WidgetHelper.lineHorizontal(),
          topSearch(context),
          // WidgetHelper.lineHorizontal(),
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

//    Future.delayed(Duration(milliseconds: 1000)).then((_) {
//      if (mounted) setState(() {});
//    });
  }

  _onLoading(BuildContext context) {
    print("onLoading");
    pageNum++;
    _initData();
//    Future.delayed(Duration(milliseconds: 1000)).then((_) {
//
//    });
  }
}
