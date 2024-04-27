//
//  ItemService.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 15/12/23.
//

import Foundation
import CoreData

protocol ItemService: AnyObject {
    func getDataItems(from periodID: String, completion: @escaping FetchResult<Item>)
    func addedItemToCoreData(setupData build: ((inout Item) -> Void), completion: @escaping RequestResult)
    func updateItem(itemID: String, update: (inout Item) -> Void, completion: @escaping RequestResult)
    func deleteItem(itemID: String, completion: @escaping RequestResult)
    func deleteAllItem(periodID: String, completion: @escaping RequestResult)
}

class ItemServiceManager: BaseCoreData, ItemService {
    var manager: CoreDataManager {
        CoreDataManager.shared
    }
    
    func getDataItems(from periodID: String, completion: @escaping FetchResult<Item>) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "periodID = %@", periodID)
        fetch(request: request, completion: completion)
    }
    
    func addedItemToCoreData(setupData build: ((inout Item) -> Void), completion: @escaping RequestResult) {
        var itemModel = Item(context: manageContext)
        build(&itemModel)
        self.create(completion: completion)
    }
    
    func updateItem(itemID: String, update: (inout Item) -> Void, completion: @escaping RequestResult) {
//        let predicate1 = NSPredicate(format: "period = %@", period)
        let predicate2 = NSPredicate(format: "itemID = %@", itemID)
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = predicate2
//        request.predicate = NSCompoundPredicate.init(type: .and, subpredicates: [predicate1, predicate2])
        self.update(request: request, update: update, completion: completion)
    }
    
    func deleteItem(itemID: String, completion: @escaping RequestResult) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate.init(format: "itemID = %@", "\(itemID)")
        self.delete(request: request, completion: completion)
    }
    
    func deleteAllItem(periodID: String, completion: @escaping RequestResult) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate.init(format: "periodID = %@", "\(periodID)")
        self.deleteAll(request: request, completion: completion)
    }
}
