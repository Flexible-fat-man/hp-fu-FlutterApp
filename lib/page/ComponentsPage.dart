import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../fm/components/card/FmCard.dart';
import '../fm/components/list/FmList.dart';
import '../fm/components/cell/FmCell.dart';
import '../fm/components/field/FmField.dart';
import '../fm/components/gap/FmGap.dart';

class ComponentsPage extends StatelessWidget {
  final String titleValue = "用户名";

  Widget _getCard() {
    return Container(
      child: Column(
        children: <Widget>[
          FmCard(
              header: _getCardBlock("header", double.infinity, Colors.red),
              body: _getCardBlock("body", double.infinity, Colors.green),
              footer: _getCardBlock("footer", double.infinity, Colors.blue),
              mode: FmCard.column),
          FmGap(),
          FmCard(
              header: _getCardBlock("header", 100, Colors.red),
              body: _getCardBlock("body", 100, Colors.green),
              footer: _getCardBlock("footer", 100, Colors.blue),
              mode: FmCard.row),
          FmGap(),
          FmCard(
              header: _getCardBlock("header", double.infinity, Colors.red),
              body: _getCardBlock("body", double.infinity, Colors.green),
              footer: _getCardBlock("footer", double.infinity, Colors.blue),
              mode: FmCard.stack),
        ],
      ),
    );
  }

  Widget _getCardBlock(String text, double width, Color color) {
    return Container(
      width: width,
      height: 44,
      color: color,
      child: Center(
          child: Text(
        text,
        style: TextStyle(color: Colors.white),
      )),
    );
  }

  Widget _getListCell() {
    return FmList(
      children: [
        FmCell(title: "Title", isLink: false),
        FmCell(title: "Link", isLink: true),
        FmCell(title: "Title subtitle", subtitle: "subtitle", isLink: true),
        FmCell(
            title: "Title Customize subtitle",
            subtitleWidget: Text("subtitleWidget")),
      ],
    );
  }

  Widget _getListField() {
    return FmList(
      children: [
        FmField(
            title: "用户名",
            placeholder: "请输入用户名",
            text: "zhangsan",
            onChange: (String text) {}),
        FmField(
            title: "密码",
            placeholder: "密码",
            text: "密码",
            onChange: (String text) {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFeeeeee),
        appBar: GFAppBar(
          title: Text(
            "组件",
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            FmGap(),
            _getCard(),
            FmGap(),
            _getListCell(),
            FmGap(),
            _getListField(),
            FmGap(),
            _getListField(),
          ]),
        ));
  }
}
