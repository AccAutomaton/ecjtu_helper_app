import 'package:flutter/material.dart';
import 'package:flutter_hms_scan_kit/flutter_hms_scan_kit.dart';
import 'package:flutter_hms_scan_kit/scan_result.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/shared_preferences_util.dart';
import '../settings_home.dart';

class SettingLibraryDefaultSeatPage extends StatefulWidget {
  const SettingLibraryDefaultSeatPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingLibraryDefaultSeatPage();
  }

}

class _SettingLibraryDefaultSeatPage extends State<SettingLibraryDefaultSeatPage> {
  ScanResult? _scanResult;
  bool _hasDefaultSeat = false;
  String? _defaultSeat;


  @override
  void initState() {
    super.initState();
    readStringData("library_has_default_room_dev_id").then((hasDefaultSeat) {
      setState(() {
        if (hasDefaultSeat != null) {
          _hasDefaultSeat = bool.parse(hasDefaultSeat);
        }
      });
      if (bool.parse(hasDefaultSeat!)) {
        readStringData("library_default_room_dev_id").then((defaultSeat) {
          setState(() {
            _defaultSeat = defaultSeat!;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("图书馆默认座位设置"),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(flex: 1, child: Container()),
            Column(
              children: [
                Expanded(flex: 1, child: Container()),
                Row(children: [
                  const Text("当前默认座位："),
                  if (_hasDefaultSeat) ...[
                    Text("$_defaultSeat")
                  ]
                  else ...[
                    const Text("无")
                  ]
                ],),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      _scanResult = await FlutterHmsScanKit.startScan();
                      String? url = _scanResult?.value;
                      if (url!.contains("http://update.unifound.net/wxnotice/s.aspx?c=")) {
                        String devId = url.substring(url.indexOf("=") + 1);
                        saveStringData("library_default_room_dev_id", devId);
                        saveStringData("library_has_default_room_dev_id", true.toString());
                        setState(() {
                          _defaultSeat = devId;
                          _hasDefaultSeat = true;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "未能识别到座位信息，请扫描正确的二维码",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.yellow[800]);
                      }
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text("扫描签到码以设置默认座位"),
                  ),
                ),

                lightGreyDivider,
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }

}