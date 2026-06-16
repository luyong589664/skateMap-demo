import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index_controller.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    final IndexController controller = Get.put(IndexController());

    return Scaffold(
      appBar: AppBar(title: const Text('IndexPage')),
      body: const Center(child: Text('IndexPage')),
    );
  }
}
