Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int micros;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
  return Duration(hours: hours, minutes: minutes, microseconds: micros);
}

String formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('$days ngày, ');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('${hours.toString().padLeft(2, '0')}:');
  }
  if (tokens.isNotEmpty || minutes != 0) {
    tokens.add('${minutes.toString().padLeft(2, '0')}:');
  }
  tokens.add(seconds.toString().padLeft(2, '0'));

  return tokens.join();
}

String formatDurationOnlyHourMinite(Duration? d) {
  if (d == null) return '';
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (hours != 0) {
    tokens.add('$hours giờ, ');
  }
  if (minutes != 0) {
    tokens.add('$minutes phút');
  }

  return tokens.join();
}
