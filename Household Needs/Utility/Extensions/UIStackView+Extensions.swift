//
//  UIStackView+Extensions.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
