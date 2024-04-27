//
//  CommonTextField.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 28/11/23.
//

import Foundation
import UIKit
import SnapKit

protocol CommonTextFieldDelegate: AnyObject {
    func didBeginEditing(_ textField: CommonTextField)
    func didEndEditing(_ textField: CommonTextField)
    func didEndEditing(_ textField: CommonTextField, reason: UITextField.DidEndEditingReason)
}

extension CommonTextFieldDelegate {
    func didBeginEditing(_ textField: CommonTextField) { }
    func didEndEditing(_ textField: CommonTextField) { }
    func didEndEditing(_ textField: CommonTextField, reason: UITextField.DidEndEditingReason) { }
}

class CommonTextField: UIView {
    
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
        $0.isHidden = true
    }
    
    private lazy var textFieldContainer = builder(UIView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    private lazy var textfield = builder(UITextField.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
    }
    
    var padding = UIEdgeInsets(vertical: 8, horizontal: 8) {
        didSet {
            updatePadding()
        }
    }
    
    var textfieldPadding = UIEdgeInsets(vertical: 8, horizontal: 8) {
        didSet {
            updatePadding()
        }
    }
    
    weak var delegate: CommonTextFieldDelegate?
    
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
        
        stackView.addArrangedSubviews([titleLabel, textFieldContainer])
        
        textFieldContainer.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(textfieldPadding)
        }
        
    }
    
    private func updatePadding() {
        stackView.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(padding)
        }
        textfield.snp.updateConstraints { make in
            make.edges.equalToSuperview().inset(textfieldPadding)
        }
    }
    
    public func errorStyle(active: Bool) {
        let borderColor: UIColor = active ? .red : .black
        textFieldContainer.layer.borderColor =  borderColor.cgColor
    }
}

extension CommonTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didEndEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate?.didEndEditing(self, reason: reason)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didBeginEditing(self)
    }
}

extension CommonTextField {
    var keyboardType: UIKeyboardType {
        get { textfield.keyboardType }
        set { textfield.keyboardType = newValue }
    }
    
    var placeHolder: String? {
        get { textfield.placeholder }
        set { textfield.placeholder = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { textFieldContainer.layer.cornerRadius }
        set { textFieldContainer.layer.cornerRadius = newValue }
    }
    
    var borderWidth: CGFloat {
        get { textFieldContainer.layer.borderWidth }
        set { textFieldContainer.layer.borderWidth = newValue }
    }
    
    var borderColor: CGColor? {
        get { textFieldContainer.layer.borderColor }
        set { textFieldContainer.layer.borderColor = newValue }
    }
    
    var titleTextfield: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
            titleLabel.isHidden = (titleLabel.text ?? "").isEmpty ? true : false
        }
    }
    
    var spacingTitleAndTextfield: CGFloat {
        get { stackView.spacing }
        set { stackView.spacing = newValue }
    }
    
    var textfieldText: String? {
        get { textfield.text }
        set { textfield.text = newValue }
    }
}
