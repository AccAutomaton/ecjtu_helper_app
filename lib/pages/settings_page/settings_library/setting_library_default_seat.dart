import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _SettingLibraryDefaultSeatPage
    extends State<SettingLibraryDefaultSeatPage> {
  ScanResult? _scanResult;
  bool _hasDefaultSeat = false;
  String? _defaultSeat;

  @override
  void initState() {
    super.initState();
    readStringData("library_has_default_room_dev_id").then((hasDefaultSeat) {
      if (hasDefaultSeat != null) {
        setState(() {
          _hasDefaultSeat = bool.parse(hasDefaultSeat);
        });
        if (_hasDefaultSeat) {
          readStringData("library_default_room_dev_id").then((defaultSeat) {
            setState(() {
              _defaultSeat = defaultSeat!;
            });
          });
        }
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
                Column(
                  children: [
                    const Text("当前默认座位", style: TextStyle(color: Colors.grey)),
                    if (_hasDefaultSeat) ...[
                      FutureBuilder(
                          future: getDetailInformation(_defaultSeat!),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return defaultSeatInformation(snapshot.data.$1,
                                  snapshot.data.$2, snapshot.data.$3);
                            }
                            else {
                              return const Text("加载中");
                            }
                          })
                    ] else ...[
                      const Text("无")
                    ]
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      _scanResult = await FlutterHmsScanKit.startScan();
                      String? url = _scanResult?.value;
                      if (url!.contains(
                          "http://update.unifound.net/wxnotice/s.aspx?c=")) {
                        String devId = url.substring(url.indexOf("=") + 1);
                        saveStringData("library_default_room_dev_id", devId);
                        saveStringData(
                            "library_has_default_room_dev_id", true.toString());
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

Future<(String labName, String roomName, String devName)> getDetailInformation(
    String queryParamC) async {
  List<String> stringList = queryParamC.split("_");
  String? labId = stringList[0];
  String? devId = stringList[2];
  String labName = "", roomName = "", devName = "";
  List devList = jsonDecode(
      await rootBundle.loadString('jsons/library/labId_$labId.json'));
  for (int i = 0; i < devList.length; i++) {
    if (devList[i]["devId"].toString() == devId) {
      labName = devList[i]["labName"].toString();
      roomName = devList[i]["roomName"].toString();
      devName = devList[i]["devName"].toString();
    }
  }
  return (labName, roomName, devName);
}

Widget defaultSeatInformation(String labName, String roomName, String devName) {
  return Container(
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
    child: Column(
      children: [
        Text(labName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        Text(roomName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24)),
        Text(devName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 32)),
      ],
    ),
  );
}
