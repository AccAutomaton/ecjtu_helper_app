import 'package:flutter/material.dart';

import '../settings_page/settings_library/setting_library_auto_login_switch.dart';
import '../settings_page/settings_library/setting_library_credential_entrance.dart';
import '../settings_page/settings_library/setting_library_default_seat_entrance.dart';

class LibrarySettingsPage extends StatefulWidget {
  const LibrarySettingsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LibrarySettingsPage();
  }
}

class _LibrarySettingsPage extends State<LibrarySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("图书馆工具设置"),
        ),
        body: Center(
            child: FractionallySizedBox(
          widthFactor: 0.925,
          child: ListView(children: const [
            SettingLibraryAutoLoginSwitchModule(),
            SettingLibraryCredentialEntranceModule(),
            SettingLibraryDefaultSeatEntranceModule(),
            Center(
              child: Text("设置完成后请在左上角刷新图书馆页面", style: TextStyle(color: Colors.grey)),
            )
          ]),
        )));
  }
}
