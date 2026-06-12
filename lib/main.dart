import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/app/routes/app_pages.dart';
import 'package:demo/app/theme/app_theme.dart';
import 'package:demo/app/constants/app_constants.dart';

void main() {
  runApp(const SkateMapApp());
}

class SkateMapApp extends StatelessWidget {
  const SkateMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
