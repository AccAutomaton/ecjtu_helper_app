import 'package:flutter/material.dart';

import '../../../utils/shared_preferences_util.dart';

class SettingLibraryAutoLoginSwitch extends StatefulWidget {
  const SettingLibraryAutoLoginSwitch({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingLibraryAutoLoginSwitch();
  }
}

class _SettingLibraryAutoLoginSwitch
    extends State<SettingLibraryAutoLoginSwitch> {
  bool _enableAutoLogin = true;


  @override
  void initState() {
    super.initState();
    readStringData("library_enableAutoLogin").then((data) => setState(() {
      if (data != null) {
        _enableAutoLogin = bool.tryParse(data)!;
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.cloud_sync_outlined),
      title: const Text("图书馆自动登录服务"),
      trailing: Switch(
        value: _enableAutoLogin,
        onChanged: (value) async {
          setState(() {
            _enableAutoLogin = value;
          });
          await saveStringData("library_enableAutoLogin", _enableAutoLogin.toString());
        },
      ),
    );
  }
}
