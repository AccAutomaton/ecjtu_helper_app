import 'package:ecjtu_helper/pages/settings_page/settings_dark_mode/setting_dark_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/theme_provider.dart';

class SettingDarkModeEntranceModule extends StatefulWidget {
  const SettingDarkModeEntranceModule({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingDarkModeEntranceModuleState();
  }
}

class _SettingDarkModeEntranceModuleState
    extends State<SettingDarkModeEntranceModule> {
  @override
  Widget build(BuildContext context) {
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
        // ignore: prefer_const_constructors
        child: ListTile(
          leading: const Icon(Icons.light_mode_outlined),
          title: const Text("深色模式"),
          // subtitle: Consumer(builder: (context, ThemeProvider provider, child) {
          //   switch (provider.themeMode) {
          //     case ThemeMode.light:
          //       return const Text("夜间模式已关闭");
          //     case ThemeMode.dark:
          //       return const Text("夜间模式已开启");
          //     default:
          //       return const Text("跟随系统");
          //   }
          // }),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      );
    });
  }
}
