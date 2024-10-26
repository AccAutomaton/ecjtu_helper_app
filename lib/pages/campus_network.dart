import 'package:action_slider/action_slider.dart';
import 'package:dio/dio.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_campus_network/setting_campus_network_credential.dart';
import 'package:ecjtu_helper/utils/campus_network_util.dart';
import 'package:ecjtu_helper/utils/shared_preferences_util.dart';
import 'package:flutter/foundation.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("华东交通大学校园网"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const SettingCampusNetworkCredentialPage();
                  }),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: ActionSlider.standard(
                      icon: const Image(
                        image: AssetImage("images/icon_ecjtu_256.png"),
                      ),
                      rolling: true,
                      toggleColor: const Color.fromRGBO(204, 255, 255, 0.1),
                      successIcon: const Icon(
                        Icons.check_rounded,
                        color: Colors.green,
                        size: 40,
                      ),
                      failureIcon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                        size: 40,
                      ),
                      action: (controller) async {
                        controller.loading();
                        if (await _onClickLoginButton()) {
                          controller.success();
                          Fluttertoast.showToast(
                            msg: "登陆成功！",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.green,
                          );
                          await Future.delayed(const Duration(seconds: 10));
                          controller.reset();
                        } else {
                          controller.failure();
                          await Future.delayed(const Duration(seconds: 3));
                          controller.reset();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(),
                          ),
                          const Expanded(
                            flex: 8,
                            child: Text('向右滑动以连接世界'),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Icon(Icons.login_outlined),
                          ),
                        ],
                      ),
                    ))
              ])),
        ));
  }

  Future<bool> _onClickLoginButton() async {
    if (kDebugMode) {
      await Future.delayed(const Duration(seconds: 3));
      return true;
    }

    String? username = await readStringData("campus_network_username");
    String? password = await readStringData("campus_network_password");
    String? operator = await readStringData("campus_network_operator");
    late int operatorSelected;

    if (username == null || password == null || operator == null) {
      Fluttertoast.showToast(
          msg: "请先设置校园网登录凭据",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      return false;
    }

    if (username.isEmpty) {
      Fluttertoast.showToast(
          msg: "校园网(智慧交大)用户名不能为空",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      return false;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(
          msg: "校园网(智慧交大)密码不能为空",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      return false;
    }
    if (operator.isEmpty) {
      Fluttertoast.showToast(
          msg: "请选择运营商",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      return false;
    } else {
      operatorSelected = int.tryParse(operator)!;
      if (!(operatorSelected >= 1 && operatorSelected <= 3)) {
        Fluttertoast.showToast(
            msg: "请选择运营商",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red);
        return false;
      }
    }

    try {
      await logout();
      await login(username, password, operatorSelected);
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
      return false;
    }
    return true;
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
