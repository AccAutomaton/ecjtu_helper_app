import 'package:ecjtu_helper/pages/about.dart';
import 'package:ecjtu_helper/pages/campus_network.dart';
import 'package:ecjtu_helper/pages/library_webview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainNavBarPage extends StatefulWidget {
  const MainNavBarPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainNavBarPageState();
  }
}

class _MainNavBarPageState extends State<MainNavBarPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: const [
              LibraryWebviewPage(),
              CampusNetworkPage(),
              AboutPage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            destinations: navigationList,
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                if (index != 1) {
                  _currentIndex = index;
                } else {
                  Fluttertoast.showToast(
                      msg: "该功能尚在测试中",
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.brown);
                }
              });
            },
          ),
        ));
  }
}

const List<NavigationDestination> navigationList = [
  NavigationDestination(
    tooltip: "",
    icon: Icon(Icons.collections_bookmark_outlined),
    label: "图书馆",
    selectedIcon: Icon(Icons.collections_bookmark),
  ),
  NavigationDestination(
    tooltip: "",
    icon: Icon(Icons.wifi),
    label: "校园网",
    selectedIcon: Icon(Icons.wifi),
  ),
  NavigationDestination(
    tooltip: "",
    icon: Icon(Icons.info_outline),
    label: "关于",
    selectedIcon: Icon(Icons.info),
  )
];
