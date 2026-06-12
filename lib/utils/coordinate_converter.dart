import 'dart:math';

import 'package:gmm_amap_flutter_base/gmm_amap_flutter_base.dart';

class CoordinateConverter {
  static const double _pi = 3.1415926535897932384626;
  static const double _a = 6378245.0; // 长半轴
  static const double _ee = 0.00669342162296594323; // 椭球偏心率

  /// WGS-84 → GCJ-02（火星坐标系）
  /// GPS 拿到的坐标在中国使用高德/腾讯地图时，需要转换
  static LatLng wgs84ToGcj02(LatLng wgs84) {
    if (_outOfChina(wgs84.latitude, wgs84.longitude)) {
      return wgs84;
    }

    double dlat = _transformLat(wgs84.longitude - 105.0, wgs84.latitude - 35.0);
    double dlng = _transformLng(wgs84.longitude - 105.0, wgs84.latitude - 35.0);
    double radlat = wgs84.latitude / 180.0 * _pi;
    double magic = sin(radlat);
    magic = 1 - _ee * magic * magic;
    double sqrtmagic = sqrt(magic);
    dlat = (dlat * 180.0) / ((_a * (1 - _ee)) / (magic * sqrtmagic) * _pi);
    dlng = (dlng * 180.0) / (_a / sqrtmagic * cos(radlat) * _pi);
    double mglat = wgs84.latitude + dlat;
    double mglng = wgs84.longitude + dlng;
    return LatLng(mglat, mglng);
  }

  static bool _outOfChina(double lat, double lng) {
    return lng < 72.004 || lng > 137.8347 || lat < 0.8293 || lat > 55.8271;
  }

  static double _transformLat(double x, double y) {
    double ret = -100.0 +
        2.0 * x +
        3.0 * y +
        0.2 * y * y +
        0.1 * x * y +
        0.2 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * _pi) + 20.0 * sin(2.0 * x * _pi)) * 2.0 / 3.0;
    ret +=
        (20.0 * sin(y * _pi) + 40.0 * sin(y / 3.0 * _pi)) * 2.0 / 3.0;
    ret +=
        (160.0 * sin(y / 12.0 * _pi) + 320.0 * sin(y * _pi / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  static double _transformLng(double x, double y) {
    double ret = 300.0 +
        x +
        2.0 * y +
        0.1 * x * x +
        0.1 * x * y +
        0.1 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * _pi) + 20.0 * sin(2.0 * x * _pi)) * 2.0 / 3.0;
    ret +=
        (20.0 * sin(x * _pi) + 40.0 * sin(x / 3.0 * _pi)) * 2.0 / 3.0;
    ret +=
        (150.0 * sin(x / 12.0 * _pi) + 300.0 * sin(x / 30.0 * _pi)) * 2.0 / 3.0;
    return ret;
  }
}
