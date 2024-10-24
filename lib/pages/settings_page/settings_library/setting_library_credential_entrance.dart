import 'package:ecjtu_helper/pages/settings_page/settings_library/setting_library_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingLibraryCredentialEntranceModule extends StatefulWidget {
  const SettingLibraryCredentialEntranceModule({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingLibraryCredentialEntranceModule();
  }

}

class _SettingLibraryCredentialEntranceModule extends State<SettingLibraryCredentialEntranceModule> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(builder: (BuildContext context) {
            return const SettingLibraryCredentialPage();
          }),
        );
      },
      child: const ListTile(
        leading: Icon(Icons.manage_accounts_outlined),
        title: Text("登录凭据"),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

}