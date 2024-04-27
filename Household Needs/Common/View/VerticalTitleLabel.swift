//
//  VerticalTitleLabel.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation
import UIKit
import SnapKit

class VerticalTitleLabel: UIView {
    
    lazy var stackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fillProportionally
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    lazy var titleLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
    }
    
    lazy var subtitleLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .lightGray
        $0.isHidden = true
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
        
        stackView.addArrangedSubviews([titleLabel, subtitleLabel])
    }
}

extension VerticalTitleLabel{
    var spacing: CGFloat {
        get { stackView.spacing }
        set { stackView.spacing = newValue }
    }
    var titleColor: UIColor {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }
    var subtitleColor: UIColor {
        get { subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }
    var titleFont: UIFont {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    }
    var subtitleFont: UIFont {
        get { subtitleLabel.font }
        set { subtitleLabel.font = newValue }
    }
    
    var titleText: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    var subtitleText: String? {
        get { subtitleLabel.text }
        set {
            subtitleLabel.text = newValue
            subtitleLabel.isHidden = (newValue ?? "").isEmpty ? true : false
        }
    }
}
