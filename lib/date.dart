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

/// Returns the first day of the [randomDate].
///
/// Weeks starts on a monday
DateTime firstDayOfWeek(DateTime randomDate) {
  return randomDate.subtract(Duration(days: randomDate.weekday - 1));
}
