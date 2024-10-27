import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_home.dart';
import 'package:ecjtu_helper/utils/dio_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  late Widget _checkUpdateTitle;

  @override
  initState() {
    super.initState();
    _checkUpdateTitle = const Text("检查更新");
    hasUpdate().then((onValue) {
      bool hadUpdate = onValue.$1;
      String? newVersion = onValue.$2;
      if (hadUpdate) {
        setState(() {
          _checkUpdateTitle = Text("发现新版本: $newVersion",
              style: const TextStyle(color: Colors.red));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
            flex: 30,
            child: Column(children: [
              Expanded(flex: 2, child: Container()),
              Expanded(
                  flex: 30,
                  child: Column(
                    children: [
                      const Image(
                        image: AssetImage("images/icon_acautomaton.png"),
                        width: 100,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: const Text(
                          "ECJTU Helper",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Powered by "),
                              Text(
                                "AccAutomaton",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ],
                          )),
                      const FractionallySizedBox(
                          widthFactor: 0.925,
                          child: Divider(
                            color: Colors.grey,
                          )),
                      FractionallySizedBox(
                        widthFactor: 0.925,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return const SettingsHomePage();
                                  }),
                                );
                              },
                              child: const ListTile(
                                leading: Icon(Icons.settings),
                                title: Text("设置"),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                Fluttertoast.showToast(
                                    msg: "正在检查更新...",
                                    gravity: ToastGravity.CENTER);
                                late bool hadUpdate;
                                late String newVersion;
                                (hadUpdate, newVersion) = await hasUpdate();
                                if (hadUpdate) {
                                  setState(() {
                                    _checkUpdateTitle = Text(
                                        "发现新版本: $newVersion",
                                        style:
                                            const TextStyle(color: Colors.red));
                                  });
                                  Fluttertoast.cancel();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          icon:
                                              const Icon(Icons.backup_outlined),
                                          title: Text("发现新版本: $newVersion"),
                                          content: const Center(
                                              heightFactor: 0.5,
                                              widthFactor: 10,
                                              child: Text("是否更新?")),
                                          actions: [
                                            TextButton(
                                              child: const Text('取消'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('确认'),
                                              onPressed: () {
                                                launchUrlString(
                                                    "https://cdn.acautomaton.com/ecjtu_helper/ecjtu_helper-release-$newVersion.apk");
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  Fluttertoast.cancel();
                                  setState(() {
                                    _checkUpdateTitle = const Text("已是最新版本",
                                        style: TextStyle(color: Colors.green));
                                  });
                                }
                              },
                              child: ListTile(
                                leading: const Icon(Icons.backup_outlined),
                                title: _checkUpdateTitle,
                                subtitle: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text("当前版本: "),
                                    FutureBuilder(
                                        future: _getAppAndBuildVersion(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          return Text("${snapshot.data}");
                                        })
                                  ],
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: FractionallySizedBox(
                            widthFactor: 0.925,
                            child: Divider(
                              color: Colors.grey,
                            )),
                      ),
                      Expanded(
                        flex: 20,
                        child: FractionallySizedBox(
                          widthFactor: 0.925,
                          child: SizedBox(
                            child: FutureBuilder(
                              future:
                                  rootBundle.loadString('docs/update_log.md'),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Markdown(data: snapshot.data);
                                } else {
                                  return const Center(
                                    child: Text("正在加载更新日志..."),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: FractionallySizedBox(
                            widthFactor: 0.925,
                            child: Divider(
                              color: Colors.grey,
                            )),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text("若在使用中遇到问题或想要反馈，请"),
                          TextButton(
                              child: const Text("提交issue"),
                              onPressed: () {
                                launchUrlString(
                                    "https://github.com/AccAutomaton/ecjtu_helper_app/issues");
                              })
                        ],
                      ),
                      const Text(
                        "此应用程序仅供学习交流使用，请勿用于非法用途。",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
            ])),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }
}

Future<String> _getAppAndBuildVersion() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return "${info.version} Build ${info.buildNumber}";
}

Future<(bool, String)> hasUpdate() async {
  Response response = await dio.get(
      "https://toolbox.acautomaton.com/api/ecjtu_helper/v1alpha1/getUpdateInformation",
      options: Options(responseType: ResponseType.plain));
  if (response.statusCode == HttpStatus.ok) {
    var json = jsonDecode(response.data.toString());
    String? version = json["latest_version"];
    if (version == null) {
      return (false, "");
    }
    else if ((await PackageInfo.fromPlatform()).version != version) {
      return (true, version);
    }
  }
  return (false, "");
}
