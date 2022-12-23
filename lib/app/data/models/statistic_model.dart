class Statistic {
  int? studentTripCount;
  int? studentTripNotUseCount;
  num? distance;

  Statistic(
      {this.studentTripCount, this.studentTripNotUseCount, this.distance});

  Statistic.fromJson(Map<String, dynamic> json) {
    studentTripCount = json['studentTripCount'];
    studentTripNotUseCount = json['studentTripNotUseCount'];
    distance = json['distance'];
  }
}
