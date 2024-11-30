import 'package:ecjtu_helper/provider/default_start_page_provider.dart';
import 'package:ecjtu_helper/provider/theme_provider.dart';
import 'package:ecjtu_helper/utils/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:ecjtu_helper/pages/about_home.dart';
import 'package:ecjtu_helper/pages/campus_network.dart';
import 'package:ecjtu_helper/pages/library_webview/library_webview_home.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => DefaultStartPageProvider())
  ], child: const MainNavBarPage()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainNavBarPage extends StatefulWidget {
  const MainNavBarPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainNavBarPageState();
  }
}

class _MainNavBarPageState extends State<MainNavBarPage> {
  int _currentIndex = 2;
  bool _isAboutPageBadgeVisible = false;

  @override
  void initState() {
    super.initState();
    hasUpdate().then((onValue) {
      bool hadUpdate = onValue.$1;
      if (hadUpdate) {
        setState(() {
          _isAboutPageBadgeVisible = true;
        });
      }
    });
    readIntData("default_start_page").then((value) {
      if (value != null) {
        setState(() {
          _currentIndex = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeProvider provider, child) {
      return MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: provider.themeMode,
          home: Scaffold(
            body: LazyLoadIndexedStack(
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
    });
  }
}
