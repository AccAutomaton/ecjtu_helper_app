import 'package:ecjtu_helper/pages/settings_page/setting_dark_mode.dart';
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
                widthFactor: 0.95,
                child: ListView(children: [
                  lightGreyDivider,
                  InkWell(
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
                      subtitle: Consumer(
                          builder: (context, ThemeProvider provider, child) {
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
                  ),
                  lightGreyDivider,
                ]))));
  }
}

const lightGreyDivider = Divider(
  color: Color.fromRGBO(211, 211, 211, 1),
);
