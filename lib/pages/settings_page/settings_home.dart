import 'package:ecjtu_helper/pages/settings_page/setting_dark_mode.dart';
import 'package:ecjtu_helper/pages/settings_page/setting_default_start_page.dart';
import 'package:ecjtu_helper/provider/default_start_page_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider.dart';

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsHomePageState();
  }
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("设置"),
        ),
        body: Center(
            child: FractionallySizedBox(
          widthFactor: 0.925,
          child: ListView(children: [
            lightGreyDivider,
            settingLabel("通用"),
            darkModeInkWell(context),
            defaultStartPageInkWell(context),
            lightGreyDivider,
            settingLabel("图书馆（开发中）"),
            lightGreyDivider,
            settingLabel("校园网（开发中）"),
            lightGreyDivider,
          ]),
        )));
  }
}

Container settingLabel(String content) {
  return Container(
    margin: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
    child: Text(content, style: const TextStyle(color: Colors.grey)),
  );
}

const lightGreyDivider = Divider(
  color: Color.fromRGBO(211, 211, 211, 1),
);

Widget darkModeInkWell(BuildContext context) {
  return Consumer(builder: (context, ThemeProvider provider, child) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(builder: (BuildContext context) {
            return const DarkModeSettingPage();
          }),
        );
      },
      child: ListTile(
        leading: const Icon(Icons.light_mode_outlined),
        title: const Text("深色模式"),
        subtitle: Consumer(builder: (context, ThemeProvider provider, child) {
          switch (provider.themeMode) {
            case ThemeMode.light:
              return const Text("夜间模式已关闭");
            case ThemeMode.dark:
              return const Text("夜间模式已开启");
            default:
              return const Text("跟随系统");
          }
        }),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  });
}

Widget defaultStartPageInkWell(BuildContext context) {
  return Consumer(builder: (context, DefaultStartPageProvider provider, child) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(builder: (BuildContext context) {
            return const DefaultStartPageSettingPage();
          }),
        );
      },
      // ignore: prefer_const_constructors
      child: ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text("启动APP时默认展示的界面"),
        // subtitle: Text(provider.defaultStartPage.name),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  });
}
