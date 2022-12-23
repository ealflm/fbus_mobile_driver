import 'package:latlong2/latlong.dart';

class Routez {
  String id;
  String title;
  List<String>? stationIds;
  List<String>? tripIds;
  List<LatLng> points;

  Routez({
    required this.id,
    required this.title,
    required this.points,
    required this.stationIds,
    required this.tripIds,
  });
}
