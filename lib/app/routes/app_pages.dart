import 'package:get/get.dart';
import 'package:demo/app/routes/app_routes.dart';
import 'package:demo/modules/map/map_page.dart';
import 'package:demo/modules/map/map_binding.dart';
import 'package:demo/modules/spot_detail/spot_detail_page.dart';
import 'package:demo/modules/add_spot/add_spot_page.dart';
import 'package:demo/modules/admin_review/admin_review_page.dart';

class AppPages {
  static const initial = AppRoutes.map;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.map,
      page: () => const MapPage(),
      binding: MapBinding(),
    ),
    GetPage(name: AppRoutes.spotDetail, page: () => const SpotDetailPage()),
    GetPage(name: AppRoutes.addSpot, page: () => const AddSpotPage()),
    GetPage(name: AppRoutes.adminReview, page: () => const AdminReviewPage()),
  ];
}
