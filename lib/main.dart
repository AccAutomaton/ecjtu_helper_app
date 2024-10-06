import 'package:flutter/material.dart';
import 'package:ecjtu_helper/pages/about_home.dart';
import 'package:ecjtu_helper/pages/campus_network.dart';
import 'package:ecjtu_helper/pages/library_webview.dart';

void main() {
  runApp(const MainNavBarPage());
}

class MainNavBarPage extends StatefulWidget {
  const MainNavBarPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainNavBarPageState();
  }
}

class _MainNavBarPageState extends State<MainNavBarPage> {
  int _currentIndex = 1;
  bool _isAboutPageBadgeVisible = false;

  @override
  void initState() {
    super.initState();
    hasUpdate().then((onValue) {
      bool hadUpdate = onValue.$1;
      if (hadUpdate) {
        _isAboutPageBadgeVisible = true;
      }
    });
  }

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
            destinations: [
              const NavigationDestination(
                tooltip: "",
                icon: Icon(Icons.collections_bookmark_outlined),
                label: "图书馆",
                selectedIcon: Icon(Icons.collections_bookmark),
              ),
              const NavigationDestination(
                tooltip: "",
                icon: Icon(Icons.wifi),
                label: "校园网",
                selectedIcon: Icon(Icons.wifi),
              ),
              NavigationDestination(
                tooltip: "",
                icon: Badge(
                    isLabelVisible: _isAboutPageBadgeVisible,
                    smallSize: 10,
                    child: const Icon(Icons.info_outline)),
                label: "关于",
                selectedIcon: const Icon(Icons.info),
              )
            ],
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ));
  }
}