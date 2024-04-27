//
//  ListOfPeriodDeleteHelper.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 15/12/23.
//

import Foundation

protocol PeriodDeleteHelper {
    func deletePeriod(periodID: String, completion: @escaping RequestResult)
}

class ListOfPeriodDeleteHelper: PeriodDeleteHelper {
    
    var periodService: PeriodService
    var todolistService: ToDoListService
    var ItemService: ItemService
    
    init(_ periodService: PeriodService,
         _ todolistService: ToDoListService,
         _ ItemService: ItemService
    ) {
        self.periodService = periodService
        self.todolistService = todolistService
        self.ItemService = ItemService
    }
    
    func deletePeriod(periodID: String, completion: @escaping RequestResult) {
        deleteTodolist(periodID: periodID, completion: completion)
    }
    
    private func deleteTodolist(periodID: String, completion: @escaping RequestResult) {
        todolistService.deleteAllItem(periodID: periodID) { [weak self] result in
            switch result {
            case .success:
                debugPrint("success delete all todolist")
                self?.deleteItem(periodID: periodID, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func deleteItem(periodID: String, completion: @escaping RequestResult) {
        ItemService.deleteAllItem(periodID: periodID) { [weak self] result in
            switch result {
            case .success:
                debugPrint("success delete all item")
                self?.deleteSpecificPeriod(periodID: periodID, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func deleteSpecificPeriod(periodID: String, completion: @escaping RequestResult) {
        periodService.deletePeriod(periodID: periodID, completion: completion)
    }
}
