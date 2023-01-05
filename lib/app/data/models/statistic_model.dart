class Statistic {
  int? tripCount;
  int? tripNotUseCount;
  num? distance;

  String get distanceStr {
    if (distance != null) {
      double value = distance! / 1000;
      return value.toStringAsFixed(1);
    } else {
      return '0';
    }
  }

  Statistic({this.tripCount, this.tripNotUseCount, this.distance});

  Statistic.fromJson(Map<String, dynamic> json) {
    tripCount = json['tripCount'];
    tripNotUseCount = json['tripNotUseCount'];
    distance = json['distance'];
  }
}
