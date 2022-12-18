//
//  DateExtensions.swift
//  starwarsTestApp
//
//  Created by Rui Cardoso on 07/12/2022.
//

import Foundation

extension Date {

    public struct DateConstants {

        public static let hoursInDay = 24

        public static let utcCalendar: Calendar = {

            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "UTC")!
            return calendar
        }()
    }

    public func isBetween(beginDate: Date, endDate: Date) -> Bool {

        return self >= beginDate && self <= endDate
    }

    public func isSameDay(with date: Date, calendar: Calendar = Calendar.current) -> Bool {

        let day1 = calendar.component(.day, from: self)
        let weekDay1 = calendar.component(.weekday, from: self)
        let month1 = calendar.component(.month, from: self)
        let year1 = calendar.component(.year, from: self)

        let day2 = calendar.component(.day, from: date)
        let weekDay2 = calendar.component(.weekday, from: date)
        let month2 = calendar.component(.month, from: date)
        let year2 = calendar.component(.year, from: date)

        let isSameDay = day1 == day2  && weekDay1 == weekDay2 && month1 == month2 && year1 == year2

        return isSameDay
    }

    public static func daysBetweenDates(startDate: Date, endDate: Date, calendar: Calendar = Calendar.current) -> Int {

        return calendar.dateComponents([.day], from: startDate, to: endDate).day!
    }

    public func isWeekend(calendar: Calendar = Calendar.current) -> Bool {

        return calendar.isDateInWeekend(self)
    }

    public func gregorianNextWorkDayDate(calendar: Calendar = Calendar.current) -> Date {

        if isWeekend(calendar: calendar) {

            let weekDay = GregorianWeekDay(rawValue: calendar.component(.weekday, from: self))!
            let daysToSum: Int

            if weekDay == .saturday {

                daysToSum = 2

            } else {

                daysToSum = 1
            }

            return calendar.date(byAdding: .day, value: daysToSum, to: self)!

        } else {

            return self
        }
    }

    public static func sumWorkDays(toDate date: Date, withHours hours: Int, calendar: Calendar = Calendar.current) -> Date {

        var date = date
        var hours = hours

        while hours > 0 {

            if hours >= DateConstants.hoursInDay {

                date = calendar.date(byAdding: .day, value: 1, to: date)!
                date = date.gregorianNextWorkDayDate()
                hours -= DateConstants.hoursInDay

            } else {

                date = calendar.date(byAdding: .hour, value: hours, to: date)!
                date = date.gregorianNextWorkDayDate()
                hours -= hours
            }
        }

        return date
    }

    public init(day: Int, month: Int, year: Int, for calendar: Calendar = Calendar.current) {

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        let timeZone = TimeZone(secondsFromGMT: 0)
        dateComponents.timeZone = timeZone

        self = calendar.date(from: dateComponents)!
    }

}

public enum GregorianWeekDay: Int {

    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thrusday
    case friday
    case saturday
}
