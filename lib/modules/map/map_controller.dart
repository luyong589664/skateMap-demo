import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gmm_amap_flutter_map/gmm_amap_flutter_map.dart';
import 'package:gmm_amap_flutter_base/gmm_amap_flutter_base.dart';
import 'package:demo/utils/coordinate_converter.dart';

class MapController extends GetxController {
  /// 高德 的 MapController，用于程序化控制地图
  AMapController? mapController;

  /// 地图中心点（默认上海）
  final Rx<LatLng> center = const LatLng(31.2304, 121.4737).obs;

  // ⭐ 新增：用户当前位置（可能为 null）
  final Rx<LatLng?> userLocation = Rx<LatLng?>(null);
  final RxBool isLoadingLocation = false.obs;

  /// 缩放级别
  final RxDouble zoom = 10.0.obs;

  @override
  void onInit() {
    super.onInit();
    // ⭐ 页面打开时自动获取定位
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    isLoadingLocation.value = true;

    try {
      // 1️⃣ 检查定位服务是否开启
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint('定位服务开启: $serviceEnabled');
      if (!serviceEnabled) {
        debugPrint('❌ 请打开手机定位服务');
        isLoadingLocation.value = false;
        return;
      }

      // 2️⃣ 权限检查
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('当前权限状态: $permission');
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        debugPrint('请求权限后状态: $permission');
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('❌ 权限被拒绝');
        isLoadingLocation.value = false;
        return;
      }

      // 3️⃣ 先拿缓存位置
      final lastPosition = await Geolocator.getLastKnownPosition();
      debugPrint('上次位置: $lastPosition');
      if (lastPosition != null && userLocation.value == null) {
        final loc = CoordinateConverter.wgs84ToGcj02(
          LatLng(lastPosition.latitude, lastPosition.longitude),
        );
        userLocation.value = loc;
        center.value = loc;
        mapController?.moveCamera(CameraUpdate.newLatLngZoom(loc, zoom.value));
      }

      // 4️⃣ 获取当前位置（加 45 秒超时，避免无限等待）
      Get.snackbar('定位中', '正在获取位置，请稍候…', snackPosition: SnackPosition.BOTTOM);
      final position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 45),
          forceLocationManager: true, // ⭐ 关键：不走 Google Play，用原生定位
        ),
      );
      debugPrint('获取到位置: $position');

      final wgs84 = LatLng(position.latitude, position.longitude);
      final location = CoordinateConverter.wgs84ToGcj02(wgs84); // ⭐ WGS-84 → GCJ-02
      userLocation.value = location;
      center.value = location;
      mapController?.moveCamera(CameraUpdate.newLatLngZoom(location, 15.0));
    } catch (e) {
      debugPrint('获取位置失败: $e');
      Get.snackbar('定位失败', '无法获取位置，请到开阔处重试',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingLocation.value = false;
    }
  }
}
