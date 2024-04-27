//
//  CommonViewController.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 08/12/23.
//

import Foundation
import UIKit

open class CommonViewController: UIViewController {
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        self.navigationController?.navigationBar.tintColor = .black
    }
}
