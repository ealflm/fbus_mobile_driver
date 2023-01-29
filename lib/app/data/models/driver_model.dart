import '../../core/utils/hyper_app_settings.dart';

class Driver {
  String? id;
  String? fullName;
  String? phone;
  String? photoUrl;
  String? address;
  int? status;

  Driver({this.id, this.fullName, this.phone, this.photoUrl, this.address});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['driverId'];
    fullName = json['fullName'];
    phone = json['phone'];
    var photos = (json['photoUrl'] ?? '').trim().split(' ');
    photoUrl = AppSettings.get('driverPhotoUrlHost') + '/' + photos.last ?? '';
    address = json['address'];
    status = int.parse((json['status'] ?? '0').toString());
  }

  Driver.fromJsonCapitalizeFirstLetter(Map<String, dynamic> json) {
    id = json['DriverId'];
    fullName = json['FullName'];
    phone = json['Phone'];
    var photos = (json['PhotoUrl'] ?? '').trim().split(' ');
    photoUrl = AppSettings.get('driverPhotoUrlHost') + '/' + photos.last ?? '';
    address = json['Address'];
    status = int.parse((json['Status'] ?? '0').toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverId'] = id;
    data['fullName'] = fullName;
    data['phone'] = phone;
    data['photoUrl'] = photoUrl;
    data['address'] = address;
    data['status'] = status;
    return data;
  }
}
