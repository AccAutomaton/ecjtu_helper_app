import 'package:ecjtu_helper/pages/settings_page/settings_library/setting_library_default_seat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingLibraryDefaultSeatEntranceModule extends StatefulWidget {
  const SettingLibraryDefaultSeatEntranceModule({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingLibraryDefaultSeatEntranceModuleState();
  }

}

class _SettingLibraryDefaultSeatEntranceModuleState extends State<SettingLibraryDefaultSeatEntranceModule> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          CupertinoPageRoute(builder: (BuildContext context) {
            return const SettingLibraryDefaultSeatPage();
          }),
        );
      },
      child: const ListTile(
        leading: Icon(Icons.chair_outlined),
        title: Text("默认座位"),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

}