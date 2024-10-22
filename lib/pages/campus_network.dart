import 'package:dio/dio.dart';
import 'package:ecjtu_helper/utils/campus_network_util.dart';
import 'package:ecjtu_helper/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CampusNetworkPage extends StatefulWidget {
  const CampusNetworkPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CampusNetworkPageState();
  }
}

class _CampusNetworkPageState extends State<CampusNetworkPage> {
  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  bool _savePasswordSelected = true;
  int? _operatorSelected;

  @override
  void initState() {
    super.initState();
    readStringData("campus_network_username").then((data) => setState(() {
          if (data != null) {
            _usernameTextEditingController.text = data;
          }
        }));
    readStringData("campus_network_password").then((data) => setState(() {
          if (data != null) {
            _passwordTextEditingController.text = data;
          }
        }));
    readStringData("campus_network_enableSavePassword").then((data) => setState(() {
          if (data != null) {
            _savePasswordSelected = bool.tryParse(data)!;
          }
        }));
    readStringData("campus_network_operator").then((data) => setState(() {
          if (data != null) {
            _operatorSelected = int.tryParse(data)!;
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      const Image(
        image: AssetImage("images/icon_ecjtu_256.png"),
        width: 125,
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: const Text(
          "校园网登录",
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 32),
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(60, 20, 60, 10),
        child: TextField(
          decoration: const InputDecoration(
            labelText: "用户名",
            hintText: "请输入用户名",
            prefixIcon: Icon(Icons.person),
          ),
          controller: _usernameTextEditingController,
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(60, 10, 60, 20),
        child: TextField(
          decoration: const InputDecoration(
              labelText: "密码", hintText: "请输入密码", prefixIcon: Icon(Icons.lock)),
          obscureText: true,
          controller: _passwordTextEditingController,
        ),
      ),
      Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: const Text("运营商"),
            ),
            DropdownButton(
              hint: const Text("请选择运营商"),
              value: _operatorSelected,
              onChanged: (newValue) {
                setState(() {
                  _operatorSelected = newValue!;
                });
              },
              items: operatorList,
            ),
          ])),
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Checkbox(
                value: _savePasswordSelected,
                activeColor: Colors.blueAccent,
                onChanged: (newValue) {
                  setState(() {
                    _savePasswordSelected = newValue!;
                  });
                }),
            const Text(
              "保存密码，下次自动填充",
              textDirection: TextDirection.ltr,
            )
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text("刷新/登录"),
          onPressed: _onClickLoginButton,
          style: const ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(160, 60))),
        ),
      )
    ]));
  }

  _onClickLoginButton() async {
    if (_usernameTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "用户名不能为空",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      return;
    }
    if (_passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "密码不能为空",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      return;
    }
    if (_operatorSelected != 1 &&
        _operatorSelected != 2 &&
        _operatorSelected != 3) {
      Fluttertoast.showToast(
          msg: "请选择运营商",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      return;
    }
    Fluttertoast.showToast(
        msg: "登陆中",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.blue,
        fontSize: 18);
    try {
      await logout();
      await login(_usernameTextEditingController.text,
          _passwordTextEditingController.text, _operatorSelected);
      _onLoginSuccess();
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          Fluttertoast.showToast(
              msg: "错误：连接超时。请检查是否正确连接到校园网。",
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red);
          break;
        default:
          Fluttertoast.showToast(
              msg: "错误：$e",
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red);
      }
    }
  }

  _onLoginSuccess() {
    if (_savePasswordSelected) {
      saveStringData("campus_network_username", _usernameTextEditingController.text);
      saveStringData("campus_network_password", _passwordTextEditingController.text);
      saveStringData("campus_network_operator", _operatorSelected.toString());
    } else {
      saveStringData("campus_network_username", "");
      saveStringData("campus_network_password", "");
      saveStringData("campus_network_operator", "");
    }
    saveStringData(
        "campus_network_enableSavePassword", _savePasswordSelected.toString());
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: "登陆成功！",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        fontSize: 18);
  }
}

const List<DropdownMenuItem> operatorList = [
  DropdownMenuItem(
    value: 1,
    child: Text("中国电信"),
  ),
  DropdownMenuItem(
    value: 2,
    child: Text("中国移动"),
  ),
  DropdownMenuItem(
    value: 3,
    child: Text("中国联通"),
  ),
];
