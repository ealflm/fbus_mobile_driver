import 'package:latlong2/latlong.dart';

import '../models/direction_model.dart';

abstract class GoongRepository {
  /// Return list of route
  Future<List<LatLng>> getRoutePoints(List<LatLng> locations);

  Future<Direction?> getDirection(List<LatLng> locations);
}
