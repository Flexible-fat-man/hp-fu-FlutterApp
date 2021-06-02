import 'package:flutter/material.dart';

class FLEmptyWidget extends StatefulWidget {
  FLEmptyWidget(
      {this.topMargin});
  double topMargin;

  @override
  State<StatefulWidget> createState() => _FLEmptyListWidgetState(topMargin: topMargin = 90);
}

class _FLEmptyListWidgetState extends State<FLEmptyWidget> {
  final double topMargin;
  _FLEmptyListWidgetState({this.topMargin});

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, this.topMargin, 0, 0),
      child: Container(
        child: Column(
          children: [
            Image.asset(
              "images/ic_no_data_view.png",
              fit: BoxFit.fill,
              width: 90,
              height: 90,
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // Text(
            //   '暂无数据',
            //   style: TextStyle(
            //     fontSize: 15,
            //     color: Color(0xff9b9b9b),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}