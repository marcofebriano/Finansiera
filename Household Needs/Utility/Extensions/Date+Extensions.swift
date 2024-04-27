//
//  Date+Extensions.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 08/12/23.
//

import Foundation

extension Date {
    var asPeriodName: String {
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "MMMM - yyyy"
        // Apply date format
        return dateFormatter.string(from: self)
    }
    
    var getYear: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    var getMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}
