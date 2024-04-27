//
//  CommonStepper.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 01/12/23.
//

import Foundation
import UIKit
import SnapKit

protocol CommonStepperDelegate: AnyObject {
    func commonStepper(_ commonStepper: CommonStepper, didChanged: Double)
}

class CommonStepper: UIView {
    
    private lazy var stackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private lazy var titleLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var stepperContainer = builder(UIView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }
    
    private lazy var buttonPlus = builder(UIButton.self) {
        let image = UIImage(systemName: "plus")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.addTarget(self, action: #selector(plusButtonAction(_:)), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = true
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .mainGreen
    }
    
    private lazy var buttonMinus = builder(UIButton.self) {
        let image = UIImage(systemName: "minus")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        $0.addTarget(self, action: #selector(minusButtonAction(_:)), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = true
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .secondaryGreen
    }
    
    private lazy var buttonStackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fillEqually
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 0
    }
    
    var padding = UIEdgeInsets(vertical: 8, horizontal: 8) {
        didSet {
            updatePadding()
        }
    }
    
    var prefixTitle: String = "" {
        didSet {
            let valueAsInt = Int(_currentValue)
            titleLabel.text = "\(prefixTitle)\(valueAsInt)"
        }
    }
    
    public weak var delegate: CommonStepperDelegate?
    
    private var _currentValue: Double = 0.0
    private var _minimumValue: Double = 0.0
    
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
            make.edges.equalToSuperview().inset(padding)
        }
        stackView.addArrangedSubviews([titleLabel, stepperContainer])
        stepperContainer.snp.makeConstraints { $0.height.equalTo(32) }
        stepperContainer.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        buttonStackView.addArrangedSubviews([buttonMinus, buttonPlus])
    }
    
    private func updatePadding() {
        stackView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(padding)
        }
    }
    
    private func updateLabel() {
        let valueAsInt = Int(_currentValue)
        titleLabel.text = "\(prefixTitle)\(valueAsInt)"
    }
    
    public func errorStyle(active: Bool) {
        let newBorderColor: UIColor = active ? .red : .black
        stepperContainer.layer.borderColor =  newBorderColor.cgColor
    }
}

// MARK: - Action
extension CommonStepper {
    @objc
    private func minusButtonAction(_ sender: UIButton) {
        defer {
            delegate?.commonStepper(self, didChanged: _currentValue)
        }
        let newValue = _currentValue - 1
        guard newValue > _minimumValue else {
            _currentValue = _minimumValue
            updateLabel()
            return
        }
        _currentValue = newValue
        updateLabel()
    }
    
    @objc
    private func plusButtonAction(_ sender: UIButton) {
        defer {
            delegate?.commonStepper(self, didChanged: _currentValue)
        }
        _currentValue += 1
        updateLabel()
    }
    
    @objc
    private func stepperClicked(_ sender: UIStepper) {
        let valueAsInt = Int(sender.value)
        titleLabel.text = "\(prefixTitle)\(valueAsInt)"
    }
}

extension CommonStepper {
    
    var cornerRadius: CGFloat {
        get { stepperContainer.layer.cornerRadius }
        set { stepperContainer.layer.cornerRadius = newValue }
    }
    
    var borderWidth: CGFloat {
        get { stepperContainer.layer.borderWidth }
        set { stepperContainer.layer.borderWidth = newValue }
    }
    
    var borderColor: CGColor? {
        get { stepperContainer.layer.borderColor }
        set { stepperContainer.layer.borderColor = newValue }
    }
    
    var spacingTitleAndTextfield: CGFloat {
        get { stackView.spacing }
        set { stackView.spacing = newValue }
    }
    
    var currentValue: Double {
        get { _currentValue }
        set {
            _currentValue = newValue
            let valueAsInt = Int(_currentValue)
            titleLabel.text = "\(prefixTitle)\(valueAsInt)"
        }
    }
    
    var minimumValue: Double {
        get { _minimumValue }
        set { _minimumValue = newValue }
    }
}
