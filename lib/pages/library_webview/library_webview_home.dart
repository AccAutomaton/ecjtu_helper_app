import 'dart:async';

import 'package:ecjtu_helper/pages/library_webview/setting_auto_login_library.dart';
import 'package:ecjtu_helper/pages/library_webview/setting_default_seat_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hms_scan_kit/flutter_hms_scan_kit.dart';
import 'package:flutter_hms_scan_kit/scan_result.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/shared_preferences_util.dart';

class LibraryWebviewPage extends StatefulWidget {
  const LibraryWebviewPage({super.key});
  static bool loginFailedFlag = false;

  @override
  State<StatefulWidget> createState() {
    return _LibraryWebviewPageState();
  }
}

class _LibraryWebviewPageState extends State<LibraryWebviewPage> {
  ScanResult? _scanResult;
  late Timer _timer;
  DateTime _currentTime = DateTime.now();
  final MenuController _menuController = MenuController();
  final ButtonStyle _menuChildrenButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    shadowColor: WidgetStateProperty.all(Colors.transparent),
    minimumSize: const WidgetStatePropertyAll(Size(175, 50)),
  );

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
                  ElevatedButton.icon(
                    icon: const Icon(Icons.keyboard_backspace),
                    label: const Text("上一页"),
                    style: _menuChildrenButtonStyle,
                    onPressed: () {
                      libraryWebViewController
                          .canGoBack()
                          .then((bool canGoBack) {
                        if (canGoBack) {
                          libraryWebViewController.goBack();
                        } else {
                          Fluttertoast.showToast(
                              msg: "已经是第一页", gravity: ToastGravity.BOTTOM);
                        }
                        _menuController.close();
                      });
                    },
                  ),
                  ElevatedButton.icon(
                    style: _menuChildrenButtonStyle,
                    icon: const Icon(Icons.refresh),
                    label: const Text("刷新"),
                    onPressed: () {
                      libraryWebViewController.reload();
                      _menuController.close();
                    },
                  ),
                  ElevatedButton.icon(
                    style: _menuChildrenButtonStyle,
                    icon: const Icon(Icons.delete_forever_outlined),
                    label: const Text("清除缓存并刷新"),
                    onPressed: () {
                      libraryWebViewController.clearCache();
                      libraryWebViewController.clearLocalStorage();
                      libraryWebViewController.reload();
                      _menuController.close();
                    },
                  ),
                  ElevatedButton.icon(
                    style: _menuChildrenButtonStyle,
                    icon: const Icon(Icons.settings),
                    label: const Text("自动登录设置"),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const LibraryAutoLoginSettingPage();
                        }),
                      );
                      libraryWebViewController
                          .loadRequest(Uri.parse("http://lib2.ecjtu.edu.cn/"));
                      _menuController.close();
                    },
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    libraryWebViewController.currentUrl().then((url) async {
                      if (url!.contains("lib2.ecjtu.edu.cn")) {
                        _scanResult = await FlutterHmsScanKit.startScan();
                        String? to = "http://lib2.ecjtu.edu.cn/";
                        to = _scanResult?.value;
                        libraryWebViewController.loadRequest(Uri.parse(to!));
                      } else {
                        Fluttertoast.showToast(
                            msg: "请先登录图书馆再扫码",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.yellow[800]);
                      }
                    });
                  },
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.fast_forward_outlined),
                        label: const Text("快速预约"),
                        onPressed: () {
                          // TODO
                          Fluttertoast.showToast(
                              msg: "敬请期待", gravity: ToastGravity.CENTER);
                        },
                        onLongPress: () async {
                          // TODO
                          Fluttertoast.showToast(
                              msg: "敬请期待", gravity: ToastGravity.CENTER);
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text(
                            "  ${_currentTime.hour}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}  "),
                        onPressed: () {},
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.fact_check_outlined),
                        label: const Text("快速签到"),
                        onPressed: () {
                          bool hasDefaultSeat = false;
                          readStringData("library_has_default_room_dev_id")
                              .then((isHasDefaultSeat) {
                            if (isHasDefaultSeat != null) {
                              hasDefaultSeat = bool.parse(isHasDefaultSeat);
                              if (hasDefaultSeat) {
                                readStringData("library_default_room_dev_id")
                                    .then((roomDevId) {
                                  libraryWebViewController.loadRequest(Uri.parse(
                                      "http://update.unifound.net/wxnotice/s.aspx?c=$roomDevId"));
                                });
                                return;
                              }
                            }
                            Fluttertoast.showToast(
                                msg: "尚未设置默认座位，请长按该按钮进行设置。",
                                gravity: ToastGravity.CENTER);
                          });
                        },
                        onLongPress: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return const LibraryDefaultSeatSettingPage();
                            }),
                          );
                          _menuController.close();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 20)),
                Expanded(
                    flex: 20,
                    child: PopScope(
                      canPop: false,
                      child:
                          WebViewWidget(controller: libraryWebViewController),
                      onPopInvoked: (didPop) {
                        libraryWebViewController
                            .canGoBack()
                            .then((bool canGoBack) {
                          if (canGoBack) {
                            libraryWebViewController.goBack();
                          } else {
                            Fluttertoast.showToast(
                                msg: "已经是第一页", gravity: ToastGravity.BOTTOM);
                          }
                        });
                      },
                    )),
              ],
            )));
  }
}

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
