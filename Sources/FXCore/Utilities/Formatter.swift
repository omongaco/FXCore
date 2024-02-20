//
//  File.swift
//  
//
//  Created by Ansyar Hafid on 07/02/24.
//

import Foundation

public class Formatter {
    public static var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = .zero
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: AppConstant.LocaleIdentifier.en.rawValue)
        return formatter
    }()
}
