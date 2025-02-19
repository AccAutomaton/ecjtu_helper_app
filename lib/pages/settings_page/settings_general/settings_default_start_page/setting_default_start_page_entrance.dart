import 'package:ecjtu_helper/pages/settings_page/settings_general/settings_default_start_page/setting_default_start_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/default_start_page_provider.dart';

class SettingDefaultStartPageEntranceModule extends StatefulWidget {
  const SettingDefaultStartPageEntranceModule({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingDefaultStartPageEntranceModuleState();
  }
}

class _SettingDefaultStartPageEntranceModuleState
    extends State<SettingDefaultStartPageEntranceModule> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, DefaultStartPageProvider provider, child) {
      return InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(builder: (BuildContext context) {
              return const DefaultStartPageSettingPage();
            }),
          );
        },
        child: const ListTile(
          leading: Icon(Icons.home_outlined),
          title: Text("启动APP时默认展示的界面"),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      );
    });
  }
}
