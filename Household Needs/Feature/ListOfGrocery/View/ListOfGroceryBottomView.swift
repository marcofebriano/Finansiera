//
//  ListOfGroceryBottomView.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 28/11/23.
//

import Foundation
import UIKit
import SnapKit

class ListOfGroceryBottomView: UIView {
    
    private lazy var container = builder(UIView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    private lazy var addButton = builder(UIButton.self) {
        $0.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Tambah Barang", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 15)
        $0.backgroundColor = .mainGreen
        $0.layer.cornerRadius = 8
    }
    
    private lazy var grandTotalView = builder(LeftRightLabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rightFont = .boldSystemFont(ofSize: 17)
        $0.leftText = "Grand Total:"
        $0.rightText = "IDR 0"
    }
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(vertical: 8, horizontal: 8)
    }
    
    public var didTapButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        container.layer.masksToBounds = true
        container.roundCorners(corners: [.topLeft, .topRight], radius: 8)
    }
    
    private func didInit() {
        self.backgroundColor = .black.withAlphaComponent(0.1)
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.bottom.right.equalToSuperview()
        }
        
        container.addSubview(grandTotalView)
        grandTotalView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(padding)
        }
        
        container.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(grandTotalView.snp.bottom).offset(16)
            make.height.equalTo(48)
            make.left.right.bottom.equalToSuperview().inset(padding)
        }
    }
    
    @objc
    private func addButtonTapped() {
        didTapButton?()
    }
}

extension ListOfGroceryBottomView {
    var grandTotal: String? {
        get { grandTotalView.rightText }
        set { grandTotalView.rightText = newValue }
    }
    
    var title: String? {
        get { grandTotalView.leftText }
        set { grandTotalView.leftText = newValue }
    }
}
