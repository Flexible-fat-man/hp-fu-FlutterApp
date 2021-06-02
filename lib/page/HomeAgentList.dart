import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/utils/date_util.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../model/Page.dart' as PageNew;
import 'SettleManage/SetSettle.dart';

class HomeAgentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeAgentListState();
  }
}


class _HomeAgentListState extends State<HomeAgentList> {
  List<Widget> items = [];
  RefreshController _refreshController;

  int pageNum = 1;

  List<Agent> beanList = [];
  ScrollController _scrollController;

  String conditionValue = "";
  final conditionValueController = TextEditingController();

  void _initData() {
    HttpManager().post(
      url: ApiHelper.AgentQuery,
      data: {
        "pageNum": pageNum.toString(),
        "conditionValue": conditionValue,
        "pageSize": 20,
        "containType": 2
      },
      successCallback: (data) {
        var page = PageNew.Page.fromJson(data);
        List<Agent> mList = page.list.map((e) => Agent.fromJson(e)).toList();

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
                        agent.agentName,
                        style: TextStyle(
                            color: ColorHelper.primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
                      Container(
                        height: 8,
                      ),
                      Text(
                        "手机号：" + agent.agentMobile,
                        style: TextStyle(
                            color: Color(0xff808080),
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                      Container(
                        height: 8,
                      ),
                      Text(
                        "创建时间：" +
                            DateUtil.getDateStrByMillisecond(
                                agent.createTime * 1000,
                                format: DateFormat.YEAR_MONTH_DAY),
                        style: TextStyle(
                            color: Color(0xff808080),
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  //单击事件响应
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return SetSettle(agentNo: agent.agentNo);
                      }));
                    },
                    child: Container(
                      height: 32,
                      width: 90,
                      decoration: new BoxDecoration(
                        border: Border.all(
                            color: ColorHelper.colorPrimary, width: 1), //边框
                        //背景
                        color: Colors.transparent,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                      ),
                      child: Center(
                        child: Text(
                          "结算管理",
                          style: TextStyle(
                              color: Color(0xFF257EFC),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    conditionValueController.addListener(() {

    });
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
          "合伙人",
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetHelper.lineHorizontal(),
          topSearch(context),
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
                      controller: conditionValueController,
                      style: TextStyle(color: Color(0xFF383838), fontSize: 14),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: "请输入合伙人姓名",
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
          InkWell(
            onTap: () {
              conditionValue = conditionValueController.text;
              pageNum = 1;
              _initData();
            },
            child: Text(
              "搜索",
              style: TextStyle(color: Color(0xFF383838), fontSize: 14),
            ),
          ),
          Container(
            width: 15,
          ),
        ],
      ),
    );
  }
}
