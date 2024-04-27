//
//  CommonPickerField.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 01/12/23.
//

import Foundation
import UIKit
import SnapKit

protocol CommonPickerFieldDelegate: AnyObject {
    func commonPicker(_ commonPicker: CommonPickerField, didChange value: CommonPickerField.ViewModel)
}

class CommonPickerField: UIView {
    
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
    
    private lazy var pickerView = builder(UIPickerView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    private lazy var textfield = builder(UITextField.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var privateData: [CommonPickerField.ViewModel] = [] {
        didSet {
            pickerView.reloadAllComponents()
            privateSelectedData = privateData.first
        }
    }
    
    private var privateSelectedData: CommonPickerField.ViewModel? {
        didSet {
            textfield.text = privateSelectedData?.name
        }
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
    
    public weak var delegate: CommonPickerFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    func didInit() {
        textfield.inputView = pickerView
        dismissPickerView()
        
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
    
    public func setSelectedData(from value: String) {
        let getSelected = privateData.filter({ $0.value == value }).first
        selectedData = getSelected
    }
    
    public func errorStyle(active: Bool) {
        let newBorderColor: UIColor = active ? .red : .black
        textFieldContainer.layer.borderColor =  newBorderColor.cgColor
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
        toolBar.setItems([.flexibleSpace(), button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textfield.inputAccessoryView = toolBar
    }
    
    @objc 
    private func doneAction() {
        self.endEditing(true)
    }
}

extension CommonPickerField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        privateData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        privateData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        privateSelectedData = privateData[row]
        guard let privateSelectedData = privateSelectedData else { return }
        delegate?.commonPicker(self, didChange: privateSelectedData)
    }
}

extension CommonPickerField {
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
    
    var spacingTitleAndTextfield: CGFloat {
        get { stackView.spacing }
        set { stackView.spacing = newValue }
    }
    
    var titleTextfield: String? {
        get { titleLabel.text }
        set {
            titleLabel.text = newValue
            titleLabel.isHidden = (titleLabel.text ?? "").isEmpty ? true : false
        }
    }
    
    var pickerData: [CommonPickerField.ViewModel] {
        get { privateData }
        set { privateData = newValue }
    }
    
    var selectedData: CommonPickerField.ViewModel? {
        get { privateSelectedData }
        set { privateSelectedData = newValue}
    }
}

extension CommonPickerField {
    struct ViewModel: Hashable {
        var name: String
        var value: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(value)
        }
        
        static func == (lhs: CommonPickerField.ViewModel, rhs: CommonPickerField.ViewModel) -> Bool {
            return lhs.name == rhs.name && lhs.value == rhs.name
        }
    }
}
