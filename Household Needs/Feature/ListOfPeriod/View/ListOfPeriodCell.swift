//
//  ListOfPeriodCell.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 07/12/23.
//

import Foundation
import UIKit
import SnapKit

class ListOfPeriodCell: UITableViewCell {
    
    private lazy var periodName = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.text = ""
    }
    
    private lazy var totalSpend = builder(UILabel.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .systemGray2
        $0.text = ""
    }
    
    public var tapped: (() -> Void)?
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(vertical: 8, horizontal: 16)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        didInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        didInit()
    }
    
    private func didInit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        contentView.addGestureRecognizer(tap)
        
        contentView.addSubview(periodName)
        contentView.addSubview(totalSpend)
        
        totalSpend.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(padding)
        }
        
        periodName.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(padding)
        }
    }
    
    @objc
    private func tapAction() {
        tapped?()
    }
    
    public func applyWith(_ model: ListOfPeriodCell.ViewModel) {
        periodName.text = model.periodTitle
        totalSpend.text = model.grandTotal.asThousandIDR
    }
}

extension ListOfPeriodCell {
    struct ViewModel {
        var periodTitle: String
        var grandTotal: Double
    }
}

extension Period {
    var asPeriodCellModel: ListOfPeriodCell.ViewModel {
        return .init(
            periodTitle: Date(timeIntervalSince1970: timestamp).getMonth,
            grandTotal: totalSpend
        )
    }
}
