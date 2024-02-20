//
//  Language.swift
//
//
//  Created by Ansyar Hafid on 07/02/24.
//

import Foundation

public enum Languages: String {
    case en
    case es
    public var value: String {
        switch self {
        case .en: 
            return "en-US"
        default: 
            return "es-ES"
        }
    }
}

public struct LanguagePack: Codable {
    public let content: Content?
    public let languagePackId: String?
}

public struct Content: Codable {
    public let en, es: [String: String]
}

public struct LanguagePackLastModified: Codable {
    public let lastModified: String
}

public protocol XIBLocalizable {
    var xibLocalizedKey: String? { get set }
}
