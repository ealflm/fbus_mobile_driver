int compareDate(DateTime a, DateTime b) {
  DateTime tripDate = DateTime(a.year, a.month, a.day);
  DateTime todayDate = DateTime(b.year, b.month, b.day);
  return tripDate.compareTo(todayDate);
}
