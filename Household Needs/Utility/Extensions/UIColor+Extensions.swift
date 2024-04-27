//
//  UIColor+Extensions.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 09/12/23.
//

import Foundation
import UIKit

// MARK: - Color from Hex String
public extension UIColor {
    convenience init(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init()
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red: ((hex >> 16) & 0xFF), green: ((hex >> 8) & 0xFF), blue: (hex & 0xFF))
    }
}

public extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   CGFloat(arc4random()) / CGFloat(UInt32.max), // swiftlint:disable:this colon
            green: CGFloat(arc4random()) / CGFloat(UInt32.max), // swiftlint:disable:this colon
            blue:  CGFloat(arc4random()) / CGFloat(UInt32.max), // swiftlint:disable:this colon
            alpha: 1.0
        )
    }
}


public extension UIColor {
    static var mainGreen = UIColor(hex: "ccd5ae")
    static var secondaryGreen = UIColor(hex: "e9edc9")
    static var tertiaryGreen = UIColor(hex: "a3b18a")
    
    static var mainGray = UIColor(hex: "d6ccc2")
    
    static var mainRed = UIColor(hex: "bc4749")
    
    static var mainBlue = UIColor(hex: "669bbc")
}
