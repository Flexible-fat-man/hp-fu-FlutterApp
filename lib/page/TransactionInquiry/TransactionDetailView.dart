import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';

import 'package:hpfuapp/model/Order.dart';
import 'package:hpfuapp/utils/date_util.dart';

class OrderDetailUIModel {
  String title;
  String detail;

  OrderDetailUIModel(this.title, this.detail);
}


class TransactionDetailView extends StatefulWidget {
  TransactionDetailView({Key key, this.orderModel}) : super(key: key);
  final OrderDetail orderModel;

  @override
  _TransactionDetailViewState createState() =>
      _TransactionDetailViewState(orderModel: orderModel);
}

class _TransactionDetailViewState extends State<TransactionDetailView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<OrderDetailUIModel> dataArray;

  final OrderDetail orderModel;
  _TransactionDetailViewState({this.orderModel});

  @override
  void initState() {
    initDatas();
    super.initState();
  }

  void initDatas() {
    this.dataArray = [
      OrderDetailUIModel('交易编号', orderModel.orderNo??''),
      OrderDetailUIModel('所属合伙人', orderModel.agentName??''),
      OrderDetailUIModel('商户名称', orderModel.memName??''),
      OrderDetailUIModel('商户编号', orderModel.memNo??''),
      OrderDetailUIModel('设备编号', orderModel.deviceNo??''),
      OrderDetailUIModel('交易方式', orderModel.transTypeText??''),
      OrderDetailUIModel('交易金额', '${orderModel.transAmt.toDouble()/100}元'),
      OrderDetailUIModel('交易银行卡', orderModel.cardNo??''),
      OrderDetailUIModel('到账时间', orderModel.transTypeFlag??''),
      OrderDetailUIModel('费率', orderModel.deviceRate??''),
      OrderDetailUIModel('手续费', '${orderModel.fee}元'),
      OrderDetailUIModel('创建时间', '${DateUtil.getDateStrByMillisecond(orderModel.createTime*1000)}'??''),
      OrderDetailUIModel('支付时间', DateUtil.getDateStr(orderModel.transDate, orderModel.transTime)??''),
    ];
  }

  @override
  void dispose() {
    print('>>>dispose');
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.backgroundColor,
      appBar: gfAppBar(),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        itemCount: dataArray.length,
        itemBuilder: (context, index) {
          OrderDetailUIModel model = dataArray[index];
          return this.renderCell(model);
        },
      ),
    );
  }

  Widget renderCell(OrderDetailUIModel model) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffffffff),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
        decoration: BoxDecoration(
            color: Color(0xffffffff),
            border: Border(bottom: BorderSide(width: 1, color: Color(0xfff6f6f6)))
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 12, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                model.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff383838),
                ),
              ),
              Text(
                model.detail,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffa1a1a1),
                ),
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
        "交易详情",
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
