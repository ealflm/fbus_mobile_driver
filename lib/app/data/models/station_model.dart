import 'package:latlong2/latlong.dart';

class Station {
  String? id;
  String? name;
  String? address;
  LatLng? location;
  int? status;

  Station({
    this.id,
    this.name,
    this.address,
    this.location,
    this.status,
  });

  Station.fromJson(Map<String, dynamic> json) {
    id = json['stationId'];
    name = json['name'];
    address = json['address'];
    double lat = json['latitude'] ?? 0;
    double lng = json['longitude'] ?? 0;
    location = LatLng(lat, lng);
    status = json['status'];
  }

  Station.fromJsonCapitalizeFirstLetter(Map<String, dynamic> json) {
    id = json['StationId'];
    name = json['Name'];
    address = json['Address'];
    double lat = json['Latitude'] ?? 0;
    double lng = json['Longitude'] ?? 0;
    location = LatLng(lat, lng);
    status = json['Status'];
  }
}
