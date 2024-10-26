import 'package:ecjtu_helper/pages/settings_page/settings_campus_network/setting_campus_network_credential.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingCampusNetworkCredentialEntranceModule extends StatefulWidget {
  const SettingCampusNetworkCredentialEntranceModule({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingCampusNetworkCredentialEntranceModule();
  }

}

class _SettingCampusNetworkCredentialEntranceModule extends State<SettingCampusNetworkCredentialEntranceModule> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(builder: (BuildContext context) {
            return const SettingCampusNetworkCredentialPage();
          }),
        );
      },
      child: const ListTile(
        leading: Icon(Icons.wifi_password_outlined),
        title: Text("登录凭据"),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

}