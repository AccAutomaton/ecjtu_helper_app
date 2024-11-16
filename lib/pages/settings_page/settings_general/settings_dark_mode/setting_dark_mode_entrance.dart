import 'package:ecjtu_helper/pages/settings_page/settings_general/settings_dark_mode/setting_dark_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/theme_provider.dart';

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
        child: const ListTile(
          leading: Icon(Icons.light_mode_outlined),
          title: Text("深色模式"),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      );
    });
  }
}
