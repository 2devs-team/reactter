// coverage:ignore-file
part of '../signal.dart';

extension SignalDateTimeExt on Signal<DateTime> {
  /// Returns true if [this] occurs before [other].
  ///
  /// The comparison is independent
  /// of whether the time is in UTC or in the local time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final earlier = now.subtract(const Duration(seconds: 5));
  /// print(earlier.isBefore(now)); // true
  /// print(!now.isBefore(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(earlier.isBefore(now.toUtc())); // true
  /// print(earlier.toUtc().isBefore(now)); // true
  ///
  /// print(!now.toUtc().isBefore(now)); // true
  /// print(!now.isBefore(now.toUtc())); // true
  /// ```
  bool isBefore(DateTime other) => value.isBefore(other);

  /// Returns true if [this] occurs after [other].
  ///
  /// The comparison is independent
  /// of whether the time is in UTC or in the local time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final later = now.add(const Duration(seconds: 5));
  /// print(later.isAfter(now)); // true
  /// print(!now.isBefore(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(later.isAfter(now.toUtc())); // true
  /// print(later.toUtc().isAfter(now)); // true
  ///
  /// print(!now.toUtc().isAfter(now)); // true
  /// print(!now.isAfter(now.toUtc())); // true
  /// ```
  bool isAfter(DateTime other) => value.isAfter(other);

  /// Returns true if [this] occurs at the same moment as [other].
  ///
  /// The comparison is independent of whether the time is in UTC or in the local
  /// time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final later = now.add(const Duration(seconds: 5));
  /// print(!later.isAtSameMomentAs(now)); // true
  /// print(now.isAtSameMomentAs(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(!later.isAtSameMomentAs(now.toUtc())); // true
  /// print(!later.toUtc().isAtSameMomentAs(now)); // true
  ///
  /// print(now.toUtc().isAtSameMomentAs(now)); // true
  /// print(now.isAtSameMomentAs(now.toUtc())); // true
  /// ```
  bool isAtSameMomentAs(DateTime other) => value.isAtSameMomentAs(other);

  /// Compares this DateTime Object to [other],
  /// returning zero if the values are equal.
  ///
  /// A [compareTo] function returns:
  ///  * a negative value if this DateTime [isBefore] [other].
  ///  * `0` if this DateTime [isAtSameMomentAs] [other], and
  ///  * a positive value otherwise (when this DateTime [isAfter] [other]).
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final future = now.add(const Duration(days: 2));
  /// final past = now.subtract(const Duration(days: 2));
  /// final newDate = now.toUtc();
  ///
  /// print(now.compareTo(future)); // -1
  /// print(now.compareTo(past)); // 1
  /// print(now.compareTo(newDate)); // 0
  /// ```
  int compareTo(DateTime other) => value.compareTo(other);

  /// Returns this DateTime value in the local time zone.
  ///
  /// Returns [this] if it is already in the local time zone.
  /// Otherwise this method is equivalent to:
  ///
  /// ```dart template:expression
  /// DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
  ///                                     isUtc: false)
  /// ```
  DateTime toLocal() => value.toLocal();

  /// Returns this DateTime value in the UTC time zone.
  ///
  /// Returns [this] if it is already in UTC.
  /// Otherwise this method is equivalent to:
  ///
  /// ```dart template:expression
  /// DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
  ///                                     isUtc: true)
  /// ```
  DateTime toUtc() => value.toUtc();

  /// Returns an ISO-8601 full-precision extended format representation.
  ///
  /// The format is `yyyy-MM-ddTHH:mm:ss.mmmuuuZ` for UTC time, and
  /// `yyyy-MM-ddTHH:mm:ss.mmmuuu` (no trailing "Z") for local/non-UTC time,
  /// where:
  ///
  /// * `yyyy` is a, possibly negative, four digit representation of the year,
  ///   if the year is in the range -9999 to 9999,
  ///   otherwise it is a signed six digit representation of the year.
  /// * `MM` is the month in the range 01 to 12,
  /// * `dd` is the day of the month in the range 01 to 31,
  /// * `HH` are hours in the range 00 to 23,
  /// * `mm` are minutes in the range 00 to 59,
  /// * `ss` are seconds in the range 00 to 59 (no leap seconds),
  /// * `mmm` are milliseconds in the range 000 to 999, and
  /// * `uuu` are microseconds in the range 001 to 999. If [microsecond] equals
  ///   0, then this part is omitted.
  ///
  /// The resulting string can be parsed back using [parse].
  /// ```dart
  /// final moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);
  /// final isoDate = moonLanding.toIso8601String();
  /// print(isoDate); // 1969-07-20T20:18:04.000Z
  /// ```
  String toIso8601String() => value.toIso8601String();

  /// Returns a new [DateTime] instance with [duration] added to [this].
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysFromNow = today.add(const Duration(days: 50));
  /// ```
  ///
  /// Notice that the duration being added is actually 50 * 24 * 60 * 60
  /// seconds. If the resulting `DateTime` has a different daylight saving offset
  /// than `this`, then the result won't have the same time-of-day as `this`, and
  /// may not even hit the calendar date 50 days later.
  ///
  /// Be careful when working with dates in local time.
  DateTime add(Duration duration) => value.add(duration);

  /// Returns a new [DateTime] instance with [duration] subtracted from [this].
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysAgo = today.subtract(const Duration(days: 50));
  /// ```
  ///
  /// Notice that the duration being subtracted is actually 50 * 24 * 60 * 60
  /// seconds. If the resulting `DateTime` has a different daylight saving offset
  /// than `this`, then the result won't have the same time-of-day as `this`, and
  /// may not even hit the calendar date 50 days earlier.
  ///
  /// Be careful when working with dates in local time.
  DateTime subtract(Duration duration) => value.subtract(duration);

  /// Returns a [Duration] with the difference when subtracting [other] from
  /// [this].
  ///
  /// The returned [Duration] will be negative if [other] occurs after [this].
  ///
  /// ```dart
  /// final berlinWallFell = DateTime.utc(1989, DateTime.november, 9);
  /// final dDay = DateTime.utc(1944, DateTime.june, 6);
  ///
  /// final difference = berlinWallFell.difference(dDay);
  /// print(difference.inDays); // 16592
  /// ```
  ///
  /// The difference is measured in seconds and fractions of seconds.
  /// The difference above counts the number of fractional seconds between
  /// midnight at the beginning of those dates.
  /// If the dates above had been in local time, not UTC, then the difference
  /// between two midnights may not be a multiple of 24 hours due to daylight
  /// saving differences.
  ///
  /// For example, in Australia, similar code using local time instead of UTC:
  ///
  /// ```dart
  /// final berlinWallFell = DateTime(1989, DateTime.november, 9);
  /// final dDay = DateTime(1944, DateTime.june, 6);
  /// final difference = berlinWallFell.difference(dDay);
  /// print(difference.inDays); // 16591
  /// assert(difference.inDays == 16592);
  /// ```
  /// will fail because the difference is actually 16591 days and 23 hours, and
  /// [Duration.inDays] only returns the number of whole days.
  Duration difference(DateTime other) => value.difference(other);

  /// The number of milliseconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  ///
  /// This value is independent of the time zone.
  ///
  /// This value is at most
  /// 8,640,000,000,000,000ms (100,000,000 days) from the Unix epoch.
  /// In other words: `millisecondsSinceEpoch.abs() <= 8640000000000000`.
  int get millisecondsSinceEpoch => value.millisecondsSinceEpoch;

  /// The number of microseconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  ///
  /// This value is independent of the time zone.
  ///
  /// This value is at most
  /// 8,640,000,000,000,000,000us (100,000,000 days) from the Unix epoch.
  /// In other words: `microsecondsSinceEpoch.abs() <= 8640000000000000000`.
  ///
  /// Note that this value does not fit into 53 bits (the size of a IEEE double).
  /// A JavaScript number is not able to hold this value.
  int get microsecondsSinceEpoch => value.microsecondsSinceEpoch;

  /// The time zone name.
  ///
  /// This value is provided by the operating system and may be an
  /// abbreviation or a full name.
  ///
  /// In the browser or on Unix-like systems commonly returns abbreviations,
  /// such as "CET" or "CEST". On Windows returns the full name, for example
  /// "Pacific Standard Time".
  String get timeZoneName => value.timeZoneName;

  /// The time zone offset, which
  /// is the difference between local time and UTC.
  ///
  /// The offset is positive for time zones east of UTC.
  ///
  /// Note, that JavaScript, Python and C return the difference between UTC and
  /// local time. Java, C# and Ruby return the difference between local time and
  /// UTC.
  ///
  /// For example, using local time in San Francisco, United States:
  /// ```dart
  /// final dateUS = DateTime.parse('2021-11-01 20:18:04Z').toLocal();
  /// print(dateUS); // 2021-11-01 13:18:04.000
  /// print(dateUS.timeZoneName); // PDT ( Pacific Daylight Time )
  /// print(dateUS.timeZoneOffset.inHours); // -7
  /// print(dateUS.timeZoneOffset.inMinutes); // -420
  /// ```
  ///
  /// For example, using local time in Canberra, Australia:
  /// ```dart
  /// final dateAus = DateTime.parse('2021-11-01 20:18:04Z').toLocal();
  /// print(dateAus); // 2021-11-02 07:18:04.000
  /// print(dateAus.timeZoneName); // AEDT ( Australian Eastern Daylight Time )
  /// print(dateAus.timeZoneOffset.inHours); // 11
  /// print(dateAus.timeZoneOffset.inMinutes); // 660
  /// ```
  Duration get timeZoneOffset => value.timeZoneOffset;

  /// The year.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.year); // 1969
  /// ```
  int get year => value.year;

  /// The month `[1..12]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.month); // 7
  /// assert(moonLanding.month == DateTime.july);
  /// ```
  int get month => value.month;

  /// The day of the month `[1..31]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.day); // 20
  /// ```
  int get day => value.day;

  /// The hour of the day, expressed as in a 24-hour clock `[0..23]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.hour); // 20
  /// ```
  int get hour => value.hour;

  /// The minute `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.minute); // 18
  /// ```
  int get minute => value.minute;

  /// The second `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.second); // 4
  /// ```
  int get second => value.second;

  /// The millisecond `[0...999]`.
  ///
  /// ```dart
  /// final date = DateTime.parse('1970-01-01 05:01:01.234567Z');
  /// print(date.millisecond); // 234
  /// ```
  int get millisecond => value.microsecond;

  /// The microsecond `[0...999]`.
  ///
  /// ```dart
  /// final date = DateTime.parse('1970-01-01 05:01:01.234567Z');
  /// print(date.microsecond); // 567
  /// ```
  int get microsecond => value.microsecond;

  /// The day of the week [monday]..[sunday].
  ///
  /// In accordance with ISO 8601
  /// a week starts with Monday, which has the value 1.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.weekday); // 7
  /// assert(moonLanding.weekday == DateTime.sunday);
  /// ```
  int get weekday => value.weekday;
}

extension SignalDateTimeNullExt on Signal<DateTime?> {
  /// Returns true if [this] occurs before [other].
  ///
  /// The comparison is independent
  /// of whether the time is in UTC or in the local time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final earlier = now.subtract(const Duration(seconds: 5));
  /// print(earlier.isBefore(now)); // true
  /// print(!now.isBefore(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(earlier.isBefore(now.toUtc())); // true
  /// print(earlier.toUtc().isBefore(now)); // true
  ///
  /// print(!now.toUtc().isBefore(now)); // true
  /// print(!now.isBefore(now.toUtc())); // true
  /// ```
  bool? isBefore(DateTime other) => value?.isBefore(other);

  /// Returns true if [this] occurs after [other].
  ///
  /// The comparison is independent
  /// of whether the time is in UTC or in the local time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final later = now.add(const Duration(seconds: 5));
  /// print(later.isAfter(now)); // true
  /// print(!now.isBefore(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(later.isAfter(now.toUtc())); // true
  /// print(later.toUtc().isAfter(now)); // true
  ///
  /// print(!now.toUtc().isAfter(now)); // true
  /// print(!now.isAfter(now.toUtc())); // true
  /// ```
  bool? isAfter(DateTime other) => value?.isAfter(other);

  /// Returns true if [this] occurs at the same moment as [other].
  ///
  /// The comparison is independent of whether the time is in UTC or in the local
  /// time zone.
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final later = now.add(const Duration(seconds: 5));
  /// print(!later.isAtSameMomentAs(now)); // true
  /// print(now.isAtSameMomentAs(now)); // true
  ///
  /// // This relation stays the same, even when changing timezones.
  /// print(!later.isAtSameMomentAs(now.toUtc())); // true
  /// print(!later.toUtc().isAtSameMomentAs(now)); // true
  ///
  /// print(now.toUtc().isAtSameMomentAs(now)); // true
  /// print(now.isAtSameMomentAs(now.toUtc())); // true
  /// ```
  bool? isAtSameMomentAs(DateTime other) => value?.isAtSameMomentAs(other);

  /// Compares this DateTime Object to [other],
  /// returning zero if the values are equal.
  ///
  /// A [compareTo] function returns:
  ///  * a negative value if this DateTime [isBefore] [other].
  ///  * `0` if this DateTime [isAtSameMomentAs] [other], and
  ///  * a positive value otherwise (when this DateTime [isAfter] [other]).
  ///
  /// ```dart
  /// final now = DateTime.now();
  /// final future = now.add(const Duration(days: 2));
  /// final past = now.subtract(const Duration(days: 2));
  /// final newDate = now.toUtc();
  ///
  /// print(now.compareTo(future)); // -1
  /// print(now.compareTo(past)); // 1
  /// print(now.compareTo(newDate)); // 0
  /// ```
  int? compareTo(DateTime other) => value?.compareTo(other);

  /// Returns this DateTime value in the local time zone.
  ///
  /// Returns [this] if it is already in the local time zone.
  /// Otherwise this method is equivalent to:
  ///
  /// ```dart template:expression
  /// DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
  ///                                     isUtc: false)
  /// ```
  DateTime? toLocal() => value?.toLocal();

  /// Returns this DateTime value in the UTC time zone.
  ///
  /// Returns [this] if it is already in UTC.
  /// Otherwise this method is equivalent to:
  ///
  /// ```dart template:expression
  /// DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
  ///                                     isUtc: true)
  /// ```
  DateTime? toUtc() => value?.toUtc();

  /// Returns an ISO-8601 full-precision extended format representation.
  ///
  /// The format is `yyyy-MM-ddTHH:mm:ss.mmmuuuZ` for UTC time, and
  /// `yyyy-MM-ddTHH:mm:ss.mmmuuu` (no trailing "Z") for local/non-UTC time,
  /// where:
  ///
  /// * `yyyy` is a, possibly negative, four digit representation of the year,
  ///   if the year is in the range -9999 to 9999,
  ///   otherwise it is a signed six digit representation of the year.
  /// * `MM` is the month in the range 01 to 12,
  /// * `dd` is the day of the month in the range 01 to 31,
  /// * `HH` are hours in the range 00 to 23,
  /// * `mm` are minutes in the range 00 to 59,
  /// * `ss` are seconds in the range 00 to 59 (no leap seconds),
  /// * `mmm` are milliseconds in the range 000 to 999, and
  /// * `uuu` are microseconds in the range 001 to 999. If [microsecond] equals
  ///   0, then this part is omitted.
  ///
  /// The resulting string can be parsed back using [parse].
  /// ```dart
  /// final moonLanding = DateTime.utc(1969, 7, 20, 20, 18, 04);
  /// final isoDate = moonLanding.toIso8601String();
  /// print(isoDate); // 1969-07-20T20:18:04.000Z
  /// ```
  String? toIso8601String() => value?.toIso8601String();

  /// Returns a new [DateTime] instance with [duration] added to [this].
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysFromNow = today.add(const Duration(days: 50));
  /// ```
  ///
  /// Notice that the duration being added is actually 50 * 24 * 60 * 60
  /// seconds. If the resulting `DateTime` has a different daylight saving offset
  /// than `this`, then the result won't have the same time-of-day as `this`, and
  /// may not even hit the calendar date 50 days later.
  ///
  /// Be careful when working with dates in local time.
  DateTime? add(Duration duration) => value?.add(duration);

  /// Returns a new [DateTime] instance with [duration] subtracted from [this].
  ///
  /// ```dart
  /// final today = DateTime.now();
  /// final fiftyDaysAgo = today.subtract(const Duration(days: 50));
  /// ```
  ///
  /// Notice that the duration being subtracted is actually 50 * 24 * 60 * 60
  /// seconds. If the resulting `DateTime` has a different daylight saving offset
  /// than `this`, then the result won't have the same time-of-day as `this`, and
  /// may not even hit the calendar date 50 days earlier.
  ///
  /// Be careful when working with dates in local time.
  DateTime? subtract(Duration duration) => value?.subtract(duration);

  /// Returns a [Duration] with the difference when subtracting [other] from
  /// [this].
  ///
  /// The returned [Duration] will be negative if [other] occurs after [this].
  ///
  /// ```dart
  /// final berlinWallFell = DateTime.utc(1989, DateTime.november, 9);
  /// final dDay = DateTime.utc(1944, DateTime.june, 6);
  ///
  /// final difference = berlinWallFell.difference(dDay);
  /// print(difference.inDays); // 16592
  /// ```
  ///
  /// The difference is measured in seconds and fractions of seconds.
  /// The difference above counts the number of fractional seconds between
  /// midnight at the beginning of those dates.
  /// If the dates above had been in local time, not UTC, then the difference
  /// between two midnights may not be a multiple of 24 hours due to daylight
  /// saving differences.
  ///
  /// For example, in Australia, similar code using local time instead of UTC:
  ///
  /// ```dart
  /// final berlinWallFell = DateTime(1989, DateTime.november, 9);
  /// final dDay = DateTime(1944, DateTime.june, 6);
  /// final difference = berlinWallFell.difference(dDay);
  /// print(difference.inDays); // 16591
  /// assert(difference.inDays == 16592);
  /// ```
  /// will fail because the difference is actually 16591 days and 23 hours, and
  /// [Duration.inDays] only returns the number of whole days.
  Duration? difference(DateTime other) => value?.difference(other);

  /// The number of milliseconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  ///
  /// This value is independent of the time zone.
  ///
  /// This value is at most
  /// 8,640,000,000,000,000ms (100,000,000 days) from the Unix epoch.
  /// In other words: `millisecondsSinceEpoch.abs() <= 8640000000000000`.
  int? get millisecondsSinceEpoch => value?.millisecondsSinceEpoch;

  /// The number of microseconds since
  /// the "Unix epoch" 1970-01-01T00:00:00Z (UTC).
  ///
  /// This value is independent of the time zone.
  ///
  /// This value is at most
  /// 8,640,000,000,000,000,000us (100,000,000 days) from the Unix epoch.
  /// In other words: `microsecondsSinceEpoch.abs() <= 8640000000000000000`.
  ///
  /// Note that this value does not fit into 53 bits (the size of a IEEE double).
  /// A JavaScript number is not able to hold this value.
  int? get microsecondsSinceEpoch => value?.microsecondsSinceEpoch;

  /// The time zone name.
  ///
  /// This value is provided by the operating system and may be an
  /// abbreviation or a full name.
  ///
  /// In the browser or on Unix-like systems commonly returns abbreviations,
  /// such as "CET" or "CEST". On Windows returns the full name, for example
  /// "Pacific Standard Time".
  String? get timeZoneName => value?.timeZoneName;

  /// The time zone offset, which
  /// is the difference between local time and UTC.
  ///
  /// The offset is positive for time zones east of UTC.
  ///
  /// Note, that JavaScript, Python and C return the difference between UTC and
  /// local time. Java, C# and Ruby return the difference between local time and
  /// UTC.
  ///
  /// For example, using local time in San Francisco, United States:
  /// ```dart
  /// final dateUS = DateTime.parse('2021-11-01 20:18:04Z').toLocal();
  /// print(dateUS); // 2021-11-01 13:18:04.000
  /// print(dateUS.timeZoneName); // PDT ( Pacific Daylight Time )
  /// print(dateUS.timeZoneOffset.inHours); // -7
  /// print(dateUS.timeZoneOffset.inMinutes); // -420
  /// ```
  ///
  /// For example, using local time in Canberra, Australia:
  /// ```dart
  /// final dateAus = DateTime.parse('2021-11-01 20:18:04Z').toLocal();
  /// print(dateAus); // 2021-11-02 07:18:04.000
  /// print(dateAus.timeZoneName); // AEDT ( Australian Eastern Daylight Time )
  /// print(dateAus.timeZoneOffset.inHours); // 11
  /// print(dateAus.timeZoneOffset.inMinutes); // 660
  /// ```
  Duration? get timeZoneOffset => value?.timeZoneOffset;

  /// The year.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.year); // 1969
  /// ```
  int? get year => value?.year;

  /// The month `[1..12]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.month); // 7
  /// assert(moonLanding.month == DateTime.july);
  /// ```
  int? get month => value?.month;

  /// The day of the month `[1..31]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.day); // 20
  /// ```
  int? get day => value?.day;

  /// The hour of the day, expressed as in a 24-hour clock `[0..23]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.hour); // 20
  /// ```
  int? get hour => value?.hour;

  /// The minute `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.minute); // 18
  /// ```
  int? get minute => value?.minute;

  /// The second `[0...59]`.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.second); // 4
  /// ```
  int? get second => value?.second;

  /// The millisecond `[0...999]`.
  ///
  /// ```dart
  /// final date = DateTime.parse('1970-01-01 05:01:01.234567Z');
  /// print(date.millisecond); // 234
  /// ```
  int? get millisecond => value?.microsecond;

  /// The microsecond `[0...999]`.
  ///
  /// ```dart
  /// final date = DateTime.parse('1970-01-01 05:01:01.234567Z');
  /// print(date.microsecond); // 567
  /// ```
  int? get microsecond => value?.microsecond;

  /// The day of the week [monday]..[sunday].
  ///
  /// In accordance with ISO 8601
  /// a week starts with Monday, which has the value 1.
  ///
  /// ```dart
  /// final moonLanding = DateTime.parse('1969-07-20 20:18:04Z');
  /// print(moonLanding.weekday); // 7
  /// assert(moonLanding.weekday == DateTime.sunday);
  /// ```
  int? get weekday => value?.weekday;
}
