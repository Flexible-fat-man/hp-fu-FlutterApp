import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:hpfuapp/model/AccessToken.dart';
import 'package:hpfuapp/model/User.dart';
import 'package:hpfuapp/router/RouterFluro.dart';
import 'package:hpfuapp/utils/SharedPreferenceUtil.dart';
import 'package:hpfuapp/utils/http/http_error.dart';
import 'package:hpfuapp/utils/http/http_manager.dart';
import 'package:package_info/package_info.dart';

import '../helper/ApiHelper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool isCheck = true;

  GlobalKey _globalKey = new GlobalKey(); //用来标记控件
  String _username = ""; //用户名
  String _password = ""; //密码
  String _version; //版本号
  bool _expand = false; //是否展示历史账号
  List<User> _users = new List(); //历史账号

  @override
  void initState() {
    super.initState();
    _getVersion();
    _gainUsers();
  }

  void _login() {
    EasyLoading.show();
    HttpManager().post(
      url: ApiHelper.Accountlogin,
      data: {
        "agentMobile": _username,
        "password": _password,
      },
      successCallback: (data) async {
        EasyLoading.dismiss();
        EasyLoading.showToast("登录成功");
        AccessToken accessToken =
            AccessToken.fromJson(Map<String, dynamic>.from(data));

        //保存历史账号
        SharedPreferenceUtil.saveUser(
            User(_username, _password), accessToken.accessToken);
        SharedPreferenceUtil.addNoRepeat(_users, User(_username, _password));

        RouterFluro.navigateTo(context, "/homepage/IndexPage", replace: true);
      },
      errorCallback: (HttpError error) {
        EasyLoading.dismiss();
        EasyLoading.showToast(error.message);
      },
      tag: "tag",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Flex(direction: Axis.vertical, children: <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      new Expanded(child: Text("")),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "images/ic_splash_logo.png",
                          fit: BoxFit.fill,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      new Expanded(child: Text("")),
                    ],
                  ),
                  flex: 3,
                ),
                _buildUsername(),
                _buildPassword(),
                _buildLoginButton(),
                Row(
                  children: <Widget>[
                    new Expanded(child: Text("")),
                    TextButton(
                      child: Text(
                        '忘记密码?',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        RouterFluro.navigateTo(context, "/FindPassword",
                            replace: false);
                        print('找回密码');
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 20),
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Text("版本号:$_version"),
                  ),
                  flex: 2,
                ),
              ]),
            ),
          ),
          Offstage(
            child: _buildListView(),
            offstage: !_expand,
          ),
        ],
      ),
    );
  }

  ///构建账号输入框
  Widget _buildUsername() {
    return TextField(
      key: _globalKey,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide()),
        contentPadding: EdgeInsets.all(8),
        fillColor: Colors.white,
        filled: true,
        hintText: "请输入手机号",
        prefixIcon: Icon(Icons.person_outline),
        suffixIcon: GestureDetector(
          onTap: () {
            if (_users.length > 1 || _users[0] != User(_username, _password)) {
              //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
              setState(() {
                _expand = !_expand;
              });
            }
          },
          child: _expand
              ? Icon(
                  Icons.arrow_drop_up,
                  color: Colors.red,
                )
              : Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
        ),
      ),
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: _username,
          selection: TextSelection.fromPosition(
            TextPosition(
              affinity: TextAffinity.downstream,
              offset: _username == null ? 0 : _username.length,
            ),
          ),
        ),
      ),
      onChanged: (value) {
        _username = value;
      },
    );
  }

  ///构建密码输入框
  Widget _buildPassword() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: TextField(
        decoration: InputDecoration(
          hintText: "请输入密码",
          border: OutlineInputBorder(borderSide: BorderSide()),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.all(8),
        ),
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: _password,
            selection: TextSelection.fromPosition(
              TextPosition(
                affinity: TextAffinity.downstream,
                offset: _password == null ? 0 : _password.length,
              ),
            ),
          ),
        ),
        onChanged: (value) {
          _password = value;
        },
        obscureText: true,
      ),
    );
  }

  ///构建历史账号ListView
  Widget _buildListView() {
    if (_expand) {
      List<Widget> children = _buildItems();
      if (children.length > 0) {
        RenderBox renderObject = _globalKey.currentContext.findRenderObject();
        final position = renderObject.localToGlobal(Offset.zero);
        double screenW = MediaQuery.of(context).size.width;
        double currentW = renderObject.paintBounds.size.width;
        double currentH = renderObject.paintBounds.size.height;
        double margin = (screenW - currentW) / 2;
        double offsetY = position.dy;
        double itemHeight = 30.0;
        double dividerHeight = 2;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: ListView(
            itemExtent: itemHeight,
            padding: EdgeInsets.all(0),
            children: children,
          ),
          width: currentW,
          height: (children.length * itemHeight +
              (children.length - 1) * dividerHeight),
          margin: EdgeInsets.fromLTRB(margin, offsetY + currentH, margin, 0),
        );
      }
    }
    return null;
  }

  ///构建历史记录items
  List<Widget> _buildItems() {
    List<Widget> list = new List();
    for (int i = 0; i < _users.length; i++) {
      if (_users[i] != User(_username, _password)) {
        //增加账号记录
        list.add(_buildItem(_users[i]));
        //增加分割线
        list.add(Divider(
          color: Colors.grey,
          height: 2,
        ));
      }
    }
    if (list.length > 0) {
      list.removeLast(); //删掉最后一个分割线
    }
    return list;
  }

  ///构建单个历史记录item
  Widget _buildItem(User user) {
    return GestureDetector(
      child: Container(
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(user.username),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.highlight_off,
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                setState(() {
                  _users.remove(user);
                  SharedPreferenceUtil.delUser(user);
                  //处理最后一个数据，假如最后一个被删掉，将Expand置为false
                  if (!(_users.length > 1 ||
                      _users[0] != User(_username, _password))) {
                    //如果个数大于1个或者唯一一个账号跟当前账号不一样才弹出历史账号
                    _expand = false;
                  }
                });
              },
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _username = user.username;
          _password = user.password;
          _expand = false;
        });
      },
    );
  }

  ///构建登录按钮
  Widget _buildLoginButton() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      width: double.infinity,
      child: FlatButton(
        height: 44,
        onPressed: () {
          _login();
        },
        child: Text("登录", style: TextStyle(color: Colors.white, fontSize: 16)),
        color: ColorHelper.colorPrimary,
        textColor: ColorHelper.colorPrimary,
        highlightColor: ColorHelper.colorPrimary,
      ),
    );
  }

  ///获取版本号
  void _getVersion() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = packageInfo.version;
      });
    });
  }

  ///获取历史用户
  void _gainUsers() async {
    _users.clear();
    _users.addAll(await SharedPreferenceUtil.getUsers());
    //默认加载第一个账号
    if (_users.length > 0) {
      _username = _users[0].username;
      _password = _users[0].password;
    }
  }
}
