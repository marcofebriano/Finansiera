//
//  AddToDoListCard.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 13/12/23.
//

import Foundation
import UIKit
import SnapKit
import MFRBottomSheet

enum AddToDoListCardType {
    case add
    case edit
}

public class AddToDoListCard: MFRFixedBottomSheet {
    private lazy var itemNameTexfield = builder(CommonTextField.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleTextfield = "Item Name"
        $0.placeHolder = "e.g. Chicki ball"
        $0.delegate = self
    }
    
    private lazy var buttonSubmit = builder(UIButton.self) {
        $0.addTarget(self, action: #selector(self.saveButtonAction), for: .touchUpInside)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("Add Item", for: .normal)
        $0.backgroundColor = .mainGreen
        $0.layer.cornerRadius = 8
    }
    
    var padding: UIEdgeInsets {
        UIEdgeInsets(vertical: 8, horizontal: 8)
    }
    
    var keyboardHeight: CGFloat = .zero
    
    var type: AddToDoListCardType = .add
    
    var prefilled: String? {
        didSet {
            setupPrefilled()
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
    
    public override func initialSetup() {
        super.initialSetup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        containerView.addGestureRecognizer(tap)
        setupView()
    }
    
    func setupView() {
        containerView.addSubview(itemNameTexfield)
        itemNameTexfield.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(padding)
        }
        
        containerView.addSubview(buttonSubmit)
        buttonSubmit.snp.makeConstraints { make in
            make.top.equalTo(itemNameTexfield.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(padding)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(8)
            make.height.equalTo(48)
        }
    }
    
    func setupPrefilled() {
        guard let data = prefilled else { return }
        itemNameTexfield.textfieldText = data
        buttonSubmit.setTitle("Update Item", for: .normal)
        type = .edit
    }
    
    @objc
    func dismissKeyboardAction() {
        self.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, keyboardHeight != keyboardSize.height else { return }
        
        self.keyboardHeight = keyboardSize.height
        updateBottomConstraint(-keyboardHeight)
    }
    
    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = .zero
        updateBottomConstraint(keyboardHeight)
    }
    
    @objc
    func saveButtonAction() {
        guard checker() else {
            CommonToast.show(title: "ada data yg kosong tuh, cek lagi dong", direction: .fromTop)
            return
        }
        let itemName = itemNameTexfield.textfieldText ?? ""
        let dataSend: [AddToDoListCardType: String] = [type: itemName]
        self.dismissKeyboardAction()
        self.dismiss(animated: true, withInfo: dataSend, completion: nil)
    }
}

extension AddToDoListCard {
    func checker() -> Bool {
        let nameIsNotEmpty = !(itemNameTexfield.textfieldText ?? "").isEmpty
        itemNameTexfield.errorStyle(active: !nameIsNotEmpty)
        return nameIsNotEmpty
    }
}

extension AddToDoListCard: CommonTextFieldDelegate {
    func didBeginEditing(_ textField: CommonTextField) {
        itemNameTexfield.errorStyle(active: false)
    }
}
