import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
      Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("App version: "),
              FutureBuilder(
                  future: getAppAndBuildVersion(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Text("${snapshot.data}");
                  })
            ],
          )),
      Container(
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Build signature: ",
                  style: TextStyle(color: Colors.grey)),
              FutureBuilder(
                  future: getBuildSignature(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Text("${snapshot.data}",
                        style: const TextStyle(color: Colors.grey));
                  })
            ],
          )),
      Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("若在使用中遇到问题或想要反馈，请"),
              TextButton(child: const Text("提交issue"), onPressed: () {
                launchUrlString("https://github.com/AccAutomaton/ecjtu_helper_app/issues");
              })
            ],
          )),
      Container(
        margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: const Text(
          "此应用程序仅供学习交流使用，请勿用于非法用途。",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    ]));
  }
}

Future<String> getAppAndBuildVersion() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return "${info.version} Build ${info.buildNumber}";
}

Future<String> getBuildSignature() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return info.buildSignature;
}
