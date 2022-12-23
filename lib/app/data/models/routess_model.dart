class Routes {
  int? statusCode;
  String? message;
  List<Body>? body;

  Routes({this.statusCode, this.message, this.body});

  Routes.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['body'] != null) {
      body = <Body>[];
      json['body'].forEach((v) {
        body?.add(Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (body != null) {
      data['body'] = body?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Body {
  String? routeId;
  String? name;
  double? distance;
  int? totalStation;
  List<StationList>? stationList;
  int? status;

  Body(
      {this.routeId,
      this.name,
      this.distance,
      this.totalStation,
      this.stationList,
      this.status});

  Body.fromJson(Map<String, dynamic> json) {
    routeId = json['routeId'];
    name = json['name'];
    distance = json['distance'];
    totalStation = json['totalStation'];
    if (json['stationList'] != null) {
      stationList = <StationList>[];
      json['stationList'].forEach((v) {
        stationList?.add(StationList.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['routeId'] = routeId;
    data['name'] = name;
    data['distance'] = distance;
    data['totalStation'] = totalStation;
    if (stationList != null) {
      data['stationList'] = stationList?.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class StationList {
  String? stationId;
  String? name;
  String? address;
  double? longitude;
  double? latitude;
  int? status;

  StationList(
      {this.stationId,
      this.name,
      this.address,
      this.longitude,
      this.latitude,
      this.status});

  StationList.fromJson(Map<String, dynamic> json) {
    stationId = json['stationId'];
    name = json['name'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['stationId'] = stationId;
    data['name'] = name;
    data['address'] = address;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['status'] = status;
    return data;
  }
}
