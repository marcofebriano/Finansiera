//
//  GroceryAddCard.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 28/11/23.
//

import Foundation
import UIKit
import SnapKit
import MFRBottomSheet

class GroceryAddCard: MFRSlidingBottomSheet {
    
    private lazy var itemNameTexfiled = builder(CommonTextField.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleTextfield = "Item Name"
        $0.placeHolder = "e.g. Chicki ball"
        $0.keyboardType = .numberPad
    }
    
    var padding: UIEdgeInsets {
        UIEdgeInsets(vertical: 8, horizontal: 8)
    }
    
    var keyboardAppear: Bool = false
    
    init() {
        super.init(config: .init(heights: [300], startIndex: 0), dismissable: true)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialSetup() {
        super.initialSetup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(shouldDismissKeyboard))
        self.containerView.addGestureRecognizer(tap)
        setupView()
    }
    
    func setupView() {
        containerView.addSubview(itemNameTexfiled)
        itemNameTexfiled.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(padding)
        }
    }
    
    @objc
    func shouldDismissKeyboard() {
        self.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        // Add code later...
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              !keyboardAppear else { return }
        keyboardAppear = true
        let keyboardHeight = keyboardSize.height
        let newHeight = keyboardHeight + 300
        self.setHeightPoints([newHeight], startAt: 0)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        keyboardAppear = false
        self.setHeightPoints([300], startAt: 0)
    }
}

extension GroceryAddCard: UITextFieldDelegate {
    
}
