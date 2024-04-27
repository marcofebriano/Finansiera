//
//  HouseholdConstant.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 06/12/23.
//

import Foundation
import UIKit

class HouseholdConstant {
    static var itemType: [String: String] = [
        "HNIT-0": "Kitchen",
        "HNIT-1": "Soap",
        "HNIT-2": "Snack",
        "HNIT-3": "E-food",
        "HNIT-4": "Meats",
        "HNIT-5": "Pharmacy",
        "HNIT-99": "Others",
    ]
    
    static var bundleID: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    static var chartColors: [UIColor] = [
        UIColor(hex: "ccd5ae"),
        UIColor(hex: "e9edc9"),
        UIColor(hex: "a3b18a"),
        UIColor(hex: "d6ccc2"),
        UIColor.mainRed,
        UIColor(hex: "d4a373"),
    ]
}
