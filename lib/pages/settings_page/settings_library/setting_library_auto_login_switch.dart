import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/shared_preferences_util.dart';

class SettingLibraryAutoLoginSwitchModule extends StatefulWidget {
  const SettingLibraryAutoLoginSwitchModule({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingLibraryAutoLoginSwitchModuleState();
  }
}

class _SettingLibraryAutoLoginSwitchModuleState
    extends State<SettingLibraryAutoLoginSwitchModule> {
  bool _enableAutoLogin = false;

  @override
  void initState() {
    super.initState();
    readStringData("library_enableAutoLogin").then((data) => setState(() {
          if (data != null) {
            _enableAutoLogin = bool.tryParse(data)!;
          } else {
            _enableAutoLogin = false;
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.cloud_sync_outlined),
      title: const Text("自动登录服务"),
      trailing: Switch(
        value: _enableAutoLogin,
        onChanged: (value) async {
          if (value == true && !(await _hasCredential())) {
            Fluttertoast.showToast(
                msg: "请先填写图书馆登录凭据再开启此功能", gravity: ToastGravity.CENTER);
            return;
          }
          setState(() {
            _enableAutoLogin = value;
          });
          await saveStringData(
              "library_enableAutoLogin", _enableAutoLogin.toString());
        },
      ),
    );
  }

  Future<bool> _hasCredential() async {
    String? libraryUsername = await readStringData("library_username");
    if (libraryUsername == null || libraryUsername.isEmpty) {
      return false;
    }
    String? libraryPassword = await readStringData("library_password");
    if (libraryPassword == null || libraryPassword.isEmpty) {
      return false;
    }
    return true;
  }
}
