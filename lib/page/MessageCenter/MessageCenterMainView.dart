import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'MessageCenterChildView.dart';

class MessageCenterMainView extends StatefulWidget {
  @override
  _MessageCenterMainViewState createState() => _MessageCenterMainViewState();
}

class _MessageCenterMainViewState extends State<MessageCenterMainView> {
  static const List<String> titles = ['系统消息', '我的消息'];
  String _value = titles[0];
  List<Widget> pageList = [
    MessageCenterChildView(type: 'system_msg'),
    MessageCenterChildView(type: 'mine_msg'),
  ];
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.backgroundColor,
      appBar: AppBar(
          title: CupertinoSegmentedControl(
        children: {
          titles[0]: Container(
            child: Text(
              titles[0],
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 13),
          ),
          titles[1]: Container(
            child: Text(
              titles[1],
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 13),
          ),
        },
        groupValue: _value,
        onValueChanged: (value) {
          print(value);
          setState(() {
            _value = value.toString();
            int page = titles.indexOf(_value);
            this.pageController.animateToPage(page,
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          });
        },
        selectedColor: Color(0xffffffff),
        unselectedColor: ColorHelper.colorPrimary,
        borderColor: Colors.white,
      )),
      body: Container(
        color: Color(0xFFEFEFEF),
        child: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: pageList.length,
          itemBuilder: (context, index) {
            return pageList[index];
          },
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            _value = titles[index];
            setState(() {
              //
            });
          },
          controller: this.pageController,
        ),
      ),
    );
  }
}
