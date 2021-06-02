import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hpfuapp/fm/components/cell/FmCell.dart';
import 'package:hpfuapp/fm/components/field/FmField.dart';
import 'package:hpfuapp/fm/componse/button/FmButtonShap.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/Device.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hpfuapp/fm/componse/button/FmButton.dart';
import 'package:hpfuapp/fm/element/FmColor.dart';
import '../../model/Page.dart' as PageNew;

class NoActivationPage extends StatefulWidget {
  final String enableStatus;
  final String bindStatus;
  final String containType;

  const NoActivationPage(
      {Key key, this.enableStatus, this.bindStatus, this.containType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NoActivationPageState();
  }
}

class _NoActivationPageState extends State<NoActivationPage> {
  bool isCheck = false;
  String hintTexts = "请输入序列号";
  List<Widget> items = [];
  List<String> snNos = [];
  RefreshController _refreshController;

  int pageNum = 1;

  List<Device> beanList = [];
  List<Agent> allSonList = [];
  String transferPartner = ''; //选择的划拨合伙人
  String transferPartneragentNo = ''; //选择的划拨合伙人编号
  String transferPartneragentNos = ''; //选择的划拨合伙人编号

  String snNoStart = ''; //开始编号
  String snNoEnd = ''; //结束编号
// ,snNoStart,snNoEnd
  ScrollController _scrollController;

  void _initData() {
    HttpManager().post(
      url: ApiHelper.DeviceQuery,
      data: {
        "pageNum": pageNum.toString(),
        "pageSize": 20,
        'enableStatus': widget.enableStatus,
        'bindStatus': widget.bindStatus,
        'containType': widget.containType
      },
      successCallback: (data) {
        var page = PageNew.Page.fromJson(data);
        List<Device> mList = page.list.map((e) => Device.fromJson(e)).toList();
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

  void _getagentQueryAllSon() {
    HttpManager().post(
      url: ApiHelper.agentQueryAllSon,
      data: {},
      successCallback: (data) {
        List<Agent> agentList = [];
        (data as List<dynamic>).forEach((element) {
          agentList.add(Agent.fromJson(Map.from(element)));
        });

        setState(() {
          _openModalBottomSheetAgent();
          allSonList = agentList.cast<Agent>();
        });
      },
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
  }

  // 连号
  void _getagentQueryAllSons() {
    HttpManager().post(
      url: ApiHelper.agentQueryAllSon,
      data: {},
      successCallback: (data) {
        List<Agent> agentList = [];
        (data as List<dynamic>).forEach((element) {
          agentList.add(Agent.fromJson(Map.from(element)));
        });

        setState(() {
          _openModalBottomSheetAgents();
          allSonList = agentList.cast<Agent>();
        });
      },
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
  }

  void _pushdeviceTransferAwayByNos() {
    HttpManager().post(
      url: ApiHelper.deviceTransferAwayByNos,
      data: {'childAgentNo': transferPartneragentNo, 'nos': jsonEncode(snNos)},
      successCallback: (data) {
        setState(() {
          snNos = [];
          transferPartner = ''; //选择的划拨合伙人
          transferPartneragentNo = ''; //选择的划拨合伙人编号
          _onRefresh();
        });
      },
      errorCallback: (HttpError error) {},
      tag: "tag",
    );
  }

  void _pushdeviceTransferAwayByNoss() {
    HttpManager().post(
      url: ApiHelper.deviceTransferAwayByList,
      data: {
        'childAgentNo': transferPartneragentNos,
        'snNoStart': snNoStart,
        'snNoEnd': snNoEnd
      },
      successCallback: (data) {
        setState(() {
          transferPartner = ''; //选择的划拨合伙人
          transferPartneragentNos = ''; //选择的划拨合伙人编号
          snNoStart = '';
          snNoEnd = '';
          _onRefresh();
        });
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

  Widget itemWidgets(Agent agent) {
    return Container(
      child: Column(
        children: [
          FmCell(
            height: 44,
            title: agent.agentName + '(${agent.agentMobile})',
            isLink: true,
            onTapCall: () {
              print(agent.agentName);
              setState(() {
                transferPartner = agent.agentName;
                transferPartneragentNo = agent.agentNo;
              });
              Navigator.pop(context, '取消');
              _openModalBottomSheet();
            },
          )
        ],
      ),
    );
  }

  Widget itemWidgets1(Agent agent) {
    return Container(
      child: Column(
        children: [
          FmCell(
            height: 44,
            title: agent.agentName + '(${agent.agentMobile})',
            isLink: true,
            onTapCall: () {
              print(agent.agentName);
              setState(() {
                transferPartner = agent.agentName;
                transferPartneragentNos = agent.agentNo;
              });
              Navigator.pop(context, '取消');
              _srialNumberTransfer();
            },
          )
        ],
      ),
    );
  }

  Future _openModalBottomSheet() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 44,
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Text(
                      '划拨给合伙人',
                      style: TextStyle(
                          color: ColorHelper.primaryText, fontSize: 16),
                    ),
                  ),
                ),
                WidgetHelper.lineHorizontal(),
                FmCell(
                  height: 44,
                  title: '选择合伙人',
                  subtitle: transferPartner,
                  isLink: true,
                  onTapCall: () {
                    Navigator.pop(context, '取消');
                    // 获取所以子级合伙人
                    _getagentQueryAllSon();
                  },
                ),
                WidgetHelper.lineHorizontal(),
                FmCell(
                  height: 44,
                  title: '当前数量',
                  subtitle: snNos.length.toString(),
                  isLink: false,
                ),
                WidgetHelper.lineHorizontal(),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 50),
                  child: FmButton(
                    title: '确认',
                    bgColor: FmColor.primary,
                    shap: FmButtonShap.pill,
                    onTap: () {
                      if (transferPartner != '') {
                        _pushdeviceTransferAwayByNos();
                        Navigator.pop(context, '取消');
                      } else {
                        Toast.toast(context, '请选择划拨的合伙人');
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });

    print(option);
  }

//  连号划拨
  Future _srialNumberTransfer() async {
    final option = await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 44,
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Center(
                      child: Text(
                        '连号划拨',
                        style: TextStyle(
                            color: ColorHelper.primaryText, fontSize: 16),
                      ),
                    ),
                  ),
                  WidgetHelper.lineHorizontal(),
                  FmField(
                    title: '开始编号',
                    placeholder: snNoStart,
                    onChange: (val) {
                      setState(() {
                        snNoStart = val;
                      });
                    },
                  ),
                  WidgetHelper.lineHorizontal(),
                  FmField(
                      title: '结束编号',
                      placeholder: snNoEnd,
                      onChange: (val) {
                        setState(() {
                          snNoEnd = val;
                        });
                      }),
                  WidgetHelper.lineHorizontal(),
                  FmCell(
                    height: 44,
                    title: '选择合伙人',
                    subtitle: transferPartner,
                    isLink: true,
                    onTapCall: () {
                      Navigator.pop(context, '取消');
                      // 获取所以子级合伙人
                      _getagentQueryAllSons();
                    },
                  ),
                  WidgetHelper.lineHorizontal(),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 50,bottom: 50),
                    child: FmButton(
                      title: '确认',
                      bgColor: FmColor.primary,
                      shap: FmButtonShap.pill,
                      onTap: () {
                        if (transferPartneragentNos != '') {
                          if (snNoStart != '' && snNoEnd != '') {
                            _pushdeviceTransferAwayByNoss();
                            Navigator.pop(context, '取消');
                          } else {
                            Toast.toast(context, '请选择输入开始或结束编号');
                          }
                        } else {
                          Toast.toast(context, '请选择合伙人');
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });

    print(option);
  }

  Future _openModalBottomSheetAgents() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<Widget> list = allSonList.map((e) => itemWidgets1(e)).toList();
          return Container(
            height: 600.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 44,
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Text(
                      '选择合伙人',
                      style: TextStyle(
                          color: ColorHelper.primaryText, fontSize: 16),
                    ),
                  ),
                ),
                WidgetHelper.lineHorizontal(),
                agentSearch(context),
                WidgetHelper.lineHorizontal(),
                Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: allSonList.length,
                    itemBuilder: (c, i) => list[i],
                  ),
                ),
              ],
            ),
          );
        });

    print(option);
  }

  Future _openModalBottomSheetAgent() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          List<Widget> list = allSonList.map((e) => itemWidgets(e)).toList();
          return Container(
            height: 600.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 44,
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: Text(
                      '选择合伙人',
                      style: TextStyle(
                          color: ColorHelper.primaryText, fontSize: 16),
                    ),
                  ),
                ),
                WidgetHelper.lineHorizontal(),
                agentSearch(context),
                WidgetHelper.lineHorizontal(),
                Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: allSonList.length,
                    itemBuilder: (c, i) => list[i],
                  ),
                ),
              ],
            ),
          );
        });

    print(option);
  }

  // 全选
  Widget _selectAllBtn(context) {
    List<String> arr = beanList.map((e) => e.snNo).toList();
    arr.sort();
    String s1 = arr.join(',');

    snNos.sort();
    String s2 = snNos.join(',');
    if (s1 == '' && s2 == '') {
      s1 = null;
    }

    return Container(
      child: Row(
        children: [
          Checkbox(
            value: s1 == s2,
            activeColor: ColorHelper.colorPrimary,
            onChanged: (bool val) {
              setState(() {
                if (val == true) {
                  snNos = beanList.map((e) => e.snNo).toList();
                } else {
                  snNos = [];
                }
              });
            },
          ),
          Text('全选')
        ],
      ),
    );
  }

/*
   * 选择合伙人筛选
   */
  Widget agentSearch(BuildContext context) {
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
                        hintText: hintTexts,
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
          _selectAllBtn(context),
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
                        hintText: hintTexts,
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

/*
   * 底部按钮
   */
  Widget buttonBtn(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: FmButton(
                  title: "选中划拨",
                  bgColor: FmColor.info,
                  shap: FmButtonShap.rectangle,
                  onTap: () {
                    print("自适应按钮被点击了");
                    print(snNos.length);
                    if (snNos.length != 0) {
                      transferPartner = '';
                      transferPartneragentNo = '';

                      _openModalBottomSheet();
                    } else {
                      Toast.toast(context, '请选择要划拨的机具');
                    }
                  },
                )),
                Expanded(
                    child: FmButton(
                  title: "连号划拨",
                  bgColor: FmColor.primary,
                  shap: FmButtonShap.rectangle,
                  onTap: () {
                    print("连号划拨");
                    // 连号划拨
                    _srialNumberTransfer();
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemWidget(Device device) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: new BoxDecoration(
        border: Border(
            bottom: BorderSide(width: 1, color: ColorHelper.dividerColor)),
      ),
      child: Row(
        children: [
          Container(
            child: Checkbox(
              value: snNos.contains(device.snNo),
              activeColor: ColorHelper.colorPrimary,
              onChanged: (bool val) {
                setState(() {
                  if (val == true) {
                    snNos.add(device.snNo);
                  } else {
                    snNos.remove(device.snNo);
                  }
                });
              },
            ),
          ),
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
            onTap: () => RouterFluro.navigateTo(
                context, "/DeviceDetailsPage?deviceNo=${device.deviceNo}"),
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
                    device.snNo,
                  ),
                ),
                Container(
                  alignment: Alignment(-1, 0),
                  child: Text(
                    device.untilDate == '' ? '' : '活动截止日期:' + device.untilDate,
                  ),
                ),
              ],
            ),
          )),
          Container(
            child: Text.rich(
                // children: [
                // Text('复制',
                //     style: TextStyle(color: Color(0xFFD5C07B), fontSize: 12))
                TextSpan(
              text: '复制',
              style: TextStyle(color: Color(0xFFD5C07B), fontSize: 12),
              // 设置点击事件
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print('object');
                  Clipboard.setData(new ClipboardData(text: device.snNo));
                  Toast.toast(context, "复制成功");
                },
            )
                // ],
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
          // WidgetHelper.lineHorizontal(),
          buttonBtn(context)
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
