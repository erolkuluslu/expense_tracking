String convertDateTimeToString(DateTime dateTime) {
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0' + month;
  }
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0' + day;
  }
  String yyyymmdd = '$year-$month-$day';
  return yyyymmdd;
}

//String getWeekDay(DateTime date) => date.weekday.toString();
DateTime startOfWeekDate() {
  DateTime today = DateTime.now();

  // Calculate the difference in days between today and the most recent Monday.
  int difference = today.weekday - 1;

  // Subtract the difference to get the start of the week (Monday).
  DateTime startOfWeek = today.subtract(Duration(days: difference));

  return startOfWeek;
}

String getDayName(DateTime date) {
  switch (date.weekday) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "Monday";
  }
}
