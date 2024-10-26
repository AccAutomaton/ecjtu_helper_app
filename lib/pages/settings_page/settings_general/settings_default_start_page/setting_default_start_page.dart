import 'package:ecjtu_helper/provider/default_start_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefaultStartPageSettingPage extends StatefulWidget {
  const DefaultStartPageSettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DefaultStartPageSettingPageState();
  }
}

class _DefaultStartPageSettingPageState
    extends State<DefaultStartPageSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("启动APP时默认展示的界面"),
        ),
        body: Center(
            child: FractionallySizedBox(
                widthFactor: 0.9,
                child:
                    Consumer(builder: (context, DefaultStartPageProvider provider, child) {
                  return ListView(children: [
                    defaultStartPageOptionInkWell(
                        provider: provider,
                        startPage: StartPage.library,
                        icon: const Icon(Icons.collections_bookmark_outlined),
                        title: "图书馆"),
                    defaultStartPageOptionInkWell(
                        provider: provider,
                        startPage: StartPage.campusNetwork,
                        icon: const Icon(Icons.wifi),
                        title: "校园网"),
                    defaultStartPageOptionInkWell(
                        provider: provider,
                        startPage: StartPage.about,
                        icon: const Icon(Icons.info_outline),
                        title: "关于"),
                  ]);
                }))));
  }
}

InkWell defaultStartPageOptionInkWell(
    {required DefaultStartPageProvider provider,
    required StartPage startPage,
    required Icon icon,
    required String title}) {
  return InkWell(
    onTap: () async {
      await provider.setStartPage(startPage);
    },
    child: ListTile(
      leading: icon,
      title: Text(title),
      trailing: Checkbox(
          value: provider.defaultStartPage == startPage,
          activeColor: Colors.blue,
          onChanged: (bool? value) async {
            provider.setStartPage(startPage);
          }),
    ),
  );
}
