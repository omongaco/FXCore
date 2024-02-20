//
//  Int+Extension.swift
//  Corebase
//
//  Created by Ansyar Hafid on 03/02/24.
//

import Foundation

public extension Int {
    static let one = 1
    static let two = 2
    static let three = 3
    static let four = 4
    static let five = 5
    static let six = 6
    static let seven = 7
    static let eight = 8
    static let nine = 9
    static let ten = 10
    static let sixteen = 16
    static let twentyfour = 24
    static let thirtytwo = 32
    static let fourtyeight = 48
    static let fiftysix = 56

    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }

    func toDouble() -> Double {
        return Double(self)
    }
    
    /// Converts an integer (epoch time) to a `Date` object.
    var toDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }

    /// Formats the integer as a localized string with commas (or appropriate local separators).
    var formattedWithCommas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    /// Converts the integer from bytes to megabytes.
    var toMegabytes: Double {
        return Double(self) / 1_024 / 1_024
    }

    /// Checks if the integer is even.
    var isEven: Bool {
        return self % 2 == 0
    }

    /// Checks if the integer is odd.
    var isOdd: Bool {
        return self % 2 != 0
    }

    /// Converts the integer to a string with a specified radix (base).
    /// Useful for converting numbers to binary, hexadecimal, etc.
    func toString(radix: Int) -> String {
        return String(self, radix: radix)
    }

    /// Returns a string with the integer spelled out.
    /// E.g., 1 becomes "one".
    var spelledOut: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
