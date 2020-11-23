import 'package:intl/intl.dart';

/// Calculates the first day of an ISO week date
///
/// To learn more about the ISO week date follow this link:
/// https://en.wikipedia.org/wiki/ISO_week_date
DateTime isoWeekToDate(int year, int week) {
  // Create a base line
  DateTime baseLine = DateTime(year).add(Duration(days: (week - 1) * 7));

  // Calculate the correct day
  int dow = baseLine.weekday;

  DateTime isoWeek;

  if (dow <= 4) {
    isoWeek =
        DateTime(year, baseLine.month).add(Duration(days: baseLine.day - dow));
  } else {
    isoWeek = DateTime(year, baseLine.month)
        .add(Duration(days: baseLine.day + 8 - dow));
  }

  return isoWeek;
}

/// The number of weeks in a year
int isoWeeksInYear(int year) {
  int p(int y) {
    return ((y + (y / 4) - (y / 100) - (y / 400)) % 7).toInt();
  }

  if (p(year) == 4 || p(year - 1) == 3) {
    return 53;
  } else {
    return 52;
  }
}

/// Converts a Date to a array contain a year and a week number
List isoDateToWeek(DateTime randomDate) {
  final int w = (int.parse(DateFormat('D').format(randomDate)) -
          randomDate.weekday +
          10) ~/
      7;

  if (w < 1) {
    // Last year
    return [randomDate.year - 1, isoWeeksInYear(randomDate.year - 1)];
  } else if (w > isoWeeksInYear(randomDate.year)) {
    // Next year
    return [randomDate.year + 1, 1];
  } else {
    // This year
    return [randomDate.year, w];
  }
}

/// Returns the first day of the [randomDate].
///
/// Weeks starts on a monday
DateTime firstDayOfWeek(DateTime randomDate) {
  return randomDate.subtract(Duration(days: randomDate.weekday - 1));
}
