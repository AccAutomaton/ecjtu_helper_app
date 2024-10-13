import 'package:ecjtu_helper/pages/settings_page/settings_home.dart';
import 'package:ecjtu_helper/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hms_scan_kit/flutter_hms_scan_kit.dart';
import 'package:flutter_hms_scan_kit/scan_result.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LibraryDefaultSeatSettingPage extends StatefulWidget {
  const LibraryDefaultSeatSettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LibraryDefaultSeatSettingPageState();
  }
}

class _LibraryDefaultSeatSettingPageState
    extends State<LibraryDefaultSeatSettingPage> {
  ScanResult? _scanResult;
  bool _hasDefaultSeat = false;
  String? _defaultSeat;


  @override
  void initState() {
    super.initState();
    readData("library_has_default_room_dev_id").then((hasDefaultSeat) {
      setState(() {
        if (hasDefaultSeat != null) {
          _hasDefaultSeat = bool.parse(hasDefaultSeat);
        }
      });
      if (bool.parse(hasDefaultSeat!)) {
        readData("library_default_room_dev_id").then((defaultSeat) {
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
        title: const Text("默认座位设置"),
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
                ElevatedButton.icon(
                  onPressed: () async {
                    _scanResult = await FlutterHmsScanKit.startScan();
                    String? url = _scanResult?.value;
                    if (url!.contains("http://update.unifound.net/wxnotice/s.aspx?c=")) {
                      String devId = url.substring(url.indexOf("=") + 1);
                      saveData("library_default_room_dev_id", devId);
                      saveData("library_has_default_room_dev_id", true.toString());
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