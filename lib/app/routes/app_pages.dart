import 'package:demo/app/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../modules/map/map_page.dart';

class AppPages {
  static const initial = AppRoutes.map;
  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.map, page: () => const MapPage()),
  ];
}
