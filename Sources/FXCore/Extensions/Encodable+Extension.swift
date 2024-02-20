//
//  File.swift
//  
//
//  Created by Ansyar Hafid on 07/02/24.
//

import Foundation

public extension Encodable {
    // Transform Model Object to Dictionary
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data,
                                                  options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    // Transform Model Object to JSON String
    var jsonString: String? {
        if let jsonData = try? JSONEncoder().encode(self),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return nil
        }
    }
}
