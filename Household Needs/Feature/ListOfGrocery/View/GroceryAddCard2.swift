//
//  GroceryAddCard2.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 28/11/23.
//

import Foundation
import UIKit
import MFRBottomSheet
import SnapKit

enum GroceryCardType {
    case add
    case edit
    case addFromTodolist
}

protocol GroceryAddCard2Delegate: AnyObject {
    func groceryCard(_ card: GroceryAddCard2, type save: GroceryCardType, data: GroceryModel)
}

class GroceryAddCard2: MFRFixedBottomSheet {
    
    private lazy var itemNameTexfield = builder(CommonTextField.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleTextfield = "Item Name"
        $0.placeHolder = "e.g. Chicki ball"
        $0.delegate = self
    }
    
    private lazy var itemPriceTexfield = builder(CommonTextField.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleTextfield = "Item Price (IDR)"
        $0.placeHolder = "e.g. 10.000"
        $0.keyboardType = .numberPad
        $0.delegate = self
    }
    
    private lazy var itemTypePicker = builder(CommonPickerField.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleTextfield = "Item Name"
        $0.placeHolder = "e.g. Chicki ball"
        $0.delegate = self
    }
    
    private lazy var buttonSubmit = builder(UIButton.self) {
        $0.addTarget(self, action: #selector(self.saveButtonAction), for: .touchUpInside)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("Tambah Barang", for: .normal)
        $0.backgroundColor = .mainGreen
        $0.layer.cornerRadius = 8
    }
    
    private lazy var itemQuantityStepper = builder(CommonStepper.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.prefixTitle = "Qty: "
        $0.delegate = self
    }
    
    private var cardType: GroceryCardType = .add {
        didSet {
            let title: String =
            if cardType == .add { "Tambah Barang" }
            else if cardType == .edit { "Edit Barang" }
            else { "Tambahkan ke keranjang" }
            buttonSubmit.setTitle(title, for: .normal)
        }
    }
    
    var padding: UIEdgeInsets {
        UIEdgeInsets(vertical: 8, horizontal: 8)
    }
    
    var keyboardHeight: CGFloat = .zero
    
    public weak var groceryCardDelegate: GroceryAddCard2Delegate?
    
    public var prefilledData: GroceryAddCard2.viewModel? {
        didSet {
            setupPrefilledData()
        }
    }
    
    public var prefilledFromTodolist: String? {
        didSet {
            setupPrefilledData()
        }
    }
    
    init() {
        super.init(sheetType: .dialog)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func initialSetup() {
        super.initialSetup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        containerView.addGestureRecognizer(tap)
        setupView()
        setupPrefilledData()
    }
    
    func setupView() {
        containerView.addSubview(itemTypePicker)
        itemTypePicker.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(padding)
            make.right.equalToSuperview().inset(padding)
            make.width.equalTo(120)
        }
        
        containerView.addSubview(itemNameTexfield)
        itemNameTexfield.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(padding)
            make.right.equalTo(itemTypePicker.snp.left).inset(8)
        }
        
        containerView.addSubview(itemQuantityStepper)
        itemQuantityStepper.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(padding)
            make.top.equalTo(itemTypePicker.snp.bottom).offset(8)
            make.width.equalTo(120)
        }
        
        containerView.addSubview(itemPriceTexfield)
        itemPriceTexfield.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(padding)
            make.right.equalTo(itemQuantityStepper.snp.left).inset(8)
            make.top.equalTo(itemTypePicker.snp.bottom).offset(8)
        }
        
        containerView.addSubview(buttonSubmit)
        buttonSubmit.snp.makeConstraints { make in
            make.top.equalTo(itemQuantityStepper.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(padding)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
            make.height.equalTo(48)
        }
        let pickerData = HouseholdConstant.itemType.compactMap{ 
            CommonPickerField.ViewModel(name: $1, value: $0)
        }
        itemTypePicker.pickerData = pickerData.sorted(by: { $0.value < $1.value })
    }
    
    private func setupPrefilledData() {
        if let prefilled = prefilledData {
            itemNameTexfield.textfieldText = prefilled.itemName
            itemPriceTexfield.textfieldText = prefilled.itemPrice.asThousand
            itemQuantityStepper.currentValue = Double(prefilled.itemQunatity)
            itemTypePicker.setSelectedData(from: prefilled.itemType)
            cardType = .edit
        } else if let prefilledFromTodolist = prefilledFromTodolist {
            itemNameTexfield.textfieldText = prefilledFromTodolist
            cardType = .addFromTodolist
        }
    }
}

// MARK: - Action
extension GroceryAddCard2 {
    @objc
    func dismissKeyboardAction() {
        self.endEditing(true)
    }
    
    @objc
    func saveButtonAction() {
        let groceryModel = GroceryModel(
            groceryID: cardType == .edit ? prefilledData?.itemID ?? "" : UUID().uuidString,
            itemName: itemNameTexfield.textfieldText ?? "",
            itemType: itemTypePicker.selectedData?.value ?? "",
            price: (itemPriceTexfield.textfieldText ?? "").removeThousandFormat.asDouble,
            quantity: Int(itemQuantityStepper.currentValue))
        guard checker() else {
            CommonToast.show(title: "ada data yg kosong tuh, cek lagi dong", direction: .fromTop)
            return
        }
        self.dismissKeyboardAction()
        self.groceryCardDelegate?.groceryCard(self, type: cardType, data: groceryModel)
        self.dismiss(animated: true, withInfo: nil, completion: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        // Add code later...
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardHeight != keyboardSize.height else { return }
        
        self.keyboardHeight = keyboardSize.height
        updateBottomConstraint(-keyboardHeight)
    }
    
    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = .zero
        updateBottomConstraint(keyboardHeight)
    }
}

extension GroceryAddCard2 {
    func checker() -> Bool {
        let nameIsNotEmpty = !(itemNameTexfield.textfieldText ?? "").isEmpty
        let typeIsNotEmpty = !(itemTypePicker.selectedData?.value ?? "").isEmpty
        let priceIsNotEmpty = !(itemPriceTexfield.textfieldText ?? "").isEmpty
        let quantityIsNotZero = Int(itemQuantityStepper.currentValue) != 0
        itemNameTexfield.errorStyle(active: !nameIsNotEmpty)
        itemTypePicker.errorStyle(active: !typeIsNotEmpty)
        itemPriceTexfield.errorStyle(active: !priceIsNotEmpty)
        itemQuantityStepper.errorStyle(active: !quantityIsNotZero)
        return nameIsNotEmpty && typeIsNotEmpty && priceIsNotEmpty && quantityIsNotZero
    }
}

// MARK: - Texfield Delegate
extension GroceryAddCard2: CommonTextFieldDelegate {
    func didBeginEditing(_ textField: CommonTextField) {
        itemNameTexfield.errorStyle(active: false)
        itemPriceTexfield.errorStyle(active: false)
        itemTypePicker.errorStyle(active: false)
        itemQuantityStepper.errorStyle(active: false)
    }
    func didEndEditing(_ textField: CommonTextField, reason: UITextField.DidEndEditingReason) {
        if textField == itemPriceTexfield {
            let text = itemPriceTexfield.textfieldText ?? "0"
            let asThousand = Double(text)?.asThousand
            textField.textfieldText = asThousand
        }
    }
}

extension GroceryAddCard2: CommonPickerFieldDelegate {
    func commonPicker(_ commonPicker: CommonPickerField, didChange value: CommonPickerField.ViewModel) {
        itemNameTexfield.errorStyle(active: false)
        itemPriceTexfield.errorStyle(active: false)
        itemTypePicker.errorStyle(active: false)
        itemQuantityStepper.errorStyle(active: false)
    }
}

extension GroceryAddCard2: CommonStepperDelegate {
    func commonStepper(_ commonStepper: CommonStepper, didChanged: Double) {
        itemNameTexfield.errorStyle(active: false)
        itemPriceTexfield.errorStyle(active: false)
        itemTypePicker.errorStyle(active: false)
        itemQuantityStepper.errorStyle(active: false)
    }
}

extension GroceryAddCard2 {
    struct viewModel {
        var itemID: String
        var itemName: String
        var itemPrice: Double
        var itemQunatity: Int
        var itemType: String
    }
}

extension GroceryModel {
    var asGorecyCardModel: GroceryAddCard2.viewModel {
        return .init(itemID: groceryID, itemName: itemName,
                     itemPrice: price, itemQunatity: quantity,
                     itemType: itemType)
    }
}

extension Item {
    var asGorecyCardModel: GroceryAddCard2.viewModel {
        return .init(itemID: itemID ?? "", itemName: itemName ?? "",
                     itemPrice: itemPrice, itemQunatity: Int(itemQunatity),
                     itemType: itemType ?? "")
    }
}
