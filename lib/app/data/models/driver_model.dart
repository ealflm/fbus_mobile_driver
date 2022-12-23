import 'package:hyper_app_settings/hyper_app_settings.dart';

class Driver {
  String? id;
  String? fullName;
  String? phone;
  String? photoUrl;
  String? address;

  Driver({this.id, this.fullName, this.phone, this.photoUrl, this.address});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    phone = json['phone'];
    photoUrl =
        AppSettings.get('driverPhotoUrlHost') + '/' + json['photoUrl'].trim();
    address = json['address'];
  }
}
