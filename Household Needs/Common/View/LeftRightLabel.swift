//
//  LeftRightLabel.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 28/11/23.
//

import Foundation
import UIKit
import SnapKit

class LeftRightLabel: UIView {
    private lazy var stackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    private lazy var leftLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        $0.text = "Left"
    }
    
    private lazy var rightLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .right
        $0.numberOfLines = 1
        $0.text = "Right"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    func didInit() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.addArrangedSubviews([leftLabel, rightLabel])
    }
}

extension LeftRightLabel {
    var spacing: CGFloat {
        get { stackView.spacing }
        set { stackView.spacing = newValue }
    }
    
    var leftText: String? {
        get { leftLabel.text }
        set { leftLabel.text = newValue }
    }
    
    var leftFont: UIFont {
        get { leftLabel.font }
        set { leftLabel.font = newValue }
    }
    
    var leftTextColor: UIColor {
        get { leftLabel.textColor }
        set { leftLabel.textColor = newValue }
    }
    
    var rightText: String? {
        get { rightLabel.text }
        set { rightLabel.text = newValue }
    }
    
    var rightFont: UIFont {
        get { rightLabel.font }
        set { rightLabel.font = newValue }
    }
    
    var rightTextColor: UIColor {
        get { rightLabel.textColor }
        set { rightLabel.textColor = newValue }
    }
}
