import 'package:ecjtu_helper/pages/settings_page/settings_library/setting_library_appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/shared_preferences_util.dart';

class SettingLibraryAppointmentEntranceModule extends StatefulWidget {
  const SettingLibraryAppointmentEntranceModule({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingLibraryAppointmentEntranceModuleState();
  }

}

class _SettingLibraryAppointmentEntranceModuleState extends State<SettingLibraryAppointmentEntranceModule> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        readStringData("library_has_default_room_dev_id").then((hasDefaultSeat) async {
          if (hasDefaultSeat != null) {
              if (bool.parse(hasDefaultSeat)) {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (BuildContext context) {
                    return const SettingLibraryAppointmentPage();
                  }),
                );
                return;
              }
          }
          Fluttertoast.showToast(
              msg: "请先设置默认座位再使用快速预约功能",
              gravity: ToastGravity.BOTTOM);
        });

      },
      child: const ListTile(
        leading: Icon(Icons.lock_clock_outlined),
        title: Text("预约"),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

}