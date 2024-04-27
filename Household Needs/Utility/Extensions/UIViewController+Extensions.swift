//
//  UIViewController+Extensions.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 12/12/23.
//

import Foundation
import UIKit
import MFRBottomSheet

extension UIViewController {
    func showAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

extension UIViewController {
    
    @discardableResult
    func showVerificationCard(
        delegate: MFRBaseBottomSheetDelegate?,
        model: VerificationCard.ViewModel
    ) -> MFRBaseBottomSheet {
        let card = VerificationCard(with: model)
        card.delegate = delegate
        
        let cardController = MFRBottomSheetController(bottomSheet: card, isPortraitOnly: true)
        cardController.show(from: self, animated: true, completion: nil)
        return card
    }
    
    @discardableResult
    func showVerificationCard(
        delegate: MFRBaseBottomSheetDelegate?,
        build: (inout VerificationCard.ViewModel) -> Void
    ) -> MFRBaseBottomSheet {
        var model = VerificationCard.ViewModel()
        build(&model)
        return showVerificationCard(delegate: delegate, model: model)
    }
    
    @discardableResult
    func showVerificationCard(
        delegate: MFRBaseBottomSheetDelegate?,
        with model: VerificationCard.ViewModel = .init()
    ) -> MFRBaseBottomSheet {
        return showVerificationCard(delegate: delegate, model: model)
    }
    
    @discardableResult
    func showEditItemCard(with types: [EditItemActionType], delegate: MFRBaseBottomSheetDelegate?) -> MFRBaseBottomSheet {
        let card = EditItemCard(with: types)
        card.delegate = delegate
        
        let cardController = MFRBottomSheetController(bottomSheet: card, isPortraitOnly: true)
        cardController.show(from: self, animated: true, completion: nil)
        return card
    }
}
