//
//  UITableView+Extensions.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation
import UIKit

public extension UITableViewCell {
    static var defaultReuseIdentifier: String { String(describing: Self.self) }
}

public extension UITableViewHeaderFooterView {
    static var defaultReuseIdentifier: String { String(describing: Self.self) }
}

public extension UITableView {
    
    func register<Cell: UITableViewCell>(_ type: Cell.Type) {
        self.register(Cell.self, forCellReuseIdentifier: Cell.defaultReuseIdentifier)
    }
    
    func registerHeaderFooter<View: UITableViewHeaderFooterView>(_ type: View.Type) {
        self.register(View.self, forHeaderFooterViewReuseIdentifier: View.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(_ type: Cell.Type, for indexPath: IndexPath) -> Cell? {
        dequeueReusableCell(withIdentifier: Cell.defaultReuseIdentifier, for: indexPath) as? Cell
    }
    
    func dequeueReusableHeaderFooter<View: UITableViewHeaderFooterView>(_ type: View.Type) -> View? {
        self.dequeueReusableHeaderFooterView(withIdentifier: View.defaultReuseIdentifier) as? View
    }
}

public extension UITableView {
    func contextualActionImage(
        style: UIContextualAction.Style,
        backgroundColor: UIColor? = nil,
        image: UIImage?,
        action: (() -> Void)? = nil
    ) -> UIContextualAction {
        
        let contextAction = UIContextualAction(style: style, title: nil) { _, _, completion in
            action?()
            completion(true)
        }
        contextAction.image = image
        if let backgroundColor = backgroundColor {
            contextAction.backgroundColor = backgroundColor
        }
        return contextAction
    }
    
    func contextualActionTitle(
        style: UIContextualAction.Style,
        title: String,
        backgroundColor: UIColor? = nil,
        action: (() -> Void)? = nil
    ) -> UIContextualAction {
        
        let contextAction = UIContextualAction(style: style, title: title) { _, _, completion in
            action?()
            completion(true)
        }
        if let backgroundColor = backgroundColor {
            contextAction.backgroundColor = backgroundColor
        }
        return contextAction
    }
}
