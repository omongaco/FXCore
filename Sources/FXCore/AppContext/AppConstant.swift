//
//  AppConstant.swift
//  Corebase
//
//  Created by Ansyar Hafid on 02/02/24.
//

import Foundation

public struct AppConstant {
    public enum Modules: String, CaseIterable {
        case home = "Home"
        case forms = "Forms"
        case reports = "Report"
        case documents = "Documents"
        case profile = "Profile"
        case users = "Users"
        case certificates = "Certificates"
        case media = "Media"
        case integration = "Integration"
        case settings = "Settings"
        case helpdesk = "HelpDesk"
        case training = "Training"
        case tasks = "Tasks"
        case more = "More"
    }
    
    enum TimeZoneIdentifier: String {
        case california = "US/Pacific"
        case utc = "UTC"
    }

    enum LocaleIdentifier: String {
        case en = "en_US"
        case posix = "en_US_POSIX"
    }
}
