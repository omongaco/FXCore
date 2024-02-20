//
//  File.swift
//  
//
//  Created by Ansyar Hafid on 07/02/24.
//

import Foundation

public extension String {
    public static let emptyString = ""
    public static let whitespace = " "
    
    public var boolValue: Bool? {
        switch self.lowercased() {
        case "1", "true", "yes":
            return true
        case "0", "false", "no":
            return false
        default: 
            return nil
        }
    }
    
    public var isNotEmpty: Bool {
        return !isEmpty
    }
    
    public func localize() -> String {
        return LanguageManager.shared.getI18nStringValue(of: self)
    }
    
    public func localize(in language: Languages) -> String {
        return LanguageManager.shared.getI18nStringValue(of: self, in: language)
    }
    
    public func localize(with variables: [String:String]) -> String {
        return LanguageManager.shared.getI18nStringValue(of: self, with: variables)
    }
    
    public func getIndex(from: Int) -> Index {
        if from < count {
            return self.index(startIndex, offsetBy: from)
        } else {
            return self.index(startIndex, offsetBy: count)
        }
    }
    
    public func substring(from index: Int) -> String {
        let fromIndex = getIndex(from: index)
        return String(self[fromIndex...])
    }
    
    public func substring(to index: Int) -> String {
        let toIndex = getIndex(from: index)
        return String(self[..<toIndex])
    }
    
    public func substring(with range: Range<Int>) -> String {
        let startIndex = getIndex(from: range.lowerBound)
        let endIndex = getIndex(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    public static func from(json: Any) -> String {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: [])
            return String(data: data1, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    public var length: Int {
        return count
    }
    
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    public var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    public static func separatorStringArrayToString(stringArray: [String]) -> String {
        let filterStringArr = stringArray.filter({ $0.isNotEmpty })
        return filterStringArr.joined(separator: "\n")
    }
    
    // MARK: HTML to attributed strings
    public var html2AttributedString: NSAttributedString? {
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
    public func attributedStringFromHTML(completionBlock: @escaping (NSAttributedString?) -> Void) {
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
    public mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at: self.index(self.startIndex, offsetBy: ind))
    }
    
    // MARK: Add Characters at Index
    public mutating func separateWithPattern(every pattern: [Int] = [4]) {
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
    public func maxLengthWithDot(name: String, length: Int) -> String {
        if name.length > length {
            return String(name.prefix(length) + "...")
        } else {
            return name
        }
    }
}

public extension String {
    public func string(byStrippingCharactersOtherThan characters: CharacterSet) -> String {
        return String(String.UnicodeScalarView(unicodeScalars.filter { characters.contains($0) }))
    }
    
    public func sanitizedProxyID(maxChars: Int = 13) -> String {
        var sanitizedProxyID = string(byStrippingCharactersOtherThan: CharacterSet.decimalDigits)
        if sanitizedProxyID.length > maxChars {
            let maxIndex = sanitizedProxyID.index(sanitizedProxyID.startIndex, offsetBy: maxChars)
            sanitizedProxyID = String(sanitizedProxyID[..<maxIndex])
        }
        
        return sanitizedProxyID
    }
}

public extension String {
    public var amountFormat: String {
        let amountFormatter = Formatter.amountFormatter
        amountFormatter.minimumFractionDigits = 2
        amountFormatter.maximumFractionDigits = 2
        if let value = amountFormatter.number(from: self) {
            return amountFormatter.string(from: value) ?? ""
        }
        return ""
    }
    
    public var amountUnitFormat: String {
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
    
    public var amountDouble: Double? {
        let amountFormatter = Formatter.amountFormatter
        amountFormatter.minimumFractionDigits = .zero
        amountFormatter.maximumFractionDigits = .zero
        let number = amountFormatter.number(from: self)
        return number?.doubleValue
    }
    
    public var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    public func editingFormatted(maxDecimalsCount: Int) -> String {
        
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
    
    public func editingFormatted(maxDecimalsCount: Int, maxDigits: Int) -> String {
        
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
    public var plusString: String {
        guard let convertToDouble = Double(self) else {
            return self.amountFormat
        }
        if convertToDouble > 0.00 {
            return "+\(self.amountFormat)"
        }
        return self.amountFormat
    }
    
    public var minusString: String {
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
    public func isValidUsing(regex: String) -> Bool {
        //Validating message
        let messagePattern = regex
        let containSpecialCharacters = self.range(of: messagePattern, options: .regularExpression) != nil
        return self == "" || containSpecialCharacters
    }
    
    public var trimmedString: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    public var isBackspace: Bool {
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
    public func trunc(length: Int, trailing: String = "") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    public func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
    
    public func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    public func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    public func removeMinusString() -> String {
        return self.replace(string: "-", replacement: "")
    }
    
    public func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
    
    public func removeBracket() -> String {
        return self.replace(string: "(", replacement: "").replace(string: ")", replacement: "")
    }
}

// MARK: Encoded JSON decimal cleaner
public extension String {
    public func getDecimalValue(decimalPlaces: Int) -> Decimal {
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
    
    public func isEmptyOrWhiteSpace() -> Bool {
        if self.isEmpty {
            return true
        }
        return (self.trimmingCharacters(in: .whitespaces) == .emptyString)
    }
}
