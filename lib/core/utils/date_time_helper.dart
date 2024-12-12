String convertDateTimeToString(DateTime dateTime) {
  final year = dateTime.year.toString();
  var month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  var day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  final yyyymmdd = '$year-$month-$day';
  return yyyymmdd;
}

//String getWeekDay(DateTime date) => date.weekday.toString();
DateTime startOfWeekDate() {
  final today = DateTime.now();

  // Calculate the difference in days between today and the most recent Monday.
  final difference = today.weekday - 1;

  // Subtract the difference to get the start of the week (Monday).
  final startOfWeek = today.subtract(Duration(days: difference));

  return startOfWeek;
}

String getDayName(DateTime date) {
  switch (date.weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'Monday';
  }
}
