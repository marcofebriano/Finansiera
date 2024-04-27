//
//  Routing.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 08/12/23.
//

import Foundation
import UIKit

public enum RouteType {
    case push(animated: Bool)
    case present(animated: Bool)
}

public protocol Routing {
    var baseViewController: UIViewController? { get set }
}

public extension Routing {
    func route(_ type: RouteType, for viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let baseViewController = self.baseViewController else { return }
        switch type {
        case .push(animated: let animated):
            guard let navigation = baseViewController.navigationController else { return }
            navigation.pushViewController(viewController, animated: animated)
        case .present(animated: let animated):
            viewController.modalPresentationStyle = .fullScreen
            baseViewController.present(viewController, animated: animated, completion: completion)
        }
    }
}
