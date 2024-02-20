//
//  LanguageManager.swift
//  
//
//  Created by Ansyar Hafid on 07/02/24.
//

import Foundation
import Combine
import Localize_Swift

protocol LanguageManagerProtocol {
    func initiateLanguagePack()
    func getDeviceLanguage() -> String
    func getCurrentStoreLanguage() -> String
    func setResourceStore(with languageModel: LanguagePack)
    func fetchJsonFromBundle() -> LanguagePack?
    func setStoreLanguage(language: Languages)
    func setLanguagePackId(id: String)
    func getLanguagePackId() -> String
    func compareLastModifiedDates(initialDate: String, latestDate: String, dateFormat: String) -> Bool
    func getI18nStringValue(of i18nKey: String) -> String
}

public class LanguageManager: LanguageManagerProtocol {
    
    public struct Constants {
        static let jsonFileName = "LanguagePack"
        static let jsonExtension = "json"
        static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.'SSSZZZZZ"
        static let bundleErrorMessage = "Failed to fetch language pack JSON from bundle."
    }
    
    var languagePackId: String = ""
    
    public static let shared: LanguageManager = {
        var manager = LanguageManager()
        manager.setup()
        return manager
    }()
    
    // MARK: - Private methods
    
    private init() {}
    
    private func setup() {
        if let selectedLanguage = SettingContext.shared.selectedLanguage {
            Localize.setCurrentLanguage(selectedLanguage)
        } else {
            Localize.setCurrentLanguage(Languages.en.rawValue)
        }
    }
    
    private func transformDictionary(dictionary: [String: Any]) -> [String: Any] {
        var transformedDictionary = [String: Any]()
        var translations = [String: Any]()
        
        for (lang, str) in dictionary {
            translations["translation"] = str as? [String: String]
            transformedDictionary[lang] = translations
        }
        
        return transformedDictionary
    }
    
    // MARK: - Exposed methods
    public func initiateLanguagePack() {
        if let storedLanguagePack = fetchJsonFromBundle() {
            self.setLanguagePackId(id: storedLanguagePack.languagePackId ?? "")
            self.setResourceStore(with: storedLanguagePack)
        }
    }
    
    public func getDeviceLanguage() -> String {
        let locale = Locale.current
        guard let deviceLanguage = locale.languageCode else { return "" }
        return deviceLanguage
    }
    
    public func setResourceStore(with languageModel: LanguagePack) {
        guard let dictionary = languageModel.dictionary else { return }
        guard let contentDictionary = dictionary["content"] as? [String: Any] else { return }
        let transformedContentDictionary = transformDictionary(dictionary: contentDictionary)
        
        // Store language pack back to file if there is an update to it
        if self.languagePackId != languageModel.languagePackId {
            self.setLanguagePackId(id: languageModel.languagePackId ?? "")
            writeLanguagePackToCache(newLanguagePack: languageModel)
        }
    }
    
    private func getBundleJsonFileUrl() -> URL? {
        return Bundle(for: LanguageManager.self).url(forResource: Constants.jsonFileName,
        withExtension: Constants.jsonExtension)
    }
    
    private func writeToBundleJsonFile(languagePack: LanguagePack) {
        if let fileUrl = self.getBundleJsonFileUrl() {
            let languageJsonEncoded = try? JSONEncoder().encode(languagePack)
            try? languageJsonEncoded?.write(to: fileUrl)
        }
    }
    
    public func fetchJsonFromBundle() -> LanguagePack? {
        if let fileUrl = self.getBundleJsonFileUrl() {
            do {
                let data = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let json = try decoder.decode(LanguagePack.self, from: data)
                return json
            } catch let jsonError {
                print("JsonError: ", jsonError)
            }
        }
        return nil
    }
    
    public func fetchLanguagePackFromCache() -> LanguagePack? {
        guard let cachedLanguagePackData = SettingContext.shared.languagePackCache,
           let cachedLanguagePack = try? JSONDecoder().decode(LanguagePack.self, from: cachedLanguagePackData)
        else { return nil }
        return cachedLanguagePack
    }
    
    private func writeLanguagePackToCache(newLanguagePack: LanguagePack) {
        let data = try? JSONEncoder().encode(newLanguagePack)
        SettingContext.shared.languagePackCache = data
    }
    
    public func getCurrentStoreLanguage() -> String {
        return Localize.currentLanguage()
    }
    
    public func setStoreLanguage(language: Languages) {
        Localize.setCurrentLanguage(language.rawValue)
        SettingContext.shared.selectedLanguage = language.rawValue
    }

    public func setLanguagePackId(id: String) {
        self.languagePackId = id
    }

    public func getLanguagePackId() -> String {
        return self.languagePackId
    }

    public func compareLastModifiedDates(initialDate: String,
                                         latestDate: String,
                                         dateFormat: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        guard let initialDateObject = dateFormatter.date(from: initialDate) else {
            return true
        }
        
        guard let latestDateObject = dateFormatter.date(from: latestDate) else {
            return true
        }
        
        return latestDateObject > initialDateObject
    }
    
    public func getI18nStringValue(of i18nKey: String) -> String {
        return i18nKey.localized()
    }
    
    public func getI18nStringValue(of i18nKey: String, in language: Languages) -> String {
        Localize.setCurrentLanguage(language.rawValue)
        return i18nKey.localized()
    }
    
    public func getI18nStringValue(of i18nKey: String, with variables: [String:String]) -> String {
        return String(format: i18nKey.localize(), arguments: variables.values.map { $0 })
    }
}
