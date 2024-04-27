//
//  UIEdgeInsets+Extensions.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation
import UIKit

extension UIEdgeInsets {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    init(vertical: CGFloat) {
        self.init(vertical: vertical, horizontal: 0)
    }
    
    init(horizontal: CGFloat) {
        self.init(vertical: 0, horizontal: horizontal)
    }
    
    init(all: CGFloat) {
        self.init(vertical: all, horizontal: all)
    }
}
