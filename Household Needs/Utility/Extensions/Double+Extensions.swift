//
//  Double+Extensions.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation

extension Double {
    var asThousand: String {
        let formatter = NumberFormatter().thousandFormatCurrency
        return formatter.string(from: NSNumber(floatLiteral: self)) ?? ""
    }
    
    var asThousandIDR: String {
        "IDR \(self.asThousand)"
    }
}
