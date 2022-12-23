class Tripz {
  String id;
  String title;
  DateTime startTime;
  DateTime endTime;
  int seats;

  String get seatState {
    return seats < 40 ? '$seats/40 ghế' : 'Hết chỗ';
  }

  Tripz({
    required this.id,
    this.title = '',
    required this.startTime,
    required this.endTime,
    this.seats = 40,
  });
}
