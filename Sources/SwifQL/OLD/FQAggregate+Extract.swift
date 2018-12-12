//import Foundation
//
//extension FQAggregate {
//    public enum ExtractType: String, Codable {
//        case timestamp = "", interval
//    }
//    /// https://www.postgresql.org/docs/current/static/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT
//    public enum ExtractField: String, Codable {
//        /// The century
//        /// The first century starts at 0001-01-01 00:00:00 AD, although they did not know it at the time.
//        /// This definition applies to all Gregorian calendar countries.
//        /// There is no century number 0, you go from -1 century to 1 century.
//        /// If you disagree with this, please write your complaint to: Pope, Cathedral Saint-Peter of Roma, Vatican.
//        case century
//        /// For timestamp values, the day (of the month) field (1 - 31) ; for interval values, the number of days
//        case day
//        /// The year field divided by 10
//        case decade
//        /// The day of the week as Sunday (0) to Saturday (6)
//        case dow
//        /// The day of the year (1 - 365/366)
//        case doy
//        /// For timestamp with time zone values, the number of seconds since 1970-01-01 00:00:00 UTC (can be negative);
//        /// for date and timestamp values, the number of seconds since 1970-01-01 00:00:00 local time;
//        /// for interval values, the total number of seconds in the interval
//        case epoch
//        /// The hour field (0 - 23)
//        case hour
//        /// The day of the week as Monday (1) to Sunday (7)
//        /// This is identical to dow except for Sunday. This matches the ISO 8601 day of the week numbering.
//        case isodow
//        /// The ISO 8601 week-numbering year that the date falls in (not applicable to intervals)
//        /// Each ISO 8601 week-numbering year begins with the Monday of the week
//        /// containing the 4th of January, so in early January or late December
//        /// the ISO year may be different from the Gregorian year.
//        /// See the week field for more information.
//        case isoyear
//        /// The seconds field, including fractional parts, multiplied by 1 000 000; note that this includes full seconds
//        case microseconds
//        /// The millennium
//        /// Years in the 1900s are in the second millennium. The third millennium started January 1, 2001.
//        case millennium
//        /// The seconds field, including fractional parts, multiplied by 1000. Note that this includes full seconds.
//        case milliseconds
//        /// The minutes field (0 - 59)
//        case minute
//        /// For timestamp values, the number of the month within the year (1 - 12) ; for interval values, the number of months, modulo 12 (0 - 11)
//        case month
//        /// The quarter of the year (1 - 4) that the date is in
//        case quarter
//        /// The seconds field, including fractional parts (0 - 59)
//        case second
//        /// The time zone offset from UTC, measured in seconds.
//        /// Positive values correspond to time zones east of UTC, negative values to zones west of UTC.
//        /// (Technically, PostgreSQL does not use UTC because leap seconds are not handled.)
//        case timezone
//        /// The hour component of the time zone offset
//        case timezone_hour
//        /// The minute component of the time zone offset
//        case timezone_minute
//        /// The number of the ISO 8601 week-numbering week of the year.
//        /// By definition, ISO weeks start on Mondays and the first week of a year contains January 4 of that year.
//        /// In other words, the first Thursday of a year is in week 1 of that year.
//        /// In the ISO week-numbering system, it is possible for early-January dates
//        /// to be part of the 52nd or 53rd week of the previous year, and for late-December
//        /// dates to be part of the first week of the next year.
//        /// For example, 2005-01-01 is part of the 53rd week of year 2004,
//        /// and 2006-01-01 is part of the 52nd week of year 2005,
//        /// while 2012-12-31 is part of the first week of 2013.
//        /// It's recommended to use the isoyear field together with week to get consistent results.
//        case week
//        /// The year field. Keep in mind there is no 0 AD, so subtracting BC years from AD years should be done with care.
//        case year
//    }
//}
