import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmm_amap_flutter_map/gmm_amap_flutter_map.dart';

import 'map_controller.dart';

class MapPage extends GetView<MapController> {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ⭐ 高德地图
          Obx(
            () => AMapWidget(
              onMapCreated: (AMapController ctrl) {
                controller.mapController = ctrl;
              },
              initialCameraPosition: CameraPosition(
                target: controller.center.value,
                zoom: controller.zoom.value,
              ),
              markers: controller.userLocation.value != null
                  ? {
                      Marker(
                        position: controller.userLocation.value!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure),
                      ),
                    }
                  : <Marker>{},
            ),
          ),
          // 定位按钮
          Positioned(
            right: 18,
            bottom: 48,
            child: Obx(
              () => FloatingActionButton(
                mini: true,
                onPressed: controller.getCurrentLocation,
                child: controller.isLoadingLocation.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
