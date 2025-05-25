import 'package:flutter/material.dart';

import '../utils/shared_preferences_util.dart';

enum StartPage {
  // library(name: "图书馆"), campusNetwork(name: "校园网"), about(name: "关于");
  campusNetwork(name: "校园网"), about(name: "关于");

  final String name;

  const StartPage({required this.name});
}

class DefaultStartPageProvider with ChangeNotifier {
  StartPage defaultStartPage = StartPage.campusNetwork;

  DefaultStartPageProvider() {
    readIntData("default_start_page").then((value) {
      if (value != null) {
        defaultStartPage = StartPage.values[value];
      }
    });
    notifyListeners();
  }

  get() {
    return defaultStartPage;
  }

  setStartPage(StartPage startPage) async {
    await saveIntData("default_start_page", startPage.index);
    defaultStartPage = startPage;
    notifyListeners();
  }
}