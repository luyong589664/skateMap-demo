import 'package:demo/modules/index/index_binding.dart';
import 'package:demo/modules/index/index_page.dart';
import 'package:demo/modules/login/login_binding.dart';
import 'package:demo/modules/login/login_page.dart';
import 'package:demo/modules/map/add_spot/add_spot_page.dart';
import 'package:demo/modules/mine/mine_binding.dart';
import 'package:demo/modules/register/register_binding.dart';
import 'package:demo/modules/register/register_page.dart';
import 'package:get/get.dart';
import 'package:demo/app/routes/app_routes.dart';
import 'package:demo/modules/map/map_page.dart';
import 'package:demo/modules/map/map_binding.dart';
import 'package:demo/modules/spot_detail/spot_detail_page.dart';
import 'package:demo/modules/admin_review/admin_review_page.dart';
import '../../modules/main/main_binding.dart';
import '../../modules/main/main_page.dart';

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
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.mine,
      page: () => const MainPage(),
      binding: MineBinding(),
    ),
    GetPage(
      name: AppRoutes.index,
      page: () => const IndexPage(),
      binding: IndexBinding(),
    ),
  ];
}
