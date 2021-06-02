import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';

// ignore: camel_case_types
class CountdownButtonStyle {
  CountdownButtonStyle({
    this.normalText = '点击获取',
    this.countingText = '已发送',
    this.normalColor = const Color(0xff257efc),
    this.disabledColor = const Color(0xff7cb1fd),
    this.buttonSize = const Size(66,22),
    this.enabled = true,
  });

  String normalText;
  String countingText;
  Color normalColor;
  Color disabledColor;
  Size buttonSize;
  bool enabled;
}

// ignore: must_be_immutable
class InputBoxContainer extends StatefulWidget {
  InputBoxContainer({
    Key key,
    this.onChange,
    this.onLeftTap,
    this.onRightTap,
    this.leftImage,
    this.rightImage,
    this.leftImageSize = _size,
    this.rightImageSize = _size,
    this.placeholder,
    // 隐藏内容，默认false(不隐藏)
    this.obscureText = false,
    this.maxLength,
    this.keyboardType,
    // 只要设置了此属性，右边就会固定显示倒计时按钮
    this.countdownStyle,
    this.onCountdownTap
  }) : super(key: key);

  final onChange;
  final onLeftTap;
  final onRightTap;
  String leftImage;
  String rightImage;
  Size leftImageSize;
  Size rightImageSize;
  String placeholder;
  bool obscureText;
  int maxLength;
  TextInputType keyboardType;
  CountdownButtonStyle countdownStyle;
  final onCountdownTap;

  static const double widgetH = 50.0;
  static const double allEdge = 5.0;
  static const _size = Size(widgetH-allEdge*2, widgetH-allEdge*2);

  @override
  State<StatefulWidget> createState() {
    return InputBoxContainerBuilder();
  }
}

class InputBoxContainerBuilder extends State<InputBoxContainer> {
  final screenW = window.physicalSize.width;
  final screenH = window.physicalSize.height;
  final widgetH = InputBoxContainer.widgetH;
  final baseEdge = InputBoxContainer.allEdge;

  // 设置countdownButton左右padding，是为了SizeBox不挤压button的文字空间
  static const double cdBtnHpadding = 5.0;
  // 验证码按钮右侧padding为14
  static const double cdBtnRightEdge = 14.0;

  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      setState(() {
        print(_inputController.text);
      });
    });
  }

  // 最小宽度限制为widgetH
  double _containerW() {
    double w = 0;

    double left = widget.leftImageSize.width+baseEdge*2;
    double leftW = left > widgetH ? left : widgetH;

    double right = widget.rightImageSize.width+baseEdge*2;
    double rightW = right > widgetH ? right : widgetH;

    w = max(leftW, rightW);

    if (widget.countdownStyle != null) {
      w = max(w, widget.countdownStyle.buttonSize.width+cdBtnHpadding+cdBtnRightEdge);
    }

    return w;
  }

  double _rightInsets() {
    double i = baseEdge;

    if (_containerW() > widgetH) {
      i = (_containerW() - widgetH)+baseEdge;
    }

    return i;
  }

  Widget build(BuildContext context) {
    return Container(
      height: widgetH,
      decoration: BoxDecoration(
          color: Color(0xfff3f2f7),
          borderRadius: BorderRadius.circular(widgetH),
          border: Border.all(
              width: 1.0,
              style: BorderStyle.solid,
              color: Color(0xfff3f2f7))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: _containerW(),
            height: widgetH,
            // color: Colors.grey,
            padding: EdgeInsets.fromLTRB(baseEdge, baseEdge, _rightInsets(), baseEdge),
            child: leftWidget(),
          ),
          Expanded(
              child: Center(
                child: centerTextField(),
              ),
          ),
          Container(
            width: _containerW(),
            height: widgetH,
            // color: Colors.grey,
            padding: EdgeInsets.fromLTRB(baseEdge, baseEdge, (widget.countdownStyle != null)?cdBtnRightEdge:baseEdge, baseEdge),
            child: rightWidget(),
          ),
        ],
      ),
    );
  }

  Widget centerTextField() {
    return TextField(
      controller: _inputController,
      cursorWidth: 2,
      textAlign: TextAlign.center,
      onChanged: widget.onChange,
      maxLength: widget.maxLength,
      maxLines: 1,
      obscureText: widget.obscureText??false,
      keyboardType: widget.keyboardType,
      style: TextStyle(
        textBaseline: TextBaseline.alphabetic,
        fontSize: 18,
        color: Color(0xff2a3247),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xfff3f2f7),
        border: InputBorder.none,
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          fontSize: 18,
          color: Color(0xffabacb4),
        ),
        counterText: '',
      ),
    );
  }

  Widget leftWidget() {
    if (widget.leftImage != null) {
      return InkWell(
        onTap: widget.onLeftTap,
        child: Center(
          child: Image.asset(
            widget.leftImage,
            width: widget.leftImageSize.width,
            height: widget.leftImageSize.height,
            fit: BoxFit.fill,
          ),
        ),
      );
    } else {
      return Container(width: widget.rightImageSize.width);
    }
  }

  Widget rightWidget() {
    if (widget.countdownStyle != null) {
      return countdownButton();
    }
    if (widget.rightImage != null) {
      return InkWell(
        onTap: widget.onRightTap,
        child: Center(
          child: Image.asset(
            widget.rightImage,
            width: widget.rightImageSize.width,
            height: widget.rightImageSize.height,
            fit: BoxFit.fill,
          ),
        ),
      );
    } else {
      return Container(width: widget.leftImageSize.width);
    }
  }

  Widget countdownButton() {
    if (widget.countdownStyle != null) {
      return Center(
        child: SizedBox(
          width: widget.countdownStyle.buttonSize.width+cdBtnHpadding*2,
          height: widget.countdownStyle.buttonSize.height,
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: cdBtnHpadding),
            minWidth: widget.countdownStyle.buttonSize.width,
            height: widget.countdownStyle.buttonSize.height,
            color: widget.countdownStyle.normalColor,
            highlightColor: widget.countdownStyle.disabledColor,
            disabledColor: widget.countdownStyle.disabledColor,
            textColor: Colors.white,
            disabledTextColor:Colors.white,
            colorBrightness: Brightness.dark,
            splashColor: Colors.grey,
            child: Text(
              _countdownText(),
              style: TextStyle(fontSize: 14),
            ),
            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.countdownStyle.buttonSize.height)),
            onPressed: widget.countdownStyle.enabled?widget.onCountdownTap:null,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  String _countdownText() {
    if (widget.countdownStyle.enabled) {
      return widget.countdownStyle.normalText;
    } else {
      return widget.countdownStyle.countingText;
    }
  }
}
