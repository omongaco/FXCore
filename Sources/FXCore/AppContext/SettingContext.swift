//
//  SettingContext.swift
//  Corebase
//
//  Created by Ansyar Hafid on 02/02/24.
//

import UIKit

public class SettingContext {
    public static var shared = SettingContext()

    let userDefault = UserDefaults.standard
    
    public init() {}
    
    var isLoggedIn: Bool {
        get { return userDefault.bool(forKey: "isLoggedIn") }
        set { userDefault.set(newValue, forKey: "isLoggedIn") }
    }
    
    var screenId: String? {
        get { return userDefault.string(forKey: "screenId") }
        set { userDefault.set(newValue, forKey: "screenId") }
    }
    
    var userEmail: String? {
        get { return userDefault.string(forKey: "selectedUserEmail") }
        set { userDefault.set(newValue, forKey: "selectedUserEmail") }
    }
    
    var userId: Int? {
        get { return userDefault.integer(forKey: "selectedUserId") }
        set { userDefault.set(newValue, forKey: "selectedUserId") }
    }
    
    var userUuid: String? {
        get { return userDefault.string(forKey: "selectedUserUuid") }
        set { userDefault.set(newValue, forKey: "selectedUserUuid") }
    }
    
//    var userPass: String? {
//        get { cryptoValetString(forKey: "userPasswordKey") }
//        set {
//            if let newValue {
//                cryptoValetSet(string: newValue, forKey: "userPasswordKey")
//            } else {
//                cryptoValetRemoveObject(forKey: "userPasswordKey")
//            }
//        }
//    }
    
    var accountId: Int? {
        get { return userDefault.integer(forKey: "selectedAccountId") }
        set { userDefault.set(newValue, forKey: "selectedAccountId") }
    }
    
    var isPremium: Bool? {
        get { return userDefault.bool(forKey: "isPremiumUser") }
        set { userDefault.setValue(newValue, forKey: "isPremiumUser") }
    }
    
    var accountUuid: String? {
        get { return userDefault.string(forKey: "selectedAccountUuid") }
        set { userDefault.set(newValue, forKey: "selectedAccountUuid") }
    }
    
    var projectId: Int? {
        get { return userDefault.integer(forKey: "selectedProjectId") }
        set { userDefault.set(newValue, forKey: "selectedProjectId") }
    }
    
    var projectUuid: String? {
        get { return userDefault.string(forKey: "selectedProjectUuid") }
        set { userDefault.set(newValue, forKey: "selectedProjectUuid") }
    }
    
    var selectedLanguage: String? {
        get { return userDefault.string(forKey: "selectedLanguage") }
        set { userDefault.set(newValue, forKey: "selectedLanguage") }
    }
    
    var languagePackCache: Data? {
        get { return self.userDefault.object(forKey: "languagePackCache") as? Data }
        set { self.userDefault.set(newValue, forKey: "languagePackCache") }
    }
    
    func purgeUserDefault() {
        let dictionary = userDefault.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefault.removeObject(forKey: key)
        }
    }
    
    func clearMemoryContext() {
        SettingContext.shared = SettingContext()
    }
}
