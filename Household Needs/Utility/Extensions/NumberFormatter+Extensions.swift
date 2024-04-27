//
//  NumberFormatter+Extensions.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 27/04/24.
//

import Foundation

public extension NumberFormatter {
    var thousandFormat: NumberFormatter {
        self.groupingSeparator = "."
        self.numberStyle = .decimal
        return self
    }
    
    var thousandFormatCurrency: NumberFormatter {
        self.locale = Locale(identifier: "id_ID")
        self.groupingSeparator = "."
        self.numberStyle = .decimal
        return self
    }
}
