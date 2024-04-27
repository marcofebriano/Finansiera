//
//  GroceryRouting.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 13/12/23.
//

import Foundation
import UIKit

protocol GroceryRouting: Routing {
    func pushToToDoListPage(_ type: RouteType, periodID: String)
}

class GroceryRouter: GroceryRouting {
    
    weak var baseViewController: UIViewController?
    
    func pushToToDoListPage(_ type: RouteType, periodID: String) {
        let todolistVC = ToDoListVC()
        let todolistVM = ToDoListViewModel(periodID: periodID)
        todolistVC.viewModel = todolistVM
        route(type, for: todolistVC)
    }
}
