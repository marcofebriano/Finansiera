//
//  FeatureRouting.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 08/12/23.
//

import Foundation
import UIKit

protocol ListOfPeriodRouting: Routing {
    func pushToListOfGrocery(_ type: RouteType, data periodID: String, delegate: ListOfGroceryVMDelegate?)
}

class ListOfPeriodRouter: ListOfPeriodRouting {
    
    weak var baseViewController: UIViewController?
    
    func pushToListOfGrocery(_ type: RouteType, data periodID: String, delegate: ListOfGroceryVMDelegate?) {
        let groceryVc = ListOfGroceryVC()
        let router = GroceryRouter()
        router.baseViewController = groceryVc
        let groceryVM = ListOfGroceryVM(router: router, periodID: periodID)
        groceryVM.delegate = delegate
        groceryVc.viewModel = groceryVM
        route(type, for: groceryVc)
    }
}
