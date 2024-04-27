//
//  ImageAsset.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation
import UIKit

public protocol ImageAsset {
    static var baseName: String { get }
    var name: String { get }
}

public extension ImageAsset where Self: RawRepresentable, Self.RawValue == String {
    var name: String { "\(Self.baseName)_\(rawValue)" }
}

public extension UIImage {
    static func asset(_ imageAsset: ImageAsset) -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(named: imageAsset.name, in: .main, with: nil)
        } else {
            return UIImage(named: imageAsset.name, in: .main, compatibleWith: nil)
        }
    }
    
    static func asset(icon: ImageAssets.Icon) -> UIImage? {
        asset(icon)
    }
}


public struct ImageAssets {
    public enum Icon: String, ImageAsset {
        public static var baseName: String { "icon" }
        case rupiah
        case quantity
    }
}
