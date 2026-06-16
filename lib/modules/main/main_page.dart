import 'package:demo/modules/map/map_page.dart';
import 'package:demo/modules/mine/mine_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static final List<Widget> _tabPages = [const MapPage(), const MinePage()];

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    return Scaffold(
      appBar: AppBar(title: const Text('MainPage')),
      body: const Center(child: Text('MainPage')),
    );
  }
}
