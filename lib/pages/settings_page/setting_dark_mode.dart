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
                widthFactor: 0.95,
                child:
                    Consumer(builder: (context, ThemeProvider provider, child) {
                  return ListView(children: [
                    InkWell(
                      onTap: () async {
                        await provider.setThemeMode(ThemeMode.system);
                      },
                      child: ListTile(
                        leading: const Icon(Icons.brightness_auto),
                        title: const Text("跟随系统"),
                        trailing: Checkbox(
                            value: provider.themeMode == ThemeMode.system,
                            activeColor: Colors.blue,
                            onChanged: (bool? value) async {
                              provider.setThemeMode(ThemeMode.system);
                            }),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        provider.setThemeMode(ThemeMode.dark);
                      },
                      child: ListTile(
                        leading: const Icon(Icons.dark_mode),
                        title: const Text("开启"),
                        trailing: Checkbox(
                            value: provider.themeMode == ThemeMode.dark,
                            activeColor: Colors.blue,
                            onChanged: (bool? value) async {
                              provider.setThemeMode(ThemeMode.dark);
                            }),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        provider.setThemeMode(ThemeMode.light);
                      },
                      child: ListTile(
                        leading: const Icon(Icons.light_mode),
                        title: const Text("关闭"),
                        trailing: Checkbox(
                            value: provider.themeMode == ThemeMode.light,
                            activeColor: Colors.blue,
                            onChanged: (bool? value) async {
                              provider.setThemeMode(ThemeMode.light);
                            }),
                      ),
                    ),
                  ]);
                }))));
  }
}
