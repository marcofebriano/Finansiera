//
//  EditItemCard.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 25/04/24.
//

import Foundation
import UIKit
import SnapKit
import MFRBottomSheet

enum EditItemActionType {
    case edit
    case addToCart
    case delete
    
    var name: String {
        switch self {
        case .edit:
            return "Edit"
        case .addToCart:
            return "Tambah ke cart"
        case .delete:
            return "Hapus"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .edit:
            return UIImage(systemName: "pencil")
        case .addToCart:
            return UIImage(systemName: "cart.fill")
        case .delete:
            return UIImage(systemName: "trash")
        }
    }
    
    var color: UIColor {
        switch self {
        case .edit:
            return .mainBlue
        case .addToCart:
            return .tertiaryGreen
        case .delete:
            return .mainRed
        }
    }
}

/// Class for Edit Item Card View.
/// This class will show actions editing.
/// The action selected will notify in _**MFRBaseBottomSheetDelegate**_ in the function _**willDismiss**_ and _**didDismiss**_.
final class EditItemCard: MFRFixedBottomSheet {
    private lazy var mainStackView = builder(UIStackView.self) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fill
        $0.alignment = .fill
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private var padding: UIEdgeInsets {
        UIEdgeInsets(all: 8)
    }
    
    init(with contentTypes: [EditItemActionType]) {
        super.init(sheetType: .fixed)
        
        contentTypes.forEach { type in
            let view = LeftImageRightVerticalTitle()
            view.build {
                $0.image = type.image?.withTintColor(type.color, renderingMode: .alwaysOriginal)
                $0.titleText = type.name
                $0.titleColor = type.color
                $0.spacingIconAndText = 20
                $0.separatorHidden = false
            }
            
            view.selectHandler = { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true, withInfo: ["type": type], completion: nil)
            }
            
            mainStackView.addArrangedSubview(view)
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func initialSetup() {
        super.initialSetup()
        setupView()
    }
    
    private func setupView() {
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(padding)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }
}
