import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ActivateToday.dart';
import 'TransToday.dart';

class RankingListTeamView extends StatefulWidget {
  @override
  _RankingListChildViewState createState() => _RankingListChildViewState();
}

class _RankingListChildViewState extends State<RankingListTeamView>
    with TickerProviderStateMixin {
  bool get wantKeepAlive => true;

  final List<String> _tabValues = ['今日交易', '今日激活', '上月交易', '上月激活'];
  TabController _controller;
  double toolbarHeight = 0.00;

  @override
  void initState() {
    _controller = TabController(
      length: _tabValues.length,
      vsync: this,
    );
    if (Platform.isIOS) {
      toolbarHeight = 50.00;
    }
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: toolbarHeight,
        elevation: 0,
        bottom: TabBar(
          tabs: _tabValues.map((f) {
            return Text(f);
          }).toList(),
          controller: _controller,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: false,
          labelPadding:
              EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          indicatorWeight: 3.0,
          labelStyle: TextStyle(fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 14),
        ),
      ),
      body: TabBarView(controller: _controller, children: [
        TransToday(type: 1),
        ActivateToday(type: 1),
        TransToday(type: 2),
        ActivateToday(type: 2),
      ]),
    );
  }
}
