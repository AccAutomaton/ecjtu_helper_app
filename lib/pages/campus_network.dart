import 'dart:math';

import 'package:action_slider/action_slider.dart';
import 'package:dio/dio.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_campus_network/setting_campus_network_credential.dart';
import 'package:ecjtu_helper/utils/campus_network_util.dart';
import 'package:ecjtu_helper/utils/shared_preferences_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CampusNetworkPage extends StatefulWidget {
  const CampusNetworkPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CampusNetworkPageState();
  }
}

class _CampusNetworkPageState extends State<CampusNetworkPage> {
  CampusNetworkUsageInformation _campusNetworkUsageInformation =
      CampusNetworkUsageInformation.onlyStatus(
          CampusNetworkConnectionStatus.none);

  @override
  void initState() {
    super.initState();
    getUsageInformation().then((information) {
      setState(() {
        _campusNetworkUsageInformation = information;
      });
    });
  }

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
              connectionStatusContainer(_campusNetworkUsageInformation),
              loginButtonContainer(),
            ]),
          ),
        ));
  }

  Widget connectionStatusContainer(CampusNetworkUsageInformation information) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Column(
          children: [
            Row(
              children: [
                if (information.status ==
                    CampusNetworkConnectionStatus.none) ...[
                  Text(information.status.name,
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 16))
                ] else if (information.status ==
                    CampusNetworkConnectionStatus.unLogin) ...[
                  Text(information.status.name,
                      style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 16))
                ] else ...[
                  Text(information.status.name,
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 16))
                ],
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      getUsageInformation().then((information) {
                        setState(() {
                          _campusNetworkUsageInformation = information;
                        });
                      });
                    }),
              ],
            ),
            if (_campusNetworkUsageInformation.status ==
                CampusNetworkConnectionStatus.isLogin) ...[
              Row(
                children: [
                  Card(
                      child: SizedBox(
                    height: 100,
                    width: 140,
                    child: Column(
                      children: [
                        Expanded(flex: 1, child: Container()),
                        const Text("已使用时间"),
                        _beautifullyMinute(_campusNetworkUsageInformation.time),
                        if (_campusNetworkUsageInformation.time >= 2760) ...[
                          Row(
                            children: [
                              Expanded(flex: 1, child: Container()),
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const Text(
                                "建议重新登录",
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 12),
                              ),
                              Expanded(flex: 1, child: Container()),
                            ],
                          )
                        ],
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),
                  )),
                  Card(
                      child: SizedBox(
                    height: 100,
                    width: 140,
                    child: Column(
                      children: [
                        Expanded(flex: 1, child: Container()),
                        const Text("已使用流量"),
                        _beautifullyFlux(_campusNetworkUsageInformation.flux),
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),
                  )),
                ],
              )
            ]
          ],
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }

  Widget loginButtonContainer() {
    return Container(
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
            HapticFeedback.lightImpact();
            controller.loading();
            if (await _onClickLoginButton()) {
              HapticFeedback.mediumImpact();
              controller.success();
              getUsageInformation().then((information) {
                setState(() {
                  _campusNetworkUsageInformation = information;
                });
              });
              await Future.delayed(const Duration(seconds: 10));
              controller.reset();
            } else {
              HapticFeedback.heavyImpact();
              controller.failure();
              getUsageInformation().then((information) {
                setState(() {
                  _campusNetworkUsageInformation = information;
                });
              });
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
        ));
  }

  Widget _beautifullyMinute(int minute) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Text("${minute ~/ 60}", style: const TextStyle(fontSize: 24)),
        const Text(" 小时 "),
        Text("${minute % 60}", style: const TextStyle(fontSize: 24)),
        const Text(" 分钟"),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }

  Widget _beautifullyFlux(int byte) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Text((byte / 1024 / 1024).toStringAsFixed(2),
            style: const TextStyle(fontSize: 24)),
        const Text(" GB"),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }

  Future<bool> _onClickLoginButton() async {
    if (kDebugMode) {
      await Future.delayed(const Duration(seconds: 3));
      return Random().nextBool();
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

enum CampusNetworkConnectionStatus {
  none(name: "未连接校园网"),
  unLogin(name: "未登录校园网"),
  isLogin(name: "已登录校园网");

  final String name;

  const CampusNetworkConnectionStatus({required this.name});
}

class CampusNetworkUsageInformation {
  CampusNetworkConnectionStatus status = CampusNetworkConnectionStatus.none;
  int time = 0;
  int flux = 0;
  int balance = 0;

  CampusNetworkUsageInformation(
      this.status, this.time, this.flux, this.balance);

  CampusNetworkUsageInformation.onlyStatus(this.status);
}
