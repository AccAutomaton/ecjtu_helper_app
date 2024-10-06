import 'package:flutter/material.dart';

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsHomePageState();
  }
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("设置"),
        ),
        body: const Center(
          child: Text("敬请期待", style: TextStyle(fontSize: 32, color: Colors.grey),),
        )
    );
  }
}
