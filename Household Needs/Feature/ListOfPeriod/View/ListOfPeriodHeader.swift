//
//  ListOfPeriodHeader.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 12/12/23.
//

import Foundation
import UIKit
import SnapKit

class ListOfPeriodHeader: UITableViewHeaderFooterView {
    
    private lazy var titleLabel = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .black
        $0.text = ""
    }
    
    private lazy var totalSpend = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 14)
        $0.textColor = .black
        $0.text = ""
    }
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(vertical: 8, horizontal: 8)
    }
    
    public var headerTapped: (() -> Void)?
    
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(totalSpend)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        contentView.addGestureRecognizer(tap)
        
        totalSpend.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(padding)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(padding)
        }
    }
    
    public func applyWith(_ model: ListOfPeriodCell.ViewModel) {
        titleLabel.text = model.periodTitle
        totalSpend.text = model.grandTotal.asThousandIDR
    }
    
    @objc func tapped() {
        self.headerTapped?()
    }
}

extension ListOfPeriodHeader {
    struct ViewModel {
        var periodTitle: String
        var grandTotal: Double
    }
}
