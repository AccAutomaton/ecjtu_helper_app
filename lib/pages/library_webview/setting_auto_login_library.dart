import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/shared_preferences_util.dart';
import 'library_webview_home.dart';

class LibraryAutoLoginSettingPage extends StatefulWidget {
  const LibraryAutoLoginSettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LibraryAutoLoginSettingPageState();
  }
}

class _LibraryAutoLoginSettingPageState
    extends State<LibraryAutoLoginSettingPage> {
  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  bool _enableAutoLogin = false;

  @override
  void initState() {
    super.initState();
    readStringData("library_username").then((data) => setState(() {
          if (data != null) {
            _usernameTextEditingController.text = data;
          }
        }));
    readStringData("library_password").then((data) => setState(() {
          if (data != null) {
            _passwordTextEditingController.text = data;
          }
        }));
    readStringData("library_enableAutoLogin").then((data) => setState(() {
          if (data != null) {
            _enableAutoLogin = bool.tryParse(data)!;
          }
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
                            saveStringData(
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
                  saveStringData(
                      "library_username", _usernameTextEditingController.text);
                  saveStringData(
                      "library_password", _passwordTextEditingController.text);
                  LibraryWebviewPage.loginFailedFlag = false;
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
