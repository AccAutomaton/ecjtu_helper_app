import 'package:ecjtu_helper/pages/settings_page/settings_campus_network/setting_campus_network_credential_entrance.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_general/settings_dark_mode/setting_dark_mode_entrance.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_general/settings_default_start_page/setting_default_start_page_entrance.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_library/setting_library_appointment_entrance.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_library/setting_library_auto_login_switch.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_library/setting_library_credential_entrance.dart';
import 'package:ecjtu_helper/pages/settings_page/settings_library/setting_library_default_seat_entrance.dart';
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
            _settingLabel("通用"),
            const SettingDarkModeEntranceModule(),
            const SettingDefaultStartPageEntranceModule(),
            lightGreyDivider,
            _settingLabel("图书馆"),
            const SettingLibraryAutoLoginSwitchModule(),
            const SettingLibraryCredentialEntranceModule(),
            const SettingLibraryDefaultSeatEntranceModule(),
            const SettingLibraryAppointmentEntranceModule(),
            lightGreyDivider,
            _settingLabel("校园网"),
            const SettingCampusNetworkCredentialEntranceModule(),
            lightGreyDivider,
          ]),
        )));
  }

  Container _settingLabel(String content) {
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
      child: Text(content, style: const TextStyle(color: Colors.grey)),
    );
  }
}

const lightGreyDivider = Divider(
  color: Color.fromRGBO(211, 211, 211, 1),
);
