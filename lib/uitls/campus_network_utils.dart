import 'package:dio/dio.dart';

Dio dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  )
);

logout() async {
  try {
    await dio.get(
        "http://172.16.2.100:801/eportal/?c=ACSetting&a=Logout&wlanuserip=null&wlanacip=null&wlanacname=null&port=&hostname=172.16.2.100&iTermType=1&session=null&queryACIP=0&mac=00-00-00-00-00-00");
  } on DioException {
    rethrow;
  }
}

login(String? username, String? password, int? operator) async {
  try {
    String loginPage = (await dio.get("http://172.16.2.100/")).data.toString();
    int v64ipLocation = loginPage.indexOf("v46ip");
    String restLoginPage = loginPage.substring(v64ipLocation + 6);
    int ipEnd = restLoginPage.indexOf("'");
    String ip = restLoginPage.substring(0, ipEnd);

    String operatorName = getOperatorName(operator!);
    await dio.post(
        "http://172.16.2.100:801/eportal/?c=ACSetting&a=Login&protocol=http:&hostname=172.16.2.100&iTermType=1&wlanuserip=$ip&wlanacip=null&wlanacname=null&mac=00-00-00-00-00-00&ip=$ip&enAdvert=0&queryACIP=0&loginMethod=1",
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
        });
  } on DioException {
    rethrow;
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