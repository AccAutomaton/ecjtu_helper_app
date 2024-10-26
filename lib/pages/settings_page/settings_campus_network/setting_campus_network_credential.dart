import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/shared_preferences_util.dart';

class SettingCampusNetworkCredentialPage extends StatefulWidget {
  const SettingCampusNetworkCredentialPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingCampusNetworkCredentialPageState();
  }
}

class _SettingCampusNetworkCredentialPageState
    extends State<SettingCampusNetworkCredentialPage> {
  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
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
    readStringData("campus_network_operator").then((data) => setState(() {
      if (data != null) {
        _operatorSelected = int.tryParse(data)!;
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("校园网登录凭据"),
        ),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            margin: const EdgeInsets.fromLTRB(60, 20, 60, 10),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "校园网(智慧交大)用户名",
                hintText: "请输入校园网(智慧交大)用户名",
                prefixIcon: Icon(Icons.person),
              ),
              controller: _usernameTextEditingController,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(60, 10, 60, 20),
            child: TextField(
              decoration: const InputDecoration(
                  labelText: "校园网(智慧交大)密码",
                  hintText: "请输入校园网(智慧交大)密码",
                  prefixIcon: Icon(Icons.lock)),
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
                    saveStringData("campus_network_username", _usernameTextEditingController.text);
                    saveStringData("campus_network_password", _passwordTextEditingController.text);
                    saveStringData("campus_network_operator", _operatorSelected.toString());
                    Fluttertoast.showToast(
                        msg: "保存成功！",
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        fontSize: 18);
                    Navigator.pop(context);
                  },
                  style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(160, 60))),
                ),
              )
        ])));
  }
}

const List<DropdownMenuItem> operatorList = [
  DropdownMenuItem(
    value: 0,
    child: Text("请选择运营商", style: TextStyle(color: Colors.grey)),
  ),
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
