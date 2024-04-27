//
//  VerificationCard.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 13/12/23.
//

import Foundation
import UIKit
import SnapKit
import MFRBottomSheet

public enum VerificationCardButtonTap {
    case Left
    case right
}

public class VerificationCard: MFRFixedBottomSheet {
    
    private lazy var mainStackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private lazy var verticalTitle = builder(VerticalTitleLabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleFont = .boldSystemFont(ofSize: 15)
        $0.spacing = 4
    }
    
    private lazy var imageIllustration = builder(UIImageView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "trash.square.fill")?.withTintColor(.mainRed, renderingMode: .alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var imageTitleStack = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    private lazy var buttonStackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    private lazy var leftButton = builder(CommonButton.self) {
        $0.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Left Button", for: .normal)
        $0.style = .mainGreen
    }
    
    private lazy var rightButton = builder(CommonButton.self) {
        $0.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Right Button", for: .normal)
        $0.style = .mainGreen
    }
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(all: 8)
    }
    
    init(with model: VerificationCard.ViewModel) {
        super.init(sheetType: .fixed)
        verticalTitle.titleText = model.title
        verticalTitle.subtitleText = model.subtitle
        rightButton.setTitle(model.rightButtonText, for: .normal)
        leftButton.setTitle(model.leftButtonText, for: .normal)
        rightButton.style = model.rightButtonStyle
        leftButton.style = model.leftButtonStyle
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func initialSetup() {
        super.initialSetup()
        setupView()
    }
    
    private func setupView() {
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(padding)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        
        mainStackView.addArrangedSubviews([imageTitleStack, buttonStackView])
        imageTitleStack.addArrangedSubviews([imageIllustration, verticalTitle])
        buttonStackView.addArrangedSubviews([leftButton, rightButton])
        
        imageIllustration.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
    }
}

extension VerificationCard {
    @objc
    private func leftButtonAction() {
        let tapped = VerificationCardButtonTap.Left
        self.dismiss(animated: true, withInfo: tapped, completion: nil)
    }
    
    @objc
    private func rightButtonAction() {
        let tapped = VerificationCardButtonTap.right
        self.dismiss(animated: true, withInfo: tapped, completion: nil)
    }
}

extension VerificationCard {
    class ViewModel {
        var title: String = ""
        var subtitle: String?
        var leftButtonStyle: CommonButton.Style = .mainGreen
        var rightButtonStyle: CommonButton.Style = .mainRedBorder
        var leftButtonText: String = "Gak jadi"
        var rightButtonText: String = "iya"
    }
}
