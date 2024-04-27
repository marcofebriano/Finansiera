//
//  Builder.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation
import UIKit

protocol Initializable {
    init()
}

extension UIView: Initializable { }

func builder<T: Initializable>(_ item: T.Type, _ build: ((inout T) -> Void)) -> T {
    var itemBuild = T.init()
    if let asView = itemBuild as? UIView {
        asView.translatesAutoresizingMaskIntoConstraints = false
    }
    build(&itemBuild)
    return itemBuild
}

func builder<T: UIView>(_ item: T, _ build: ((inout T) -> Void)) -> T {
    var itemBuild = item
    build(&itemBuild)
    return itemBuild
}
