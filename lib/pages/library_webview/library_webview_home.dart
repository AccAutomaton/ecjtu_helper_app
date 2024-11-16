import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecjtu_helper/pages/library_webview/library_settings.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_library/setting_library_default_seat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hms_scan_kit/flutter_hms_scan_kit.dart';
import 'package:flutter_hms_scan_kit/scan_result.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/dio_util.dart';
import '../../utils/shared_preferences_util.dart';
import '../settings_page/settings_library/setting_library_appointment.dart';

class LibraryWebviewPage extends StatefulWidget {
  const LibraryWebviewPage({super.key});

  static bool loginFailedFlag = false;

  @override
  State<StatefulWidget> createState() {
    return _LibraryWebviewPageState();
  }
}

class _LibraryWebviewPageState extends State<LibraryWebviewPage> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  final MenuController _menuController = MenuController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), setCurrentTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void setCurrentTime(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  Widget _appBarLeadingMenuAnchorBuilder(
      _, MenuController controller, Widget? child) {
    return GestureDetector(
      onTap: controller.open,
      child: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterEasyLoading(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("华东交通大学图书馆IC空间"),
              centerTitle: true,
              leading: MenuAnchor(
                builder: _appBarLeadingMenuAnchorBuilder,
                controller: _menuController,
                consumeOutsideTap: true,
                menuChildren: [
                  _buttonToPreviousPage(),
                  _buttonToRefresh(),
                  _buttonToClearRefresh(),
                ],
              ),
              actions: [
                _buttonToScanQRCode(),
                _buttonToLibrarySettings(),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      _buttonToQuickAppointment(),
                      Expanded(flex: 1, child: Container()),
                      _timeButton(_currentTime),
                      Expanded(flex: 1, child: Container()),
                      _buttonToQuickCheck(),
                      Expanded(flex: 1, child: Container()),
                    ],
                  ),
                ),
                Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 20)),
                Expanded(flex: 20, child: _webViewScope()),
              ],
            )));
  }

  Widget _buttonToPreviousPage() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.keyboard_backspace),
      label: const Text("上一页"),
      style: menuChildrenButtonStyle,
      onPressed: () {
        libraryWebViewController.canGoBack().then((bool canGoBack) {
          if (canGoBack) {
            libraryWebViewController.goBack();
          } else {
            Fluttertoast.showToast(msg: "已经是第一页", gravity: ToastGravity.BOTTOM);
          }
          _menuController.close();
        });
      },
    );
  }

  Widget _buttonToRefresh() {
    return ElevatedButton.icon(
      style: menuChildrenButtonStyle,
      icon: const Icon(Icons.refresh),
      label: const Text("刷新"),
      onPressed: () {
        libraryWebViewController.reload();
        _menuController.close();
      },
    );
  }

  Widget _buttonToClearRefresh() {
    return ElevatedButton.icon(
      style: menuChildrenButtonStyle,
      icon: const Icon(Icons.delete_forever_outlined),
      label: const Text("清除数据并刷新"),
      onPressed: () {
        webViewCookieManager.removeCookie("lib2.ecjtu.edu.cn");
        libraryWebViewController.clearCache();
        libraryWebViewController.clearLocalStorage();
        libraryWebViewController.reload();
        _menuController.close();
      },
    );
  }

  Widget _buttonToScanQRCode() {
    return IconButton(
      icon: const Icon(Icons.qr_code_scanner),
      onPressed: () async {
        if (await isLibraryLogin()) {
          ScanResult? scanResult = await FlutterHmsScanKit.startScan();
          String? to = "http://lib2.ecjtu.edu.cn/";
          to = scanResult?.value;
          libraryWebViewController.loadRequest(Uri.parse(to!));
        } else {
          Fluttertoast.showToast(
              msg: "请先登录图书馆再扫码",
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.yellow[800]);
        }
      },
    );
  }

  Widget _buttonToLibrarySettings() {
    return IconButton(
      icon: const Icon(Icons.settings_outlined),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return const LibrarySettingsPage();
          }),
        );
      },
    );
  }

  Widget _buttonToQuickAppointment() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.fast_forward_outlined),
      label: const Text("快速预约"),
      onPressed: () {
        isLibraryLogin().then((isLogin) {
          if (isLogin) {
            doQuickAppointment().then((appointmentResultList) {
              if (appointmentResultList != null) {
                _showAppointmentResultDialog(appointmentResultList);
              }
            });
          } else {
            Fluttertoast.showToast(
                msg: "请先登录图书馆再预约",
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.yellow[800]);
          }
        });
      },
      onLongPress: () async {
        readStringData("library_has_default_room_dev_id")
            .then((hasDefaultSeat) async {
          if (hasDefaultSeat != null) {
            if (bool.parse(hasDefaultSeat)) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return const SettingLibraryAppointmentPage();
                }),
              );
              return;
            }
          }
          Fluttertoast.showToast(
              msg: "请先设置默认座位再使用快速预约功能", gravity: ToastGravity.BOTTOM);
        });
      },
    );
  }

  Widget _timeButton(DateTime currentTime) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.access_time),
      label: Text(
          "  ${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}:${currentTime.second.toString().padLeft(2, '0')}  "),
      onPressed: () {},
    );
  }

  Widget _buttonToQuickCheck() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.fact_check_outlined),
      label: const Text("快速签到"),
      onPressed: () async {
        if (await isLibraryLogin()) {
          bool hasDefaultSeat = false;
          readStringData("library_has_default_room_dev_id")
              .then((isHasDefaultSeat) {
            if (isHasDefaultSeat != null) {
              hasDefaultSeat = bool.parse(isHasDefaultSeat);
              if (hasDefaultSeat) {
                readStringData("library_default_room_dev_id").then((roomDevId) {
                  libraryWebViewController.loadRequest(Uri.parse(
                      "http://update.unifound.net/wxnotice/s.aspx?c=$roomDevId"));
                });
                return;
              }
            }
            Fluttertoast.showToast(
                msg: "尚未设置默认座位，请长按该按钮进行设置。", gravity: ToastGravity.CENTER);
          });
        } else {
          Fluttertoast.showToast(
              msg: "请先登录图书馆再签到",
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.yellow[800]);
        }
      },
      onLongPress: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return const SettingLibraryDefaultSeatPage();
          }),
        );
      },
    );
  }

  Widget _webViewScope() {
    return PopScope(
      canPop: false,
      child: WebViewWidget(controller: libraryWebViewController),
      onPopInvoked: (didPop) {
        libraryWebViewController.canGoBack().then((bool canGoBack) {
          if (canGoBack) {
            libraryWebViewController.goBack();
          } else {
            Fluttertoast.showToast(msg: "已经是第一页", gravity: ToastGravity.BOTTOM);
          }
        });
      },
    );
  }

  _showAppointmentResultDialog(List<AppointmentResult> appointmentResultList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Row(
                children: [
                  Expanded(flex: 1, child: Container()),
                  const Icon(Icons.fact_check_outlined),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: const Text("预约结果"),
                  ),
                  Expanded(flex: 1, child: Container()),
                ],
              ),
            ),
            content: SizedBox(
              height: appointmentResultList.length * 78,
              child: Column(
                children: appointmentResultWidgetList(appointmentResultList),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('确认'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  List<Widget> appointmentResultWidgetList(
      List<AppointmentResult> appointmentResultList) {
    List<Widget> widgetList = [];
    for (int i = 0; i < appointmentResultList.length; i++) {
      widgetList.add(Row(
        children: [
          Expanded(flex: 1, child: Container()),
          Column(
            children: [
              Text("预约时段 ${appointmentResultList[i].number}",
                  style: const TextStyle(color: Colors.grey)),
              Text(appointmentResultList[i].timeScale),
              if (appointmentResultList[i].result == "新增成功") ...[
                const Text("预约成功",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w800)),
              ] else ...[
                Text(appointmentResultList[i].result,
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w800)),
              ],
              const SizedBox(
                width: 300,
                child: Divider(),
              )
            ],
          ),
          Expanded(flex: 1, child: Container()),
        ],
      ));
    }
    return widgetList;
  }
}

ButtonStyle menuChildrenButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(Colors.transparent),
  shadowColor: WidgetStateProperty.all(Colors.transparent),
  minimumSize: const WidgetStatePropertyAll(Size(175, 50)),
);

final WebViewController libraryWebViewController = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setUserAgent(
      "Mozilla/5.0 (Linux; Android 6.0.1; MX4 Build/MOB30M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/51.0.2704.106 Mobile Safari/537.36")
  ..setNavigationDelegate(NavigationDelegate(onPageStarted: (String url) {
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.show(status: "正在加载...");
  }, onPageFinished: (String url) async {
    EasyLoading.dismiss();
    bool enableAutoLogin = false;
    await readStringData("library_enableAutoLogin").then((data) {
      if (data != null) {
        enableAutoLogin = bool.tryParse(data)!;
      }
    });
    if (enableAutoLogin) {
      String username = "", password = "";
      await readStringData("library_username").then((data) => username = data!);
      await readStringData("library_password").then((data) => password = data!);
      if (url.contains("rz.ecjtu.edu.cn")) {
        if (!LibraryWebviewPage.loginFailedFlag) {
          libraryWebViewController.runJavaScript(
              'document.getElementsByName("username")[0].value = "$username"');
          libraryWebViewController.runJavaScript(
              'document.getElementsByName("password")[0].value = "$password"');
          libraryWebViewController.runJavaScript(
              'document.getElementsByTagName("button")[0].click()');
          LibraryWebviewPage.loginFailedFlag = true;
        }
      } else {
        LibraryWebviewPage.loginFailedFlag = false;
      }
      if (url.contains("cas.ecjtu.edu.cn")) {
        libraryWebViewController.runJavaScript(
            'document.getElementById("username").value = "$username"');
        libraryWebViewController.runJavaScript(
            'document.getElementById("password").value = "$password"');
        libraryWebViewController.runJavaScript('submitInfo()');
      }
    }
  }, onWebResourceError: (WebResourceError error) {
    EasyLoading.dismiss();
    Fluttertoast.showToast(msg: "网页开小差了...", gravity: ToastGravity.BOTTOM);
  }, onHttpError: (HttpResponseError error) {
    EasyLoading.dismiss();
  }))
  ..loadRequest(Uri.parse("http://lib2.ecjtu.edu.cn/"));

final WebviewCookieManager webViewCookieManager = WebviewCookieManager();

Future<bool> isLibraryLogin() async {
  List<Cookie> cookieList =
      await webViewCookieManager.getCookies("lib2.ecjtu.edu.cn");
  int count = 0;
  if (cookieList.length >= 2) {
    for (Cookie cookie in cookieList) {
      if (cookie.name == "wengine_new_ticket") {
        count++;
      } else if (cookie.name == "ic-cookie") {
        count++;
      }
    }
  }
  return count >= 2;
}

Future<List<AppointmentResult>?> doQuickAppointment() async {
  List<AppointmentResult> appointmentResultList = [];

  String? defaultRoomDevId =
      await readStringData("library_default_room_dev_id");
  String? devId = defaultRoomDevId?.split("_")[2];

  int afterDays = 0;
  bool hasDefaultDate =
      await readIntData("library_default_appointment_date").then((defaultDate) {
    if (defaultDate != null) {
      afterDays = defaultDate;
      return true;
    } else {
      return false;
    }
  });
  if (!hasDefaultDate) {
    Fluttertoast.showToast(msg: "请先设置默认预约信息", gravity: ToastGravity.BOTTOM);
    return null;
  }

  List<Cookie> cookieList =
      await webViewCookieManager.getCookies("lib2.ecjtu.edu.cn");
  late String wengineNewTicket, icCookie;
  for (Cookie cookie in cookieList) {
    if (cookie.name == "wengine_new_ticket") {
      wengineNewTicket = cookie.value;
    } else if (cookie.name == "ic-cookie") {
      icCookie = cookie.value;
    }
  }

  DateTime now = DateTime.now();
  DateTime before = now.subtract(const Duration(days: 30 * 6));
  String nowString =
      "${now.year}-${(now.month) < 10 ? "0${now.month}" : "${now.month}"}-${(now.day) < 10 ? "0${now.day}" : "${now.day}"}";
  String beforeString =
      "${before.year}-${(before.month) < 10 ? "0${before.month}" : "${before.month}"}-${(before.day) < 10 ? "0${before.day}" : "${before.day}"}";

  try {
    String json = (await dio.request(
            "http://lib2.ecjtu.edu.cn/ic-web/reserve/resvInfo?beginDate=$beforeString&endDate=$nowString&needStatus=150&page=1&pageNum=10&orderKey=gmt_create&orderModel=desc",
            options: Options(
                method: "get",
                contentType: Headers.jsonContentType,
                responseType: ResponseType.plain,
                headers: {
                  "user-agent":
                      "Mozilla/5.0 (Linux; Android 6.0.1; MX4 Build/MOB30M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/51.0.2704.106 Mobile Safari/537.36",
                  "cookie":
                      "wengine_new_ticket=$wengineNewTicket; ic-cookie=$icCookie"
                })))
        .data
        .toString();
    var data = jsonDecode(json);
    if (data["data"].length == null) {
      Fluttertoast.showToast(msg: "获取预约列表时出现异常", gravity: ToastGravity.BOTTOM);
      return null;
    }
    if (data["data"].length == 0) {
      Fluttertoast.showToast(
          msg: "获取用户信息失败, 请确保近 180 天内至少有一条预约信息", gravity: ToastGravity.BOTTOM);
      return null;
    }
    int appAccNo = data["data"][0]["appAccNo"];

    DateTime targetDate = now.add(Duration(days: afterDays));
    String targetDateString =
        "${targetDate.year}-${(targetDate.month) < 10 ? "0${targetDate.month}" : "${targetDate.month}"}-${(targetDate.day) < 10 ? "0${targetDate.day}" : "${targetDate.day}"}";

    for (int i = 1; i <= 3; i++) {
      await readBoolData("library_default_appointment_enable_time_$i")
          .then((enabled) async {
        if (enabled != null && enabled) {
          int? startTimeHour = await readIntData(
              "library_default_appointment_start_time_${i}_hour");
          int? startTimeMinute = await readIntData(
              "library_default_appointment_start_time_${i}_minute");
          int? endTimeHour = await readIntData(
              "library_default_appointment_end_time_${i}_hour");
          int? endTimeMinute = await readIntData(
              "library_default_appointment_end_time_${i}_minute");
          String resvBeginTime =
              "$targetDateString ${startTimeHour! < 10 ? "0$startTimeHour" : "$startTimeHour"}:${startTimeMinute! < 10 ? "0$startTimeMinute" : "$startTimeMinute"}:00";
          String resvEndTime =
              "$targetDateString ${endTimeHour! < 10 ? "0$endTimeHour" : "$endTimeHour"}:${endTimeMinute! < 10 ? "0$endTimeMinute" : "$endTimeMinute"}:00";
          try {
            String appointmentJson = (await dio.request(
                    "http://lib2.ecjtu.edu.cn/ic-web/reserve",
                    options: Options(
                        method: "post",
                        contentType: Headers.jsonContentType,
                        responseType: ResponseType.plain,
                        headers: {
                          "user-agent":
                              "Mozilla/5.0 (Linux; Android 6.0.1; MX4 Build/MOB30M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/51.0.2704.106 Mobile Safari/537.36",
                          "cookie":
                              "wengine_new_ticket=$wengineNewTicket; ic-cookie=$icCookie"
                        }),
                    data: {
                  "appAccNo": appAccNo,
                  "captcha": "",
                  "memberKind": 1,
                  "memo": "",
                  "resvBeginTime": resvBeginTime,
                  "resvDev": [int.parse(devId!)],
                  "resvEndTime": resvEndTime,
                  "resvMember": [appAccNo],
                  "resvProperty": 0,
                  "sysKind": 8,
                  "testName": "",
                }))
                .data
                .toString();
            var appointmentData = jsonDecode(appointmentJson);

            appointmentResultList.add(AppointmentResult(i,
                "$resvBeginTime ~ $resvEndTime", appointmentData["message"]));
          } on DioException {
            appointmentResultList.add(AppointmentResult(
                i, "$resvBeginTime ~ $resvEndTime", "预约失败: Dio Exception"));
          }
        }
      });
    }
    return appointmentResultList;
  } on DioException {
    Fluttertoast.showToast(
        msg: "网络异常: Dio Exception", gravity: ToastGravity.BOTTOM);
  }
  return null;
}

class AppointmentResult {
  late int number;
  late String timeScale;
  late String result;

  AppointmentResult(this.number, this.timeScale, this.result);
}
