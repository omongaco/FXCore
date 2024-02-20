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
}
