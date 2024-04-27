//
//  UIApplication+Extensions.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 12/12/23.
//

import Foundation
import UIKit

public extension UIApplication {
    static var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            let foregroundWindowScene = self.shared.connectedScenes.first(where: { $0.isKind(of: UIWindowScene.self) && $0.activationState == .foregroundActive }) as? UIWindowScene
            return foregroundWindowScene?.windows.first(where: { $0.isKeyWindow })
        } else {
            // Deprecated in iOS 15
            return self.shared.windows.first(where: { $0.isKeyWindow })
        }
    }
}
