import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/model/Agent.dart';
import 'package:hpfuapp/model/EventFn.dart';
import 'package:hpfuapp/model/StatisticByDate.dart';
import 'package:hpfuapp/page/Device/PurchaseDevicePage.dart';
import 'package:hpfuapp/page/RankingList/RankingListMainPage.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/SharedPreferenceUtil.dart';
import 'package:hpfuapp/utils/date_util.dart';
import 'package:hpfuapp/utils/event_manager.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/utils/numer_util.dart';
import 'package:hpfuapp/utils/toast_util.dart';
import '../AuthName.dart';
import '../HomeAgentList.dart';
import '../MerchantManage.dart';
import 'package:hpfuapp/page/Withdraw/Withdraw.dart';
import '../MessageCenter/MessageCenterMainView.dart';
import '../TransactionInquiry/TransactionInquiryView.dart';
import '../Profits/ProfitsView.dart';
import 'package:hpfuapp/model/MessageModel.dart' as MessageModelNew;
import 'package:hpfuapp/model/MessageModel.dart';

class MenuItem {
  String text;
  Image image;

  Function call;

  MenuItem(this.text, this.image, this.call);
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Widget commonList(List<MenuItem> items) {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //设置四周边框
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: GridView(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, //横轴三个子widget
              childAspectRatio: 1.0 //宽高比为1时，子widget
              ),
          children: items
              .map((e) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      e.image,
                      Container(height: 10),
                      Text(
                        e.text,
                        style: TextStyle(
                            color: Color(0xFF4A4A4A),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ))
              .toList()),
    );
  }

  Agent agentBean;
  String sumOrderFee = "0.00";
  List<MessageDetailModel> msgList;
  var eventBusFn;

  /*
   * 弹出框
   */
  void showLoginDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              '提示',
              style: TextStyle(color: ColorHelper.primaryText, fontSize: 16),
            ),
            //可滑动
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  Text(
                    "登录过期，请重新登录",
                    style:
                        TextStyle(color: ColorHelper.primaryText, fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  '取消',
                  style:
                      TextStyle(color: ColorHelper.primaryText, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new TextButton(
                child: new Text(
                  '确定',
                  style:
                      TextStyle(color: ColorHelper.colorPrimary, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  SharedPreferenceUtil.clearToken();
                  RouterFluro.navigateTo(context, "/LoginPage", replace: true);
                },
              ),
            ],
          );
        });
  }

  void _initData() {
    /**
     * 个人信息
     */
    HttpManager().post(
      url: ApiHelper.AgentMe,
      data: {},
      successCallback: (data) {
        if (mounted){
          setState(() {
            agentBean = Agent.fromJson(data);
          });
        }
      },
      errorCallback: (HttpError error) {
        EasyLoading.showToast(error.message);
        if ("400" == error.code || "300" == error.code) {
          showLoginDialog();
        }
      },
    );
    String nowDate = DateUtil.getNowDateStr2();
    /**
     * 今日交易数据
     */
    HttpManager().post(
      url: ApiHelper.statisticByDate,
      data: {"dateStart": nowDate, "dateEnd": nowDate},
      successCallback: (data) {
        if (mounted){
          setState(() {
            StatisticByDate byDate = StatisticByDate.fromJson(data);
            sumOrderFee = NumberUtil.formatNum((byDate.sumTransAmt / 100));
          });
        }
      },
    );

    HttpManager().post(
      url: '/agent/AgentMessage/query',
      data: {
        "pageNum": '1',
        "pageSize": "20",
        "messageType": '1', //1全局 2自己
        "readStatus": "",
      },
      successCallback: (data) {
        var page = MessageModelNew.MessageModel.fromJson(data);
        List<MessageDetailModel> mList =
            page.list.map((e) => MessageDetailModel.fromJson(e)).toList();
        if (mounted){
          setState(() {
            msgList = mList;
          });
        }
      },
    );
  }

  @override
  void initState() {
    onEvent();
    _initData();
    super.initState();
  }

  void onEvent() {
    // 注册监听器，订阅 eventbus
    eventBusFn = EventManager().on<EventFn>().listen((event) {
      //  event为 event.obj 即为 eventBus.dart 文件中定义的 EventFn 类中监听的数据
      print(event.type);
      if ("home" == event.type) {
        _initData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    //取消订阅
    eventBusFn.cancel();
  }

  /*
   * 弹出框
   */
  void showAlertDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              '提示',
              style: TextStyle(color: ColorHelper.primaryText, fontSize: 16),
            ),
            //可滑动
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  Text(
                    "请前往“实名认证”页面绑定银行卡后进行操作",
                    style:
                        TextStyle(color: ColorHelper.primaryText, fontSize: 16),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  '取消',
                  style:
                      TextStyle(color: ColorHelper.primaryText, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new TextButton(
                child: new Text(
                  '确定',
                  style:
                      TextStyle(color: ColorHelper.colorPrimary, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AuthName();
                  }));
                },
              ),
            ],
          );
        });
  }

  /*
   * 交易金额
   */
  Widget topHome(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 15, top: 57, right: 15, bottom: 0),
          height: 173,
          //设置背景图片
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(
                "images/ic_home_bg.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        agentBean?.agentName ?? "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                      Container(height: 8),
//                      Row(
//                        children: <Widget>[
//                          Text(
//                            "当前分润等级",
//                            style: TextStyle(color: Colors.white, fontSize: 11),
//                          ),
//                          Container(width: 5),
//                          Stack(
//                            children: [
//                              Container(
//                                margin: EdgeInsets.only(
//                                    left: 0, top: 0, right: 0, bottom: 8),
//                                child: Image.asset(
//                                  "images/ic_home_v.png",
//                                  fit: BoxFit.fill,
//                                  width: 12,
//                                  height: 11,
//                                ),
//                              ),
//                              Container(
//                                margin: EdgeInsets.only(
//                                    left: 7, top: 2, right: 0, bottom: 0),
//                                child: Text(
//                                  "1",
//                                  style: TextStyle(
//                                      color: Color(0xFFFFAD20),
//                                      fontSize: 14,
//                                      fontWeight: FontWeight.w800),
//                                ),
//                              ),
//                            ],
//                          ),
//                          Container(width: 8),
//                          Text(
//                            "特权有效期：2099-12-31",
//                            style: TextStyle(color: Colors.white, fontSize: 11),
//                          ),
//                          Container(width: 10),
//                          Container(
//                            margin: EdgeInsets.only(
//                                left: 0, top: 2, right: 0, bottom: 0),
//                            child: Image.asset(
//                              "images/ic_home_arrow_white.png",
//                              fit: BoxFit.fill,
//                              width: 9,
//                              height: 14,
//                            ),
//                          ),
//                        ],
//                      )
                    ]),
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessageCenterMainView()));
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        "images/ic_home_xiaoxi.png",
                        fit: BoxFit.fill,
                        width: 24,
                        height: 24,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 20, top: 0, right: 0, bottom: 0),
                        width: (msgList != null && msgList.length > 0) ? 6 : 0,
                        height: (msgList != null && msgList.length > 0) ? 6 : 0,
                        decoration: new BoxDecoration(
                          //背景
                          color: Color(0xFFF95C35),
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 105,
          margin: EdgeInsets.only(left: 15, top: 124, right: 15, bottom: 0),
          padding: EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
          decoration: new BoxDecoration(
            //背景
            color: Colors.white,
            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            boxShadow: [BoxShadow(color: Color(0x1a257efc), blurRadius: 3)],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/ic_home_money.png",
                fit: BoxFit.fill,
                width: 50,
                height: 50,
              ),
              Container(width: 11),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sumOrderFee,
                      style: TextStyle(
                          color: Color(0xffF95C35),
                          fontSize: 26,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "今日交易金额(元)",
                      style: TextStyle(color: Color(0xffABACB4), fontSize: 14),
                    ),
                  ],
                ),
              ),
              InkWell(
                  //单击事件响应
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return TransactionInquiryView(
                        startDate: DateUtil.getNowDateStr3(),
                        endDate: '',
                      );
                    }));
                  },
                  child: Container(
                    height: 36,
                    width: 100,
                    decoration: new BoxDecoration(
                      //背景
                      color: Color(0xFFE8F0FD),
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    ),
                    child: Center(
                      child: Text(
                        "去查看",
                        style: TextStyle(
                            color: Color(0xFF257EFC),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }

  /*
   * 采购机具 我的订单
   */
  Widget newCard1(BuildContext context) {
    return Container(
      height: 99,
      margin: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //设置四周边框
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
//          Expanded(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                Image.asset(
//                  "images/ic_home_caigoujiju.png",
//                  fit: BoxFit.fill,
//                  width: 32,
//                  height: 32,
//                ),
//                Container(height: 10),
//                Text(
//                  "采购机具",
//                  style: TextStyle(
//                      color: Color(0xFF4A4A4A),
//                      fontSize: 12,
//                      fontWeight: FontWeight.w400),
//                ),
//              ],
//            ),
//          ),
//          Expanded(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                Image.asset(
//                  "images/ic_home_dingdan.png",
//                  fit: BoxFit.fill,
//                  width: 32,
//                  height: 32,
//                ),
//                Container(height: 10),
//                Text(
//                  "我的订单",
//                  style: TextStyle(
//                      color: Color(0xFF4A4A4A),
//                      fontSize: 12,
//                      fontWeight: FontWeight.w400),
//                ),
//              ],
//            ),
//          ),
          Expanded(
            child: InkWell(
                //单击事件响应
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return HomeAgentList();
                  }));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/ic_home_hehuoren.png",
                      fit: BoxFit.fill,
                      width: 32,
                      height: 32,
                    ),
                    Container(height: 10),
                    Text(
                      "合伙人",
                      style: TextStyle(
                          color: Color(0xFF4A4A4A),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )),
          ),
          Expanded(
            child: InkWell(
                //单击事件响应
                onTap: () {
                  if (agentBean != null) {
                    if (agentBean.settleName != "" &&
                        agentBean.settleMobile != "" &&
                        agentBean.settleIdCard != "" &&
                        agentBean.settleCardNo != "") {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return Withdraw();
                      }));
                    } else {
                      showAlertDialog();
                    }
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/ic_home_tixian.png",
                      fit: BoxFit.fill,
                      width: 32,
                      height: 32,
                    ),
                    Container(height: 10),
                    Text(
                      "去提现",
                      style: TextStyle(
                          color: Color(0xFF4A4A4A),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )),
          ),
          Expanded(
            child: InkWell(
                //单击事件响应
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MerchantManage();
                  }));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "images/ic_home_shanghu.png",
                      fit: BoxFit.fill,
                      width: 32,
                      height: 32,
                    ),
                    Container(height: 10),
                    Text(
                      "商户管理",
                      style: TextStyle(
                          color: Color(0xFF4A4A4A),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  /*
   * 系统消息
   */
  Widget newCard2() {
    if (msgList == null || msgList.length == 0) {
      return Container(
        height: 0,
      );
    }
    return Container(
      height: 44,
      margin: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
      decoration: new BoxDecoration(
        //背景
        color: Colors.white,
        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //设置四周边框
        border: new Border.all(width: 1, color: Colors.white),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MessageCenterMainView()));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 10),
            Container(
              width: 4,
              height: 4,
              decoration: new BoxDecoration(
                //背景
                color: Color(0xFFF95C35),
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
            ),
            Container(width: 8),
            Text(
              "系统消息",
              style: TextStyle(
                  color: Color(0xFF090807),
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
            Container(width: 10),
            Expanded(
              child: Text(
                "${msgList[0].content}",
                maxLines: 1,
                style: TextStyle(
                    color: Color(0xFF59585B),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Image.asset(
              "images/ic_mine_arrow.png",
              fit: BoxFit.fill,
              width: 9,
              height: 14,
            ),
            Container(width: 10),
          ],
        ),
      ),
    );
  }

  /*
   * 机具 排行榜
   */
  Widget newCard3(BuildContext context) {
    return Container(
        height: 200,
        margin: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 0),
        decoration: new BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          //设置四周边框
          border: new Border.all(width: 1, color: Colors.white),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                      //单击事件响应
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PurchaseDevicePage();
                        }));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/ic_home_jiju.png",
                            fit: BoxFit.fill,
                            width: 28,
                            height: 28,
                          ),
                          Container(height: 10),
                          Text(
                            "机具",
                            style: TextStyle(
                                color: Color(0xFF4A4A4A),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  child: InkWell(
                      //单击事件响应
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return RankingListMainPage();
                        }));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/ic_home_paihangbang.png",
                            fit: BoxFit.fill,
                            width: 28,
                            height: 28,
                          ),
                          Container(height: 10),
                          Text(
                            "排行榜",
                            style: TextStyle(
                                color: Color(0xFF4A4A4A),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                ),
//                Expanded(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      Image.asset(
//                        "images/ic_home_duihuan.png",
//                        fit: BoxFit.fill,
//                        width: 28,
//                        height: 28,
//                      ),
//                      Container(height: 10),
//                      Text(
//                        "兑换",
//                        style: TextStyle(
//                            color: Color(0xFF4A4A4A),
//                            fontSize: 12,
//                            fontWeight: FontWeight.w400),
//                      ),
//                    ],
//                  ),
//                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ProfitsView();
                      }));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/ic_home_shouyi.png",
                          fit: BoxFit.fill,
                          width: 28,
                          height: 28,
                        ),
                        Container(height: 10),
                        Text(
                          "收益",
                          style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                      //单击事件响应
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AuthName();
                        }));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/ic_home_renzheng.png",
                            fit: BoxFit.fill,
                            width: 28,
                            height: 28,
                          ),
                          Container(height: 10),
                          Text(
                            "实名认证",
                            style: TextStyle(
                                color: Color(0xFF4A4A4A),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      //TransactionInquiryView
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return TransactionInquiryView();
                      }));
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => TransactionInquiryView()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/ic_home_chaxun.png",
                          fit: BoxFit.fill,
                          width: 28,
                          height: 28,
                        ),
                        Container(height: 10),
                        Text(
                          "交易查询",
                          style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
//                      Image.asset(
//                        "images/ic_home_fenhong.png",
//                        fit: BoxFit.fill,
//                        width: 28,
//                        height: 28,
//                      ),
//                      Container(height: 10),
//                      Text(
//                        "大盘分红",
//                        style: TextStyle(
//                            color: Color(0xFF4A4A4A),
//                            fontSize: 12,
//                            fontWeight: FontWeight.w400),
//                      ),
                    ],
                  ),
                ),
//                Expanded(
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      Image.asset(
//                        "images/ic_home_dizhi.png",
//                        fit: BoxFit.fill,
//                        width: 28,
//                        height: 28,
//                      ),
//                      Container(height: 10),
//                      Text(
//                        "收货地址",
//                        style: TextStyle(
//                            color: Color(0xFF4A4A4A),
//                            fontSize: 12,
//                            fontWeight: FontWeight.w400),
//                      ),
//                    ],
//                  ),
//                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorHelper.backgroundColor,
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            children: [
              topHome(context),
              newCard1(context),
              newCard2(),
              newCard3(context),
              Container(height: 20),
//          commonList(l),
//          commonList(m)
            ],
          ),
        ));
  }
}
