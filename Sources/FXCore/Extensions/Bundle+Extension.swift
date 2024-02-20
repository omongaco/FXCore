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
}
