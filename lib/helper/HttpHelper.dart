import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/ShowJson.dart';

class HttpHelper {
  static void post(
      String url, Map<String, dynamic> param, Function successCall) async {
    Options options =
        Options(headers: {"content-type": "application/x-www-form-urlencoded"});

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken = prefs.getString('AccessToken').toString();
      param["accessToken"] = accessToken;

      Response response = await Dio().post(url, data: param, options: options);

      ShowJson res = ShowJson.fromJson(
          new Map<String, dynamic>.from(jsonDecode(response.toString())));

      if (res.code != 200) {
        print(res.msg);
      } else {
        print(res.data.runtimeType);
        successCall(new Map<String, dynamic>.from(res.data));
      }
    } catch (e, d) {
      print("postHttp: Exception: $e");
      print(d);
    }
  }
}
