class Bus {
  String? id;
  String? licensePlates;
  String? color;
  int? seat;

  Bus({this.id, this.licensePlates, this.color, this.seat});

  Bus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    licensePlates = json['licensePlates'];
    color = json['color'];
    seat = json['seat'];
  }
}
