//
//  ToDoListHeaderCell.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 15/12/23.
//

import Foundation
import UIKit
import SnapKit

class ToDoListHeaderCell: UITableViewHeaderFooterView {
    
    private lazy var titleLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.text = ""
    }
    
    private lazy var iconView = builder(UIImageView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(vertical: 8, horizontal: 8)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    private func didInit() {
        contentView.backgroundColor = .mainGray
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        
        iconView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(padding)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView.snp.centerY)
            make.left.equalTo(iconView.snp.right).offset(8)
            make.right.equalToSuperview().inset(padding)
        }
    }
    
    public func applyWith(_ title: String) {
        let convertTitle = title == "list" ? "Daftar" : "keranjang"
        let image = UIImage(systemName: title == "list" ? "list.bullet.clipboard.fill" : "cart.fill")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        titleLabel.text = convertTitle
        iconView.image = image
    }
}

