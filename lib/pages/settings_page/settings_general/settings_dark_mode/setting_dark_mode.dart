import 'package:ecjtu_helper/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DarkModeSettingPage extends StatefulWidget {
  const DarkModeSettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DarkModeSettingState();
  }
}

class _DarkModeSettingState extends State<DarkModeSettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("深色模式"),
        ),
        body: Center(
            child: FractionallySizedBox(
                widthFactor: 0.9,
                child:
                    Consumer(builder: (context, ThemeProvider provider, child) {
                  return ListView(children: [
                    _darkModeOptionInkWell(
                        provider: provider,
                        themeMode: ThemeMode.system,
                        icon: const Icon(Icons.brightness_auto),
                        title: "跟随系统"),
                    _darkModeOptionInkWell(
                        provider: provider,
                        themeMode: ThemeMode.dark,
                        icon: const Icon(Icons.dark_mode),
                        title: "开启"),
                    _darkModeOptionInkWell(
                        provider: provider,
                        themeMode: ThemeMode.light,
                        icon: const Icon(Icons.light_mode),
                        title: "关闭"),
                  ]);
                }))));
  }

  InkWell _darkModeOptionInkWell(
      {required ThemeProvider provider,
        required ThemeMode themeMode,
        required Icon icon,
        required String title}) {
    return InkWell(
      onTap: () async {
        await provider.setThemeMode(themeMode);
      },
      child: ListTile(
        leading: icon,
        title: Text(title),
        trailing: Checkbox(
            value: provider.themeMode == themeMode,
            activeColor: Colors.blue,
            onChanged: (bool? value) async {
              provider.setThemeMode(themeMode);
            }),
      ),
    );
  }
}