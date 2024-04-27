//
//  String+Extensions.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 04/12/23.
//

import Foundation

extension String {
    var removeThousandFormat: String {
        self.replacingOccurrences(of: ".", with: "")
    }
    
    var asDouble: Double {
        Double(self) ?? 0
    }
    
    var asInt: Int {
        Int(self) ?? 0
    }
}
