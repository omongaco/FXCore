//
//  File.swift
//  
//
//  Created by Ansyar Hafid on 07/02/24.
//

import Foundation

public extension Bundle {
    static func classBundle(for class: AnyClass) -> Bundle {
        return Bundle(for: `class`.self)
    }
    
    static var module: Bundle = {
        let bundleName = "FXCore"
        
        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: LanguageManager.self).resourceURL,
            Bundle.main.bundleURL,
        ]
        
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        fatalError("unable to find bundle named \(bundleName)")
    }()
}
