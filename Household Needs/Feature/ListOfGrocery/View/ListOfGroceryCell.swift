//
//  ListOfGroceryCell.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation
import UIKit
import SnapKit

class ListOfGroceryCell: UITableViewCell {
    
    private lazy var itemName: UILabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.text = ""
    }
    
    private lazy var totalPrice: UILabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textAlignment = .right
        $0.textColor = .black
        $0.text = ""
    }
    
    private lazy var quantity: UILabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .systemGray2
        $0.textAlignment = .center
        $0.text = ""
    }
    
    private lazy var price: UILabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .systemGray2
        $0.textAlignment = .center
        $0.text = ""
    }
    
    private lazy var itemType: UILabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .right
        $0.textColor = .black
        $0.text = "Snack"
    }
    
    public var tapped: (() -> Void)?
    
    private var cardPadding: UIEdgeInsets {
        UIEdgeInsets(vertical: 8, horizontal: 8)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    public func applyWith(_ model: Item) {
        let total = Double(model.itemQunatity) * model.itemPrice
        itemName.text = model.itemName
        itemType.text = setupItemType(model.itemType ?? "")
        quantity.text = "\(model.itemQunatity)"
        price.text = model.itemPrice.asThousand
        totalPrice.text = total.asThousand
    }
    
    private func setupItemType(_ from: String) -> String {
        guard let type: String = HouseholdConstant.itemType[from] else {
            return "Others"
        }
        return type
    }
    
    private func didInit() {        
        selectionStyle = .none
        
        contentView.addSubview(itemType)
        itemType.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().inset(8)
            make.width.equalTo(70)
        }
        
        contentView.addSubview(totalPrice)
        totalPrice.snp.makeConstraints { make in
            make.top.equalTo(itemType.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(8)
            make.width.equalTo(75)
        }
        
        contentView.addSubview(itemName)
        itemName.snp.makeConstraints { make in
            make.centerY.equalTo(totalPrice.snp.centerY)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(totalPrice.snp.left).inset(8)
        }
        
        contentView.addSubview(quantity)
        quantity.snp.makeConstraints { make in
            make.top.equalTo(itemName.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(40)
        }
        
        contentView.addSubview(price)
        price.snp.makeConstraints { make in
            make.left.equalTo(quantity.snp.right).offset(8)
            make.centerY.equalTo(quantity.snp.centerY)
        }
        
    }
}
