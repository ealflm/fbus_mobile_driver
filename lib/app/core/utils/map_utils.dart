import 'dart:math';

import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MapUtils {
  static LatLngBounds padTop(
      LatLngBounds bounds, double bufferRatio, double bottomBufferRatio) {
    bounds.pad(bufferRatio);
    LatLng? ne = bounds.northEast;
    LatLng? sw = bounds.southWest;

    final heightBuffer = (sw!.latitude - ne!.latitude).abs();
    final widthBuffer = (sw.longitude - ne.longitude).abs();
    final buffer = max(heightBuffer, widthBuffer) * bottomBufferRatio;

    sw = LatLng(sw.latitude - buffer, sw.longitude);
    bounds.extend(sw);

    return bounds;
  }
}
