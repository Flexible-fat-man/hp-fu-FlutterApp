import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:hpfuapp/helper/ColorHelper.dart';
import 'package:package_info/package_info.dart';

class AboutUs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutUsState();
  }
}

class _AboutUsState extends State<AboutUs> {
  String versionCode;

  @override
  void initState() {
    init();
    super.initState();
  }

  //初始化
  init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionCode = packageInfo.version.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
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
          "关于我们",
          style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: ColorHelper.backgroundColor,
      body: Column(
        children: [
          Container(
            height: 30,
          ),
          Image.asset(
            "images/ic_launcher.png",
            fit: BoxFit.fill,
            width: 60,
            height: 60,
          ),
          Container(
            height: 10,
          ),
          Text(
            "付临门助手",
            style: TextStyle(color: ColorHelper.secondaryText, fontSize: 12),
          ),
          Container(
            height: 5,
          ),
          Text(
            "当前版本  v" + versionCode,
            style: TextStyle(color: ColorHelper.secondaryText, fontSize: 12),
          ),
          Container(
            height: 40,
          ),
          Row(
            children: [
              Container(
                width: 30,
              ),
              Expanded(
                child: Text(
                  "\t\t\t付临门支付有限公司成立于2009年，隶属于银嘉金服集团，总部坐落于上海徐汇区天华信息科技园，2011年获得中国人民银行颁发的支付业务许可证，是国内线下支付领军企业。付临门以科技为核心，不断完善产品线，服务中小微商户和个人消费者，为服务实体经济，促进普惠金融做出积极贡献。\n\n\t\t\t付临门助手是付临门的战略合作平台，努力营造一个良性的、生态的新支付环境，解决现有支付环境的痛点与不足，让支付人真正拥有一个自己的创业平台。",
                  style:
                      TextStyle(color: ColorHelper.secondaryText, fontSize: 13),
                ),
              ),
              Container(
                width: 30,
              ),
            ],
          ),
          Expanded(child: Text("")),
          Text(
            "Copyright©2018-2020",
            style: TextStyle(color: ColorHelper.secondaryText, fontSize: 12),
          ),
          Text(
            "郑州万能帮信息技术有限公司",
            style: TextStyle(color: ColorHelper.secondaryText, fontSize: 12),
          ),
          Container(
            height: 5,
          ),
          Row(
            children: [
              Expanded(child: Text("")),
              Text(
                "《服务协议》",
                style: TextStyle(color: ColorHelper.colorPrimary, fontSize: 12),
              ),
              Text(
                "《隐私政策》",
                style: TextStyle(color: ColorHelper.colorPrimary, fontSize: 12),
              ),
              Expanded(child: Text("")),
            ],
          ),
          Container(
            height: 30,
          ),
        ],
      ),
    );
  }
}
