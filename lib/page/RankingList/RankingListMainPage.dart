import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';

import 'RankingListPersonView.dart';
import 'RankingListTeamView.dart';

class RankingListMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RankingListPageState();
  }
}

class _RankingListPageState extends State<RankingListMainPage> {
  static const List<String> titles = ['团队排行榜', '个人排行榜'];
  String _value = titles[0];
  List<Widget> pageList = [
    RankingListTeamView(),
    RankingListPersonView(),
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
          elevation: 0.0,
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
