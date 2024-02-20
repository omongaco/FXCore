//
//  File.swift
//  
//
//  Created by Ansyar Hafid on 20/02/24.
//

import Foundation

public extension Date {
    /// Returns a string representation of the date in the specified format.
    func formattedString(usingFormat format: String.DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.value
        return dateFormatter.string(from: self)
    }
    
    /// Calculates the difference in years from the date to the current date.
    func yearsFromNow() -> Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
    
    /// Adds a specified number of days to the date.
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    /// Returns the start of the day for the date.
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Checks if the date is in today.
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Checks if the date is in tomorrow.
    func isTomorrow() -> Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Returns the age based on the date.
    func age() -> Int {
        let now = Date()
        let birthday: Date = self
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        return ageComponents.year!
    }
    
    /// Converts the date to a local time zone from UTC.
    func toLocalTime() -> Date {
        let tz = TimeZone.current
        let seconds = tz.secondsFromGMT(for: self)
        return self.addingTimeInterval(Double(seconds))
    }
    
    /// Converts the date from local time zone to UTC.
    func toUTC() -> Date {
        let tz = TimeZone.current
        let seconds = -tz.secondsFromGMT(for: self)
        return self.addingTimeInterval(Double(seconds))
    }
    
    func toEpochTime() -> Int {
        return Int(self.timeIntervalSince1970)
    }
    
    /// Initializes a `Date` object from a Unix timestamp.
    init(epochTime: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(epochTime))
    }
    
    /// Checks if the date falls on a weekend.
    func isWeekend() -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInWeekend(self)
    }
    
    /// Returns the end of the day for the date.
    func endOfDay() -> Date {
        let startOfDay = self.startOfDay()
        let components = DateComponents(day: 1, second: -1)
        let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay)!
        return endOfDay
    }
    
    /// Returns the difference in months from the date to the current date.
    func monthsFromNow() -> Int {
        return Calendar.current.dateComponents([.month], from: self, to: Date()).month ?? 0
    }
    
    /// Returns the difference in days from the date to the current date.
    func daysFromNow() -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }
    
    /// Returns a new Date by adding months to the current date.
    func addingMonths(_ months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }
    
    /// Returns a new Date by subtracting months from the current date.
    func subtractingMonths(_ months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: -months, to: self) ?? self
    }
    
    /// Returns a boolean indicating whether the date is in the past.
    func isInPast() -> Bool {
        return self < Date()
    }
    
    /// Returns a boolean indicating whether the date is in the future.
    func isInFuture() -> Bool {
        return self > Date()
    }
}
