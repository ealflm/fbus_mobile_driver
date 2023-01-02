import 'package:hyper_app_settings/hyper_app_settings.dart';

class Driver {
  String? id;
  String? fullName;
  String? phone;
  String? photoUrl;
  String? address;

  Driver({this.id, this.fullName, this.phone, this.photoUrl, this.address});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['driverId'];
    fullName = json['fullName'];
    phone = json['phone'];
    photoUrl = AppSettings.get('driverPhotoUrlHost') +
        '/' +
        (json['photoUrl'] ?? '').trim();
    address = json['address'];
  }

  Driver.fromJsonCapitalizeFirstLetter(Map<String, dynamic> json) {
    id = json['DriverId'];
    fullName = json['FullName'];
    phone = json['Phone'];
    photoUrl = AppSettings.get('driverPhotoUrlHost') +
        '/' +
        (json['PhotoUrl'] ?? '').trim();
    address = json['Address'];
  }
}
