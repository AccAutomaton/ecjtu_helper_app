import 'package:ecjtu_helper/pages/about.dart';
import 'package:ecjtu_helper/pages/campus_network.dart';
import 'package:flutter/material.dart';

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
          appBar: AppBar(
            title: const Text("ECJTU Helper", textDirection: TextDirection.ltr),
          ),
          body: getPage(_currentIndex),
          bottomNavigationBar: NavigationBar(
            destinations: navigationList,
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        )
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return CampusNetworkPage();
      case 1:
        return AboutPage();
      default:
        throw Exception();
    }
  }
}

const List<NavigationDestination> navigationList = [
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