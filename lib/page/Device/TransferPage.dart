import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hpfuapp/fm/components/card/FmCard.dart';
import 'package:hpfuapp/fm/components/cell/FmCell.dart';
import 'package:hpfuapp/fm/components/list/FmList.dart';
import 'package:hpfuapp/fm/components/wrap/FmWrap.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/helper/PrefixHelper.dart';
import 'package:hpfuapp/helper/WidgetHelper.dart';
import 'package:hpfuapp/model/DeviceStatistics.dart';
import 'package:hpfuapp/model/Transfer.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/numer_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../model/Page.dart' as PageNew;

class TransferPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransferPageState();
  }
}

class _TransferPageState extends State<TransferPage> {
  List<Widget> items = [];
  RefreshController _refreshController;
  int pageNum = 1;

  List<Transfer> beanList = [];
  ScrollController _scrollController;

  void _initData() {
    HttpManager().post(
      url: ApiHelper.devicestatiSticBySonAgent,
      data: {"pageNum": pageNum.toString(), "pageSize": 20},
      successCallback: (data) {
        setState(() {
          beanList =
              (data as List<dynamic>).map((e) => Transfer.fromJson(e)).toList();
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
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Widget itemWidget(Transfer transfer) {
    return FmWrap.only(
      top: 15,
      left: 15,
      right: 15,
      child: FmCard(
          body: FmList(
        children: [
          FmCell(
            title: '名称',
            subtitle: transfer == null ? '0' : transfer.agentName.toString(),
          ),
          FmCell(
            title: '编号',
            subtitle: transfer == null ? '0' : transfer.agentNo.toString(),
          ),
          FmCell(
            title: transfer == null
                ? '未激活未绑定'
                : transfer.unEnableAndUnBindText.toString(),
            subtitle:
                transfer == null ? '0' : transfer.unEnableAndUnBind.toString(),
            // isLink: true,
            // onTapCall: () => RouterFluro.navigateTo(context,
            //     "/NoActivationPage?enableStatus=2&bindStatus=2&containType=1"),
          ),
          FmCell(
            title: transfer == null
                ? '未激活已绑定'
                : transfer.unEnableAndBindText.toString(),
            subtitle:
                transfer == null ? '0' : transfer.unEnableAndBind.toString(),
            // isLink: true,
            // onTapCall: () => RouterFluro.navigateTo(context,
            //     "/ActivationPage?enableStatus=2&bindStatus=1&containType=1"),
          ),
          FmCell(
            title: transfer == null
                ? '已激活未绑定'
                : transfer.enableAndUnBindText.toString(),
            subtitle:
                transfer == null ? '0' : transfer.enableAndUnBind.toString(),
            // isLink: true,
            // onTapCall: () => RouterFluro.navigateTo(context,
            //     "/ActivationPage?enableStatus=1&bindStatus=2&containType=1"),
          ),
          FmCell(
            title: transfer == null
                ? '已激活已绑定'
                : transfer.enableAndBindText.toString(),
            subtitle:
                transfer == null ? '0' : transfer.enableAndBind.toString(),
            // isLink: true,
            // onTapCall: () => RouterFluro.navigateTo(context,
            //     "/ActivationPage?enableStatus=1&bindStatus=1&containType=1"),
          ),
          FmCell(
            title: transfer == null ? '所有' : transfer.allText.toString(),
            subtitle: transfer == null ? '0' : transfer.all.toString(),
          ),
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
          "已划拨合伙人",
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: ColorHelper.backgroundColor,
      body: Column(
        children: [
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
                  // onLoading: () {
                  //   _onLoading(c);
                  // },
                  // header: ClassicHeader(
                  //     releaseText: '松开刷新',
                  //     idleText: '下拉刷新',
                  //     refreshingText: '加载中...',
                  //     completeText: '加载成功',
                  //     refreshStyle: RefreshStyle.Follow),
                  // footer: ClassicFooter(
                  //   canLoadingText: '松开加载',
                  //   idleText: '上拉加载',
                  //   loadingText: '加载中...',
                  //   noDataText: '没有更多数据',
                  //   loadStyle: LoadStyle.ShowAlways,
                  // ),
                  // enablePullDown: true,
                  // enablePullUp: true,
                  controller: _refreshController);
            },
          )),
          // WidgetHelper.lineHorizontal(),
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
