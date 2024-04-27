//
//  CommonDotPageControl.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 04/12/23.
//

import Foundation
import UIKit
import SnapKit

class CommonDotPageControl: UIView {
    
    var normalColor: UIColor? = .lightGray {
        didSet {
            self.backgroundColor = normalColor
        }
    }
    
    var activeColor: UIColor? = .darkGray
    
    override var bounds: CGRect {
        didSet {
            self.layer.cornerRadius = self.bounds.height * 0.5
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    private func didInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
    }
    
    func animateActive() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform.init(scaleX: 2, y: 1)
            self.layer.cornerRadius = self.bounds.height * 0.3
            self.backgroundColor = self.activeColor
        })
    }
    
    func normalStyle() {
        self.layer.cornerRadius = self.bounds.height * 0.5
        self.backgroundColor = normalColor
        self.transform = .identity
    }
}
