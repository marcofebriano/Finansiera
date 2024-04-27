//
//  CommonButton.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 13/12/23.
//

import Foundation
import UIKit
import SnapKit

public class CommonButton: UIButton {
    
    public var style: CommonButton.Style = .mainGreen {
        didSet {
            didSetStyle()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    private func didInit() {
        self.layer.cornerRadius = 8
        didSetStyle()
    }
    
    private func didSetStyle() {
        self.setTitleColor(style.titleColor, for: .normal)
        self.backgroundColor = style.background
        self.layer.borderWidth = style.borderWidth
        self.layer.borderColor = style.borderColor.cgColor
    }
    
}

public extension CommonButton {
    struct Style {
        var background: UIColor
        var titleColor: UIColor
        var borderColor: UIColor
        var borderWidth: CGFloat
        
        init(background: UIColor, 
             titleColor: UIColor,
             borderColor: UIColor,
             borderWidth: CGFloat
        ) {
            self.background = background
            self.titleColor = titleColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
        }
    }
}

public extension CommonButton.Style {
    static var mainGreen: CommonButton.Style {
        return .init(background: .mainGreen,
                     titleColor: .black,
                     borderColor: .mainGreen,
                     borderWidth: 1)
    }
    
    static var mainGreenBorder: CommonButton.Style {
        return .init(background: .white,
                     titleColor: .mainGreen,
                     borderColor: .mainGreen,
                     borderWidth: 1)
    }
    
    static var mainGray: CommonButton.Style {
        return .init(background: .mainGray,
                     titleColor: .black,
                     borderColor: .mainGray,
                     borderWidth: 1)
    }
    
    static var mainGrayBorder: CommonButton.Style {
        return .init(background: .white,
                     titleColor: .mainGray,
                     borderColor: .mainGray,
                     borderWidth: 1)
    }
    
    static var mainRed: CommonButton.Style {
        return .init(background: .mainRed,
                     titleColor: .white,
                     borderColor: .mainRed,
                     borderWidth: 1)
    }
    
    static var mainRedBorder: CommonButton.Style {
        return .init(background: .white,
                     titleColor: .mainRed,
                     borderColor: .mainRed,
                     borderWidth: 1)
    }
}
