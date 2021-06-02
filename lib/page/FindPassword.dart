import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hpfuapp/utils/toast_util.dart';
import 'package:getwidget/getwidget.dart';

import 'package:hpfuapp/page/LoginTextField/FLKeyboardDismiss.dart';
import 'package:hpfuapp/page/LoginTextField/InputBoxContainer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:hpfuapp/helper/ApiHelper.dart';

class FDConfirmButtonStyle {
  String normalImage;
  String disabledImage;
  Color normalTextColor;
  Color disabledTextColor;

  FDConfirmButtonStyle({
    this.normalImage = 'images/ic_login_button_enabled.png',
    this.disabledImage = 'images/ic_login_button_disabled.png',
    this.normalTextColor = const Color(0xff257efc),
    this.disabledTextColor = const Color(0xffabacb4),
  });
}

// 这是登录界面
class FindPassword extends StatefulWidget {
  @override
  _FindPasswordState createState() {
    return _FindPasswordState();
  }
}

class _FindPasswordState extends State<FindPassword> {
  Timer _timer;
  int _countdownValue = 60;

  FDConfirmButtonStyle btnStyle = FDConfirmButtonStyle();
  // 防止每次输入都setState消耗性能，出此下策
  bool allValid = false;

  String phoneNumber;
  String code;
  String password;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: gfAppBar(),
      body: bodyWidget(),
    );
  }

  Widget gfAppBar() {
    return GFAppBar(
      leading: GFIconButton(
        icon: Image.asset(
          "images/ic_back_white.png",
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
      brightness: Brightness.dark,
      title: Text(
        "忘记密码",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      backgroundColor: Color(0xff257efc),
    );
  }

  Widget bodyWidget() {
    return SingleChildScrollView(
      child: InkWell(
        onTap: (){
          FLKeyboardDismiss.dismiss(context);
        },
        child: Center(
          child: Container(
            // InkWell的上下都设置颜色后，就不会有水波纹效果了
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(38, 80, 38, 0),
            child: Column(
              children: [
                Text(
                  '请修改您的密码',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2a3247),
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                InputBoxContainer(
                  maxLength: 11,
                  placeholder: '手机号码',
                  keyboardType: TextInputType.phone,
                  onChange: (value){
                    print('phone:'+'$value');
                    phoneNumber = value;
                    // setState(() {});
                    setStateIfNeeded();
                  },
                ),
                SizedBox(height: 10,),
                InputBoxContainer(
                  rightImageSize: Size(66, 22),
                  maxLength: 6,
                  placeholder: '验证码',
                  keyboardType: TextInputType.phone,
                  countdownStyle: CountdownButtonStyle(
                    normalText: '点击获取',
                    countingText: '$_countdownValue'+'秒',
                    enabled: (_timer!=null &&_timer.isActive)?false:true,
                  ),
                  onChange: (value){
                    print('code:'+'$value');
                    code = value;
                    // setState(() {});
                    setStateIfNeeded();
                  },
                  onCountdownTap: (){
                    sendCode();
                  },
                ),
                SizedBox(height: 10,),
                InputBoxContainer(
                  obscureText: true,
                  maxLength: 20,
                  placeholder: '新密码',
                  keyboardType: TextInputType.text,
                  onChange: (value){
                    print('password:'+'$value');
                    password = value;
                    // setState(() {});
                    setStateIfNeeded();
                  },
                ),
                SizedBox(height: 40,),
                confirmBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmBtn() {
    return InkWell(
      onTap: (){
        confirmClick();
      },
      child: Column(
        children: [
          SizedBox(
            width: 66,
            height: 66,
            child: Image.asset(
              allConfirmed()?btnStyle.normalImage:btnStyle.disabledImage,
            ),
          ),
          SizedBox(height: 20,),
          Text(
            '确认修改',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: allConfirmed()?btnStyle.normalTextColor:btnStyle.disabledTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // Widget confirmBtn() {
  //   return SizedBox(
  //     width: 280,
  //     height: 40,
  //     child: FlatButton(
  //       padding: EdgeInsets.symmetric(horizontal: 5),
  //       color: Color(0xff257efc),
  //       textColor: Colors.white,
  //       colorBrightness: Brightness.dark,
  //       splashColor: Colors.grey,
  //       child: Text(
  //         '确认修改',
  //         style: TextStyle(fontSize: 15),
  //       ),
  //       shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
  //       onPressed: (){
  //         confirmClick();
  //       },
  //     ),
  //   );
  // }


  void startTimer() {
    final Duration duration = Duration(seconds: 1);
    cancelTimer();

    _timer = Timer.periodic(duration, (timer) {
      _countdownValue = _countdownValue - 1;
      if (this.mounted) {
        setState(() {
          // 判断是否被渲染，渲染后才能setState
        });
      }
      if (_countdownValue <= 0) {
        cancelTimer();
        _countdownValue = 60;
      }
    });
  }
  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void confirmClick() {
    if (allConfirmed(showToast: true) == false) { return; }

    _changePasswordRequest();
  }

  void sendCode() {
    if (validatePhone(showToast:true) == false) { return; }

    _sendCodeRequest();
  }

  void setStateIfNeeded() {
    bool currentValid = allConfirmed();
    if (currentValid != allValid) {
      print('refresh');
      setState(() {

      });
    }
    allValid = currentValid;
  }

  bool allConfirmed({bool showToast = false}) {
    if (validatePhone(showToast:showToast) == false) { return false; }
    if (validateCode(showToast:showToast) == false) { return false; }
    if (validatePassword(showToast:showToast) == false) { return false; }
    return true;
  }

  bool validatePhone({bool showToast = false}) {
    if (phoneNumber == null) {
      if (showToast) { EasyLoading.showToast('请输入手机号码'); }
      return false;
    }
    if (phoneNumber.length != 11) {
      if (showToast) { EasyLoading.showToast('请输入正确的手机号码'); }
      return false;
    }
    return true;
  }
  bool validateCode({bool showToast = false}) {
    if (code == null ||
        code.length == 0) {
      if (showToast) { EasyLoading.showToast('请输入验证码'); }
      return false;
    }
    return true;
  }
  bool validatePassword({bool showToast = false}) {
    if (password == null ||
        password.length == 0) {
      if (showToast) { EasyLoading.showToast('请输入新密码'); }
      return false;
    }
    return true;
  }

  void _sendCodeRequest() {
    EasyLoading.show();
    HttpManager().post(
      url: ApiHelper.sendVerifyCode,
      data: {
        "mobile": phoneNumber,
        "type": "3",
      },
      successCallback: (data) {
        startTimer();
        setState(() {});
        EasyLoading.dismiss();
        EasyLoading.showToast('验证码已发送');
      },
      errorCallback: (HttpError error) {
        EasyLoading.dismiss();
        Toast.toast(context, error.message);
      },
    );
  }

  void _changePasswordRequest() {
    EasyLoading.show();
    HttpManager().post(
      url: '/index/Callback/forgetPassword',
      data: {
        "mobile": phoneNumber,
        "code": code,
        "password": password,
      },
      successCallback: (data) {
        EasyLoading.dismiss();
        EasyLoading.showToast('修改成功');
        Navigator.pop(context);
      },
      errorCallback: (HttpError error) {
        EasyLoading.dismiss();
        Toast.toast(context, error.message);
      },
    );
  }


//   String agentMobile = "";
//   String agentCode = "";
//   String newpassword = "";
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool isButtonEnable = true; //按钮状态  是否可点击
//   String buttonText = '发送验证码'; //初始文本
//   int count = 60; //初始倒计时时间
//   Timer timer; //倒计时的计时器
//   TextEditingController mController = TextEditingController();
//   void _buttonClickListen() {
//     setState(() {
//       if (isButtonEnable) {
//         //当按钮可点击时
//         print('++++++++++++++++++++++++++++++++++++++');
//
//         isButtonEnable = false; //按钮状态标记
//         _initTimer();
//
//         return null; //返回null按钮禁止点击
//       } else {
//         print('----------------------------------------');
//         //当按钮不可点击时
// //        debugPrint('false');
//         return null; //返回null按钮禁止点击
//       }
//     });
//   }
//
//   void _initTimer() {
//     timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       count--;
//       setState(() {
//         if (count == 0) {
//           timer.cancel(); //倒计时结束取消定时器
//           isButtonEnable = true; //按钮可点击
//           count = 60; //重置时间
//           buttonText = '发送验证码'; //重置按钮文本
//         } else {
//           buttonText = '重新发送($count)'; //更新文本内容
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel(); //销毁计时器
//     timer = null;
//     mController?.dispose();
//     super.dispose();
//   }
//
//   ///post 登录
//   // void _ChangePassword() {
//   //   HttpManager().post(
//   //     url: ApiHelper.Accountlogin,
//   //     data: {
//   //       "agentMobile": agentMobile,
//   //       "agentCode": agentCode,
//   //       "newpassword": newpassword,
//   //     },
//   //     successCallback: (data) async {
//   //       AccessToken accessToken =
//   //           AccessToken.fromJson(Map<String, dynamic>.from(data));
//
//   //       SharedPreferences prefs = await SharedPreferences.getInstance();
//   //       prefs.setString('AccessToken', accessToken.accessToken);
//
//   //       RouterFluro.navigateTo(context, "/homepage/IndexPage", replace: true);
//   //     },
//   //     errorCallback: (HttpError error) {},
//   //     tag: "tag",
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       // 可以点击空白收起键盘
//       behavior: HitTestBehavior.translucent,
//       onTap: () {
//         FocusScope.of(context).requestFocus(FocusNode()); // 收起键盘
//       },
//       child: Container(
//           child: Scaffold(
//         appBar: GFAppBar(
//           title: Text(
//             "忘记密码",
//             style: TextStyle(fontSize: 16),
//           ),
//           // centerTitle: true,
//           backgroundColor: Colors.blue,
//         ),
//         body: Container(
//           // 所有内容都设置向内55
//           padding: EdgeInsets.all(10),
//           // 垂直布局
//           child: Column(
//             children: <Widget>[
//               Container(
//                 child: Text(
//                   '您好，',
//                   style: new TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//                 alignment: const Alignment(-1.0, 0.0),
//                 padding: EdgeInsets.fromLTRB(0, 80, 20, 0),
//               ),
//               Container(
//                 child: Text(
//                   '请修改您的密码',
//                   style: new TextStyle(
//                     // fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),
//                 alignment: const Alignment(-1.0, 0.0),
//                 padding: EdgeInsets.fromLTRB(0, 0, 20, 80),
//               ),
//               // 使用Form将两个输入框包起来 做控制
//               Form(
//                 key: _formKey,
//                 // Form里面又是一个垂直布局
//                 child: Column(
//                   children: <Widget>[
//                     // 输入手机号
//                     TextFormField(
//                       // 是否自动对焦
//                       autofocus: false,
//                       // 输入模式设置为手机号
//                       // keyboardType: TextInputType.phone,
//                       // 装饰
//
//                       decoration: InputDecoration(
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         hintText: '请输入手机号',
//                       ),
//                       onChanged: (value) {
//                         print('value');
//                         print(value);
//
//                         setState(() {
//                           agentMobile = value;
//                         });
//                         print(agentMobile);
//                       },
//                       // 输入框校验
//                       validator: (value) {
//                         RegExp reg = new RegExp(r'^\d{11}$');
//                         if (!reg.hasMatch(value)) {
//                           return '请输入11位手机号码';
//                         } else {
//                           print('value');
//                           print(value);
//                           agentMobile = value;
//                           // setState(() {});
//                         }
//                         return null;
//                       },
//                     ),
//
//                     // 间隔
//                     SizedBox(height: 20),
//
//                     Container(
//                       padding: EdgeInsets.only(left: 0, right: 10),
//                       child: Stack(
//                         children: <Widget>[
//                           Expanded(
//                             child: Padding(
//                               padding:
//                                   EdgeInsets.only(left: 0, right: 0, top: 0),
//                               child: TextFormField(
//                                 decoration: InputDecoration(
//                                   hintText: ('验证码'),
//                                   contentPadding: EdgeInsets.only(
//                                       left: 20, top: -5, bottom: 0),
//                                   hintStyle: TextStyle(
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 onChanged: (value) {
//                                   print('value');
//                                   print(value);
//
//                                   setState(() {
//                                     agentCode = value;
//                                   });
//                                   print(agentCode);
//                                 },
//                                 // 输入框校验
//                                 validator: (value) {
//                                   if (value.length < 5) {
//                                     return '请输入正确的验证码';
//                                   } else {
//                                     print('value');
//                                     print(value);
//                                     agentCode = value;
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: 0,
//                             child: Container(
//                               width: 120,
//                               child: TextButton(
//                                 onPressed: () {
//                                   print('widget.agentMobile');
//                                   print(agentMobile);
//                                   if (agentMobile != '') {
//                                     _buttonClickListen();
//                                     // setState(() {
//
//                                     // });
//                                   } else {
//                                     Toast.toast(context, "请输入手机号");
//                                   }
//                                 },
// //                        child: Text('重新发送 (${secondSy})'),
//                                 child: Text(
//                                   '$buttonText',
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//
//                     // 间隔
//                     SizedBox(height: 20),
//
//                     // 输入密码
//                     TextFormField(
//                       obscureText: true,
//                       // 是否自动对焦
//                       autofocus: false,
//                       // 输入模式设置为手机号
//                       keyboardType: TextInputType.visiblePassword,
//                       // 装饰
//                       decoration: InputDecoration(
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         hintText: '新密码(不超过20位)',
//                       ),
//                       // 输入框校验
//                       validator: (value) {
//                         if (value.length < 6) {
//                           return '请输入正确的密码';
//                         } else {
//                           newpassword = value;
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//
//               Container(
//                 height: 44,
//                 margin: EdgeInsets.fromLTRB(10, 80, 20, 80),
//                 width: MediaQuery.of(context).size.width - 50,
//                 decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(25)),
//                 child: TextButton(
//                   child: Text(
//                     '确认修改',
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   onPressed: () {
//                     print('agentMobile');
//                     print(agentMobile);
//                     if (_formKey.currentState.validate()) {
//                       print('登录啊啊啊啊');
//                       print('agentMobile');
//
//                       print(agentMobile);
//                       print('agentCode');
//                       print(agentCode);
//                       print('newpassword');
//                       print(newpassword);
//                       // _ChangePassword();
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       )),
//     );
//   }
}
