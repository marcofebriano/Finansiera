//
//  ToDoListCell.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 13/12/23.
//

import Foundation
import UIKit
import SnapKit

public class ToDoListCell: UITableViewCell {
    
    private lazy var itemName = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16)
        $0.isUserInteractionEnabled = false
        $0.textColor = .black
        $0.text = "itemName"
    }
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(vertical: 8, horizontal: 16)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    private func didInit() {
        selectionStyle = .none
        contentView.addSubview(itemName)
        itemName.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(padding)
        }
    }
    
    public func applyName(_ text: String) {
        itemName.text = text
    }
}
