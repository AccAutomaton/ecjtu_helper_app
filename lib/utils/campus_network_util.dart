import 'dart:math';

import 'package:dio/dio.dart';
import 'package:ecjtu_helper/pages/campus_network.dart';
import 'package:flutter/foundation.dart';
import 'dio_util.dart';

logout() async {
  try {
    await dio.request(
        "http://172.16.2.100:801/eportal/?c=ACSetting&a=Logout&wlanuserip=null&wlanacip=null&wlanacname=null&port=&hostname=172.16.2.100&iTermType=1&session=null&queryACIP=0&mac=00-00-00-00-00-00");
  } on DioException {
    rethrow;
  }
}

login(String? username, String? password, int? operator) async {
  try {
    String loginPage =
        (await dio.request("http://172.16.2.100/")).data.toString();
    int v64ipLocation = loginPage.indexOf("v46ip");
    String restLoginPage = loginPage.substring(v64ipLocation + 7);
    int ipEnd = restLoginPage.indexOf("'");
    String ip = restLoginPage.substring(0, ipEnd);

    String operatorName = getOperatorName(operator!);
    await dio.request(
        "http://172.16.2.100:801/eportal/?c=ACSetting&a=Login&protocol=http:&hostname=172.16.2.100&iTermType=2&wlanuserip=$ip&wlanacip=null&wlanacname=null&mac=00-00-00-00-00-00&ip=$ip&enAdvert=0&queryACIP=0&loginMethod=1",
        data: {
          "DDDDD": ",1,$username@$operatorName",
          "upass": "$password",
          "R1": "0",
          "R2": "0",
          "R3": "0",
          "R6": "0",
          "para": "00",
          "0MKKey": "123456",
          "buttonClicked": "",
          "redirect_url": "",
          "err_flag": "",
          "username": "",
          "password": "",
          "user": "",
          "cmd": "",
          "Login": "",
        },
        options: Options(
          method: "post",
          contentType: Headers.formUrlEncodedContentType,
        ));
    if ((await dio.request("http://172.16.2.100/"))
        .data
        .toString()
        .contains("--Dr.COMWebLoginID_0.htm-->")) {
      throw DioException(
          requestOptions: RequestOptions(), message: "请检查用户名或密码以及运营商是否填写正确");
    }
  } on DioException {
    rethrow;
  }
}

Future<CampusNetworkUsageInformation> getUsageInformation() async {
  if (kDebugMode) {
    return CampusNetworkUsageInformation(
        CampusNetworkConnectionStatus.values[Random().nextInt(3)],
        Random().nextInt(60 * 24 * 4),
        Random().nextInt(1024 * 1024 * 1024),
        Random().nextInt(10000));
  }

  try {
    String page = (await dio.request("http://172.16.2.100/")).data.toString();
    if (page.contains("--Dr.COMWebLoginID_1.htm-->")) {
      int time = 0, flux = 0, balance = 0;

      int timeStart = page.indexOf("time");
      page = page.substring(timeStart + 6);
      int timeEnd = page.indexOf("'");
      time = int.parse(page.substring(0, timeEnd).trim());

      int fluxStart = page.indexOf("flow");
      page = page.substring(fluxStart + 6);
      int fluxEnd = page.indexOf("'");
      flux = int.parse(page.substring(0, fluxEnd).trim());

      int balanceStart = page.indexOf("fee");
      page = page.substring(balanceStart + 5);
      int balanceEnd = page.indexOf("'");
      balance = int.parse(page.substring(0, balanceEnd).trim());

      return CampusNetworkUsageInformation(
          CampusNetworkConnectionStatus.isLogin, time, flux, balance);
    } else if (page.contains("--Dr.COMWebLoginID_0.htm-->")) {
      return CampusNetworkUsageInformation.onlyStatus(
          CampusNetworkConnectionStatus.unLogin);
    } else {
      return CampusNetworkUsageInformation.onlyStatus(
          CampusNetworkConnectionStatus.none);
    }
  } on DioException {
    return CampusNetworkUsageInformation.onlyStatus(
        CampusNetworkConnectionStatus.none);
  }
}

String getOperatorName(int i) {
  switch (i) {
    case 1:
      return "telecom";
    case 2:
      return "mobile";
    case 3:
      return "unicom";
    default:
      throw Exception("运营商非法");
  }
}
