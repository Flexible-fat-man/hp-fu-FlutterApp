import 'package:fluro/fluro.dart';
import 'package:hpfuapp/page/AboutUs.dart';
import 'package:hpfuapp/page/Device/TransferRecordPage.dart';
import 'package:hpfuapp/page/FlmOrder.dart';
import 'package:hpfuapp/page/Performance/AllAgentList.dart';
import 'package:hpfuapp/page/Setting.dart';
import 'package:hpfuapp/page/SettleManage/MySettle.dart';
import 'package:hpfuapp/page/homepage/IndexPage.dart';

import '../page/ComponentsPage.dart';
import '../page/LoginPage.dart';
import '../page/FindPassword.dart';
import '../page/DevicePage.dart';
import '../page/Device/PurchaseDevicePage.dart';
import '../page/Device/PurchaseYsbDevicePage.dart';
import '../page/Device/ExchangeDevicePage.dart';
import '../page/Device/ActivationPage.dart';
import '../page/Device/NoActivationPage.dart';
import '../page/Device/TransferPage.dart';
import '../page/Device/DeviceListPage.dart';
import '../page/Device/DeviceDetailsPage.dart';
import '../page/Device/LevelSubordinateActivationPage.dart';
import '../page/OrganizationAccount/OrganizationAccount.dart';

class RouterFluro {
  static FluroRouter _router = FluroRouter();

  static void init() {
    Map<String, HandlerFunc> map = {
      "/OrganizationAccount": (context, Map params) => OrganizationAccount(),
      "/ComponentsPage": (context, Map params) => ComponentsPage(),
      "/LoginPage": (context, Map params) => LoginPage(),
      "/FindPassword": (context, Map params) => FindPassword(),
      "/AboutUs": (context, Map params) => AboutUs(),
      "/Setting": (context, Map params) => Setting(),
      "/DevicePage": (context, Map params) => DevicePage(),
      "/PurchaseDevicePage": (context, Map params) => PurchaseDevicePage(),
      "/PurchaseYsbDevicePage": (context, Map params) =>
          PurchaseYsbDevicePage(),
      "/ExchangeDevicePage": (context, Map params) => ExchangeDevicePage(),
      "/ActivationPage": (context, Map params) => ActivationPage(
            enableStatus: params['enableStatus'].first.toString(),
            bindStatus: params['bindStatus'].first.toString(),
            containType: params['containType'].first.toString(),
          ),
      "/NoActivationPage": (context, Map params) => NoActivationPage(
            enableStatus: params['enableStatus'].first.toString(),
            bindStatus: params['bindStatus'].first.toString(),
            containType: params['containType'].first.toString(),
          ),
      "/TransferPage": (context, Map params) => TransferPage(),
      "/TransferRecordPage": (context, Map params) => TransferRecordPage(),
      "/DeviceListPage": (context, Map params) => DeviceListPage(),
      "/DeviceDetailsPage": (context, Map params) => DeviceDetailsPage(
            deviceNo: params['deviceNo'].first.toString(),
          ),
      "/LevelSubordinateActivationPage": (context, Map params) =>
          LevelSubordinateActivationPage(),
      "/homepage/IndexPage": (context, Map params) => IndexPage(),
      "/FlmOrder": (context, Map params) => FlmOrder(),
      "/Performance/AllAgentList": (context, Map params) => AllAgentList(),
      "/SettleManage/MySettle": (context, Map params) => MySettle(),
    };

    map.forEach((key, value) {
      _router.define(key, handler: Handler(handlerFunc: value));
    });
  }

  static void navigateTo(context, String path,
      {bool replace = false, bool clearStack = false}) {
    _router.navigateTo(context, path, replace: replace, clearStack: clearStack);
  }
}
