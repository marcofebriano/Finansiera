//
//  Array+Extensions.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 28/11/23.
//

import Foundation

extension Sequence where Element: Numeric {
    
    var sum: Element {
        self.reduce(0, +)
    }
}
