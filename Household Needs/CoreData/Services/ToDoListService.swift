//
//  ToDoListService.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 13/12/23.
//

import Foundation
import CoreData

protocol ToDoListService: AnyObject {
    func deleteItem(toDoListID: String, completion: @escaping RequestResult)
    func getDataToDoList(from periodID: String, completion: @escaping FetchResult<ToDoList>)
    func addedItemToCoreData(setupData build: ((inout ToDoList) -> Void), completion: @escaping RequestResult)
    func updateItem(toDoListID: String, update: (inout ToDoList) -> Void, completion: @escaping RequestResult)
    func deleteAllItem(periodID: String, completion: @escaping RequestResult)
}

class ToDoListServiceManager: BaseCoreData, ToDoListService {
    var manager: CoreDataManager {
        CoreDataManager.shared
    }
    
    func getDataToDoList(from periodID: String, completion: @escaping FetchResult<ToDoList>) {
        let request: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        request.predicate = NSPredicate(format: "periodID = %@", periodID)
        fetch(request: request, completion: completion)
    }
    
    func addedItemToCoreData(setupData build: ((inout ToDoList) -> Void), completion: @escaping RequestResult) {
        var itemModel = ToDoList(context: manageContext)
        build(&itemModel)
        self.create(completion: completion)
    }
    
    func updateItem(toDoListID: String, update: (inout ToDoList) -> Void, completion: @escaping RequestResult) {
        let predicate2 = NSPredicate(format: "toDoListID = %@", toDoListID)
        let request: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        request.predicate = predicate2
        self.update(request: request, update: update, completion: completion)
    }
    
    func deleteItem(toDoListID: String, completion: @escaping RequestResult) {
        let request: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        request.predicate = NSPredicate.init(format: "toDoListID = %@", "\(toDoListID)")
        self.delete(request: request, completion: completion)
    }
    
    func deleteAllItem(periodID: String, completion: @escaping RequestResult) {
        let request: NSFetchRequest<ToDoList> = ToDoList.fetchRequest()
        request.predicate = NSPredicate.init(format: "periodID = %@", "\(periodID)")
        self.deleteAll(request: request, completion: completion)
    }
}
