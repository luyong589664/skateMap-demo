import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'mine_controller.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final MineController controller = Get.put(MineController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('MinePage'),
      ),
      body: const Center(
        child: Text('MinePage'),
      ),
    );
  }
}
