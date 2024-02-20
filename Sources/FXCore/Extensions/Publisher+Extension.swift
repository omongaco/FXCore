//
//  File.swift
//  
//
//  Created by Ansyar Hafid on 07/02/24.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
    func bind<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
        sink { [weak root] value in
            root?[keyPath: keyPath] = value
        }
    }
}
