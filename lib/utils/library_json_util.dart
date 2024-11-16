import 'dart:convert';

import 'package:flutter/services.dart';

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