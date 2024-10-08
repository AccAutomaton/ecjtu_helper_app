import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hms_scan_kit/flutter_hms_scan_kit.dart';
import 'package:flutter_hms_scan_kit/scan_result.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../uitls/shared_preferences_util.dart';

class LibraryWebviewPage extends StatefulWidget {
  const LibraryWebviewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LibraryWebviewPageState();
  }
}

class _LibraryWebviewPageState extends State<LibraryWebviewPage> {
  ScanResult? _scanResult;
  late Timer _timer;
  late DateTime _currentTime;

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
    return Scaffold(
        appBar: AppBar(
          title: const Text("华东交通大学图书馆IC空间"),
          centerTitle: true,
          leading: MenuAnchor(
            builder: _appBarLeadingMenuAnchorBuilder,
            menuChildren: [
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  minimumSize: const WidgetStatePropertyAll(Size(175, 50)),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text("刷新"),
                onPressed: () {
                  libraryWebViewController.reload();
                },
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  minimumSize: const WidgetStatePropertyAll(Size(175, 50)),
                ),
                icon: const Icon(Icons.delete_forever_outlined),
                label: const Text("清除缓存并刷新"),
                onPressed: () {
                  libraryWebViewController.clearCache();
                  libraryWebViewController.clearLocalStorage();
                  libraryWebViewController.reload();
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
                        backgroundColor: Colors.yellow);
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
                    icon: const Icon(Icons.keyboard_backspace),
                    label: const Text("上一页"),
                    onPressed: () {
                      libraryWebViewController.canGoBack().then((bool canGoBack) {
                        if (canGoBack) {
                          libraryWebViewController.goBack();
                        } else {
                          Fluttertoast.showToast(
                              msg: "已经是第一页", gravity: ToastGravity.BOTTOM);
                        }
                      });
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: const Text("自动登录设置"),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const AutoLoginSettingsPage();
                        }),
                      );
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(
                        "${_currentTime.hour}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}"),
                    onPressed: () {},
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
              child: WebViewWidget(controller: libraryWebViewController),
            ),
          ],
        ));
  }
}

final WebViewController libraryWebViewController = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setUserAgent(
      "Mozilla/5.0 (Linux; Android 6.0.1; MX4 Build/MOB30M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/51.0.2704.106 Mobile Safari/537.36")
  ..setNavigationDelegate(NavigationDelegate(
    onPageFinished: (String url) async {
      bool enableAutoLogin = false;
      await readData("library_enableAutoLogin")
          .then((data) => enableAutoLogin = bool.tryParse(data!)!);
      if (enableAutoLogin) {
        String username = "", password = "";
        await readData("library_username").then((data) => username = data!);
        await readData("library_password").then((data) => password = data!);
        if (url.contains("rz.ecjtu.edu.cn")) {
          libraryWebViewController.runJavaScript(
              'document.getElementsByName("username")[0].value = "$username"');
          libraryWebViewController.runJavaScript(
              'document.getElementsByName("password")[0].value = "$password"');
          libraryWebViewController.runJavaScript(
              'document.getElementsByTagName("button")[0].click()');
        }
        if (url.contains("cas.ecjtu.edu.cn")) {
          libraryWebViewController.runJavaScript(
              'document.getElementById("username").value = "$username"');
          libraryWebViewController.runJavaScript(
              'document.getElementById("password").value = "$password"');
          libraryWebViewController.runJavaScript('submitInfo()');
        }
      }
    },
    onWebResourceError: (WebResourceError error) {
      Fluttertoast.showToast(
          msg: "网页开小差了...",
          gravity: ToastGravity.BOTTOM);
    },
  ))
  ..loadRequest(Uri.parse("http://lib2.ecjtu.edu.cn/"));

class AutoLoginSettingsPage extends StatefulWidget {
  const AutoLoginSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AutoLoginSettingsPageState();
  }
}

class _AutoLoginSettingsPageState extends State<AutoLoginSettingsPage> {
  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  bool _enableAutoLogin = false;

  @override
  void initState() {
    super.initState();
    readData("library_username").then((data) => setState(() {
          _usernameTextEditingController.text = data!;
        }));
    readData("library_password").then((data) => setState(() {
          _passwordTextEditingController.text = data!;
        }));
    readData("library_enableAutoLogin").then((data) => setState(() {
          _enableAutoLogin = bool.tryParse(data!)!;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("自动登录设置"),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_enableAutoLogin) ...[
                    const Text("自动登录服务已开启",
                        style: TextStyle(fontSize: 16, color: Colors.blue))
                  ] else ...[
                    const Text("自动登录服务已关闭", style: TextStyle(fontSize: 16))
                  ],
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Switch(
                        value: _enableAutoLogin,
                        activeColor: Colors.blueAccent,
                        onChanged: (newValue) {
                          setState(() {
                            _enableAutoLogin = newValue;
                            saveData(
                                "library_enableAutoLogin", newValue.toString());
                          });
                        }),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(60, 20, 60, 10),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "图书馆(智慧交大)用户名",
                  hintText: "请输入图书馆(智慧交大)用户名",
                  prefixIcon: Icon(Icons.person),
                ),
                controller: _usernameTextEditingController,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(60, 10, 60, 20),
              child: TextField(
                decoration: const InputDecoration(
                    labelText: "图书馆(智慧交大)密码",
                    hintText: "请输入图书馆(智慧交大)密码",
                    prefixIcon: Icon(Icons.lock)),
                obscureText: true,
                controller: _passwordTextEditingController,
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: const Text(
                  "凭据将保存在本地",
                  style: TextStyle(color: Colors.grey),
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("保存凭据"),
                onPressed: () {
                  saveData(
                      "library_username", _usernameTextEditingController.text);
                  saveData(
                      "library_password", _passwordTextEditingController.text);
                  Fluttertoast.showToast(
                      msg: "保存成功！",
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.green,
                      fontSize: 18);
                },
                style: const ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(160, 60))),
              ),
            )
          ],
        )));
  }
}
