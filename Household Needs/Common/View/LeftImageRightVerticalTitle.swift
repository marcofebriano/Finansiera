//
//  LeftImageRightVerticalTitle.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation
import UIKit
import SnapKit

class LeftImageRightVerticalTitle: UIView {
    
    private lazy var mainStackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    private lazy var stackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private lazy var icon = builder(UIImageView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var verticalTitle = builder(VerticalTitleLabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var separator: UIView = builder(UIView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
    }
    
    public var selectHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    public func build(_ build: (inout LeftImageRightVerticalTitle.Model) -> Void) {
        var model = LeftImageRightVerticalTitle.Model()
        build(&model)
        icon.image = model.image
        stackView.spacing = model.spacingIconAndText
        verticalTitle.spacing = model.spacingInText
        verticalTitle.subtitleColor = model.subtitleColor
        verticalTitle.subtitleFont = model.subtitleFont
        verticalTitle.subtitleText = model.subtitleText
        verticalTitle.titleColor = model.titleColor
        verticalTitle.titleFont = model.titleFont
        verticalTitle.titleText = model.titleText
        separator.isHidden = model.separatorHidden
        separator.backgroundColor = model.separatorColor
    }
    
    private func didInit() {
        self.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainStackView.addArrangedSubviews([stackView, separator])
        stackView.addArrangedSubviews([icon, verticalTitle])
        
        icon.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    @objc func tapHandle() {
        selectHandler?()
    }
}

extension LeftImageRightVerticalTitle {
    class Model {
        var image: UIImage?
        var spacingInText: CGFloat
        var spacingIconAndText: CGFloat
        var spacingViewWithSeparator: CGFloat
        var titleColor: UIColor
        var subtitleColor: UIColor
        var titleFont: UIFont
        var subtitleFont: UIFont
        var titleText: String
        var subtitleText: String?
        var separatorHidden: Bool
        var separatorColor: UIColor
        
        init(
            image: UIImage? = nil,
            spacingInText: CGFloat = 8,
            spacingIconAndText: CGFloat = 8,
            spacingViewWithSeparator: CGFloat = 8,
            titleColor: UIColor = .white,
            subtitleColor: UIColor = .lightGray,
            titleFont: UIFont = UIFont.systemFont(ofSize: 12),
            subtitleFont: UIFont = UIFont.systemFont(ofSize: 12),
            titleText: String = "",
            subtitleText: String? = nil,
            separatorHidden: Bool = true,
            separatorColor: UIColor = .mainGray
        ) {
            self.image = image
            self.spacingInText = spacingInText
            self.spacingIconAndText = spacingIconAndText
            self.spacingViewWithSeparator = spacingViewWithSeparator
            self.titleColor = titleColor
            self.subtitleColor = subtitleColor
            self.titleFont = titleFont
            self.subtitleFont = subtitleFont
            self.titleText = titleText
            self.subtitleText = subtitleText
            self.separatorHidden = separatorHidden
            self.separatorColor = separatorColor
        }
    }
}
