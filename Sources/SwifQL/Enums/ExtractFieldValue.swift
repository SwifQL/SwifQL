//
//  ExtractFieldValue.swift
//  SwifQL
//
//  Created by Mihael Isaev on 29/10/2019.
//

public enum ExtractFieldValue: String {
    /// Postgres specific
    /// for TIMESTAMP: The century
    /// for Interval: The number of centuries
    case century = "CENTURY"
    
    /// Universal
    /// for TIMESTAMP: The day of the month (1-31)
    /// for Interval: The number of days
    case day = "DAY"
    
    /// Postgres specific
    /// for TIMESTAMP: The decade that is the year divided by 10
    /// for Interval: Sames as TIMESTAMP
    case decade = "DECADE"
    
    /// Postgres specific
    /// for TIMESTAMP: The day of week Sunday (0) to Saturday (6)
    /// for Interval: N/A
    case dow = "DOW"
    
    /// Postgres specific
    /// for TIMESTAMP: The day of year that ranges from 1 to 366
    /// for Interval: N/A
    case doy = "DOY"
    
    /// Postgres specific
    /// for TIMESTAMP: The number of seconds since 1970-01-01 00:00:00 UTC
    /// for Interval: The total number of seconds in the interval
    case epoch = "EPOCH"
    
    /// Universal
    /// for TIMESTAMP: The hour (0-23)
    /// for Interval: The number of hours
    case hour = "HOUR"
    
    /// Postgres specific
    /// for TIMESTAMP: Day of week based on ISO 8601 Monday (1) to Saturday (7)
    /// for Interval: N/A
    case isoDow = "ISODOW"
    
    /// Postgres specific
    /// for TIMESTAMP: ISO 8601 week number of year
    /// for Interval: N/A
    case isoYear = "ISOYEAR"
    
    /// Postgres specific
    /// for TIMESTAMP: The seconds field, including fractional parts, multiplied by 1000000
    /// for Interval: Sames as TIMESTAMP
    case microseconds = "MICROSECONDS"
    
    /// Postgres specific
    /// for TIMESTAMP: The millennium
    /// for Interval: The number of millennium
    case millenium = "MILLENNIUM"
    
    /// Postgres specific
    /// for TIMESTAMP: The seconds field, including fractional parts, multiplied by 1000
    /// for Interval: Sames as TIMESTAMP
    case milliseconds = "MILLISECONDS"
    
    /// Universal
    /// for TIMESTAMP: The minute (0-59)
    /// for Interval: The number of minutes
    case minute = "MINUTE"
    
    /// Universal
    /// for TIMESTAMP: Month, 1-12
    /// for Interval: The number of months, modulo (0-11)
    case month = "MONTH"
    
    /// Universal
    /// for TIMESTAMP: Quarter of the year
    /// for Interval: The number of quarters
    case quarter = "QUARTER"
    
    /// Universal
    /// for TIMESTAMP: The second
    /// for Interval: The number of seconds
    case second = "SECOND"
    
    /// Postgres specific
    /// for TIMESTAMP: The timezone offset from UTC, measured in seconds
    /// for Interval: N/A
    case timeZone = "TIMEZONE"
    
    /// Postgres specific
    /// for TIMESTAMP: The hour component of the time zone offset
    /// for Interval: N/A
    case timeZoneHour = "TIMEZONE_HOUR"
    
    /// Postgres specific
    /// for TIMESTAMP: The minute component of the time zone offset
    /// for Interval: N/A
    case timeZoneMinute = "TIMEZONE_MINUTE"
    
    /// Universal
    /// for TIMESTAMP: The number of the ISO 8601 week-numbering week of the year
    /// for Interval: N/A
    case week = "WEEK"
    
    /// Universal
    /// for TIMESTAMP: The year
    /// for Interval: Sames as TIMESTAMP
    case year = "YEAR"
    
    /// MySQL specific
    case microsecond = "MICROSECOND"
    
    /// MySQL specific
    case secondMicrosecond = "SECOND_MICROSECOND"
    
    /// MySQL specific
    case minuteMicrosecond = "MINUTE_MICROSECOND"
    
    /// MySQL specific
    case minuteSecond = "MINUTE_SECOND"
    
    /// MySQL specific
    case hourMicrosecond = "HOUR_MICROSECOND"
    
    /// MySQL specific
    case hourSecond = "HOUR_SECOND"
    
    /// MySQL specific
    case hourMinute = "HOUR_MINUTE"
    
    /// MySQL specific
    case dayMicrosecond = "DAY_MICROSECOND"
    
    /// MySQL specific
    case daySecond = "DAY_SECOND"
    
    /// MySQL specific
    case dayMinute = "DAY_MINUTE"
    
    /// MySQL specific
    case dayHour = "DAY_HOUR"
    
    /// MySQL specific
    case yearMonth = "YEAR_MONTH"
}
