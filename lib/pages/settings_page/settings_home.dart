import 'package:ecjtu_helper/pages/settings_page/settings_dark_mode/setting_dark_mode_entrance.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_default_start_page/setting_default_start_page_entrance.dart';
import 'package:flutter/material.dart';

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
            const SettingDarkModeEntranceModule(),
            const SettingDefaultStartPageEntranceModule(),
            lightGreyDivider,
            settingLabel("图书馆"),
            lightGreyDivider,
            settingLabel("校园网"),
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