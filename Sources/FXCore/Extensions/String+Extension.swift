//
//  File.swift
//  
//
//  Created by Ansyar Hafid on 07/02/24.
//

import Foundation

public extension String {
    static let emptyString = ""
    static let whitespace = " "
    
    var boolValue: Bool? {
        switch self.lowercased() {
        case "1", "true", "yes":
            return true
        case "0", "false", "no":
            return false
        default: 
            return nil
        }
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func localize() -> String {
        return LanguageManager.shared.getI18nStringValue(of: self)
    }
    
    func localize(in language: Languages) -> String {
        return LanguageManager.shared.getI18nStringValue(of: self, in: language)
    }
    
    func localize(with variables: [String:String]) -> String {
        return LanguageManager.shared.getI18nStringValue(of: self, with: variables)
    }
    
    func getIndex(from: Int) -> Index {
        if from < count {
            return self.index(startIndex, offsetBy: from)
        } else {
            return self.index(startIndex, offsetBy: count)
        }
    }
    
    func substring(from index: Int) -> String {
        let fromIndex = getIndex(from: index)
        return String(self[fromIndex...])
    }
    
    func substring(to index: Int) -> String {
        let toIndex = getIndex(from: index)
        return String(self[..<toIndex])
    }
    
    func substring(with range: Range<Int>) -> String {
        let startIndex = getIndex(from: range.lowerBound)
        let endIndex = getIndex(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    static func from(json: Any) -> String {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: [])
            return String(data: data1, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    var length: Int {
        return count
    }
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    static func separatorStringArrayToString(stringArray: [String]) -> String {
        let filterStringArr = stringArray.filter({ $0.isNotEmpty })
        return filterStringArr.joined(separator: "\n")
    }
    
    // MARK: HTML to attributed strings
    var html2AttributedString: NSAttributedString? {
        guard let tempData = data(using: .utf8, allowLossyConversion: true) else { return nil }
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html,
                                                                               .characterEncoding: String.Encoding.utf8.rawValue]
            return try NSAttributedString(data: tempData,
                                          options: options,
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    // MARK: Attributed strings to HTML
    func attributedStringFromHTML(completionBlock: @escaping (NSAttributedString?) -> Void) {
        guard let data = data(using: .utf8, allowLossyConversion: true) else {
            return completionBlock(nil)
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html,
                                                                           .characterEncoding: String.Encoding.utf8.rawValue]
        
        DispatchQueue.main.async {
            if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                completionBlock(attributedString)
            } else {
                completionBlock(nil)
            }
        }
    }
    
    // MARK: Add Characters at Index
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at: self.index(self.startIndex, offsetBy: ind))
    }
    
    // MARK: Add Characters at Index
    mutating func separateWithPattern(every pattern: [Int] = [4]) {
        var joinedString: String = ""
        let enumeratedChar = self.removeWhitespace().enumerated()
        for (number, characters) in enumeratedChar {
            if pattern.contains(number) {
                joinedString += " "
                joinedString += String(characters)
            } else {
                joinedString += String(characters)
            }
        }
        self = joinedString
    }
}

public extension String {
    func maxLengthWithDot(name: String, length: Int) -> String {
        if name.length > length {
            return String(name.prefix(length) + "...")
        } else {
            return name
        }
    }
}

public extension String {
    func string(byStrippingCharactersOtherThan characters: CharacterSet) -> String {
        return String(String.UnicodeScalarView(unicodeScalars.filter { characters.contains($0) }))
    }
    
    func sanitizedProxyID(maxChars: Int = 13) -> String {
        var sanitizedProxyID = string(byStrippingCharactersOtherThan: CharacterSet.decimalDigits)
        if sanitizedProxyID.length > maxChars {
            let maxIndex = sanitizedProxyID.index(sanitizedProxyID.startIndex, offsetBy: maxChars)
            sanitizedProxyID = String(sanitizedProxyID[..<maxIndex])
        }
        
        return sanitizedProxyID
    }
}

public extension String {
    var amountFormat: String {
        let amountFormatter = Formatter.amountFormatter
        amountFormatter.minimumFractionDigits = 2
        amountFormatter.maximumFractionDigits = 2
        if let value = amountFormatter.number(from: self) {
            return amountFormatter.string(from: value) ?? ""
        }
        return ""
    }
    
    var amountUnitFormat: String {
        let amountFormatter = Formatter.amountFormatter
        amountFormatter.minimumFractionDigits = 4
        amountFormatter.maximumFractionDigits = 4
        let amountWithNoGroupingSeparator = self.replacingOccurrences(of: amountFormatter.groupingSeparator, with: "")
        if amountFormatter.number(from: amountWithNoGroupingSeparator) != nil {
            let value = NSDecimalNumber(string: amountWithNoGroupingSeparator)
            return amountFormatter.string(for: value) ?? ""
        }
        return ""
    }
    
    var amountDouble: Double? {
        let amountFormatter = Formatter.amountFormatter
        amountFormatter.minimumFractionDigits = .zero
        amountFormatter.maximumFractionDigits = .zero
        let number = amountFormatter.number(from: self)
        return number?.doubleValue
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    func editingFormatted(maxDecimalsCount: Int) -> String {
        
        let amountFormatter = Formatter.amountFormatter
        let items = components(separatedBy: amountFormatter.decimalSeparator)
        
        guard items.count <= maxDecimalsCount else {
            return ""
        }
        
        var decimalDigitsCount: Int = .zero
        if items.count == 2 {
            decimalDigitsCount = items[1].count
            amountFormatter.alwaysShowsDecimalSeparator = true
            if decimalDigitsCount > maxDecimalsCount {
                return ""
            }
        } else {
            amountFormatter.alwaysShowsDecimalSeparator = false
        }
        
        let amountWithNoGroupingSeparator = self.replacingOccurrences(of: amountFormatter.groupingSeparator, with: "")
        let amountFigure = items[0].replacingOccurrences(of: amountFormatter.groupingSeparator, with: "").length
        if (maxDecimalsCount == 2 && amountFigure > 13) || (maxDecimalsCount > 2 && amountFigure > 12) {
            return ""
        }
        amountFormatter.minimumFractionDigits = decimalDigitsCount
        amountFormatter.maximumFractionDigits = decimalDigitsCount
        if amountFormatter.number(from: amountWithNoGroupingSeparator) != nil {
            let value = NSDecimalNumber(string: amountWithNoGroupingSeparator)
            return amountFormatter.string(for: value) ?? ""
        }
        return ""
    }
    
    func editingFormatted(maxDecimalsCount: Int, maxDigits: Int) -> String {
        
        let amountFormatter = Formatter.amountFormatter
        let items = components(separatedBy: amountFormatter.decimalSeparator)
        guard items.count <= maxDecimalsCount else {
            return ""
        }
        var decimalDigitsCount: Int = .zero
        if items.count == 2 {
            decimalDigitsCount = items[1].count
            amountFormatter.alwaysShowsDecimalSeparator = true
            if decimalDigitsCount > maxDecimalsCount {
                return ""
            }
        } else {
            amountFormatter.alwaysShowsDecimalSeparator = false
        }
        
        let amountWithNoGroupingSeparator = self.replacingOccurrences(of: amountFormatter.groupingSeparator, with: "")
        let amountFigure = items[0].replacingOccurrences(of: amountFormatter.groupingSeparator, with: "").length
        if (maxDecimalsCount == 2 && amountFigure > maxDigits) || (maxDecimalsCount > 2 && amountFigure > (maxDigits - 1)) {
            return ""
        }
        amountFormatter.minimumFractionDigits = decimalDigitsCount
        amountFormatter.maximumFractionDigits = decimalDigitsCount
        if amountFormatter.number(from: amountWithNoGroupingSeparator) != nil {
            let value = NSDecimalNumber(string: amountWithNoGroupingSeparator)
            return amountFormatter.string(for: value) ?? ""
        }
        return ""
    }
}

public extension String {
    var plusString: String {
        guard let convertToDouble = Double(self) else {
            return self.amountFormat
        }
        if convertToDouble > 0.00 {
            return "+\(self.amountFormat)"
        }
        return self.amountFormat
    }
    
    var minusString: String {
        guard let convertToDouble = Double(self) else {
            return self.amountFormat
        }
        if convertToDouble > 0.00 {
            return "-\(self.amountFormat)"
        }
        return self.amountFormat
    }
}

public extension String {
    func isValidUsing(regex: String) -> Bool {
        //Validating message
        let messagePattern = regex
        let containSpecialCharacters = self.range(of: messagePattern, options: .regularExpression) != nil
        return self == "" || containSpecialCharacters
    }
    
    var trimmedString: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var isBackspace: Bool {
        var backspaceSet = CharacterSet()
        backspaceSet.insert(charactersIn: "\\b")
        if self.rangeOfCharacter(from: backspaceSet.inverted) == nil {
            return true
        }
        return false
    }
    
    /*
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     - Parameter length: Desired maximum lengths of a string
     - Parameter trailing: A 'String' that will be appended after the truncation.
     - Returns: 'String' object.
     https://gist.github.com/budidino/8585eecd55fd4284afaaef762450f98e
     */
    func trunc(length: Int, trailing: String = "") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    func removeMinusString() -> String {
        return self.replace(string: "-", replacement: "")
    }
    
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
    
    func removeBracket() -> String {
        return self.replace(string: "(", replacement: "").replace(string: ")", replacement: "")
    }
}

// MARK: Encoded JSON decimal cleaner
public extension String {
    func getDecimalValue(decimalPlaces: Int) -> Decimal {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        numberFormatter.groupingSeparator = String.emptyString
        numberFormatter.maximumFractionDigits = decimalPlaces
        numberFormatter.minimumFractionDigits = decimalPlaces
        if let numberValue = numberFormatter.number(from: self) {
            return numberValue.decimalValue
        } else {
            return .zero
        }
    }
    
    func isEmptyOrWhiteSpace() -> Bool {
        if self.isEmpty {
            return true
        }
        return (self.trimmingCharacters(in: .whitespaces) == .emptyString)
    }
    
    enum DateFormat: String {
        case dateshortyear
        case dateshortday
        case datetime
        case datemedium
        case datefull
        case time24hrs
        case time12hrs
        case timesecond24hrs
        case timesecond12hrs
        
        var value: String {
            switch self {
            case .dateshortyear:
                return "yyyy-MM-dd"
            case .dateshortday:
                return "dd-MM-yyyy"
            case .datetime:
                return "yyyy-MM-dd HH:mm:ss"
            case .datemedium:
                return "MMM d, yyyy"
            case .datefull:
                return "EEEE, MMM d, yyyy"
            case .time24hrs:
                return "HH:mm"
            case .time12hrs:
                return "hh:mm a"
            case .timesecond24hrs:
                return "HH:mm:ss"
            case .timesecond12hrs:
                return "hh:mm:ss a"
            }
        }
    }
    
    /// Converts a string to a `Date` using the specified format.
    func toDate(withFormat format: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
    
    /// Attempts to convert the string to an `Int`.
    func toInt() -> Int? {
        return Int(self)
    }
    
    /// Checks if the string is a valid email address.
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// Trims whitespace and newlines from the string.
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Encodes the string for URL query parameters.
    var urlEncoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// Decodes HTML entities in the string.
    var htmlDecoded: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let decodedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil).string
        return decodedString ?? self
    }
    
    /// Reverses the string.
    var reversed: String {
        return String(self.reversed())
    }
    
    /// Checks if the string contains only digits.
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
