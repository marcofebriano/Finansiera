//
//  ToDoListVM.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 13/12/23.
//

import Foundation

public enum ToDoListViewState {
    case success(_ datas: [ToDoList])
    case search(_ datas: [ToDoList])
    case error(_ message: String)
}

public protocol ToDoListVM: AnyObject {
    var sections: [PeriodSection] { get }
    var listenStateChange: ((ToDoListViewState) -> Void)? { get set }
    func getData()
    func searchItem(text: String)
    func saveTodoList(itemName: String)
    func deleteItem(todolistID: String)
    func updateItem(todolistID: String, newName: String)
    func saveToCart(from model: GroceryModel, todolistID: String)
}

public class ToDoListViewModel: ToDoListVM {
    
    public var listenStateChange: ((ToDoListViewState) -> Void)?
    
    public var sections: [PeriodSection] {
        return [
            .init(title: "list"),
            .init(title: "cart")
        ]
    }
    
    private var todolistService: ToDoListService
    private var itemService: ItemService
    private var periodID: String
    private var datas: [ToDoList] = []
    
    init(periodID: String, 
         todolistService: ToDoListService = ToDoListServiceManager(),
         itemService: ItemService = ItemServiceManager()
    ) {
        self.periodID = periodID
        self.todolistService = todolistService
        self.itemService = itemService
    }
    
    public func getData() {
        todolistService.getDataToDoList(from: periodID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let datas):
                guard let datas = datas else { return }
                self.datas = datas
                self.listenStateChange?(.success(datas))
            case .failure:
                let msg = "Gagal nih ngambil datanya :("
                self.listenStateChange?(.error(msg))
            }
        }
    }
    
    public func saveTodoList(itemName: String) {
        todolistService.addedItemToCoreData(setupData: {
            $0.periodID = periodID
            $0.itemName = itemName
            $0.listType = "list"
            $0.toDoListID = UUID().uuidString
        }, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.getData()
            case .failure:
                let msg = "gagal nih nyimpen datanya :("
                self.listenStateChange?(.error(msg))
            }
        })
    }
    
    public func deleteItem(todolistID: String) {
        todolistService.deleteItem(toDoListID: todolistID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let msg = "Yeay!!! Datanya udah kehapus nih"
                self.listenStateChange?(.error(msg))
                self.getData()
            case .failure:
                let msg = "gagal nih ngapus datanya :("
                self.listenStateChange?(.error(msg))
            }
        }
    }
    
    public func updateItem(todolistID: String, newName: String) {
        todolistService.updateItem(toDoListID: todolistID, update: { data in
            data.itemName = newName
        }, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let msg = "Yeay!!! Datanya terupdate nih."
                self.listenStateChange?(.error(msg))
                self.getData()
            case .failure:
                let msg = "gagal nih ngapus datanya :("
                self.listenStateChange?(.error(msg))
            }
        })
    }
    
    public func saveToCart(from model: GroceryModel, todolistID: String) {
        saveToItemCoreData(with: model, and: todolistID)
    }
    
    public func searchItem(text: String) {
        guard text.count > 0 else {
            listenStateChange?(.success(datas))
            return
        }
        let copyDatas: [ToDoList] = datas
            .filter { $0.itemName.contains(text) }
        listenStateChange?(.search(copyDatas))
    }
}

extension ToDoListViewModel {
    private func saveToItemCoreData(with model: GroceryModel, and todolistID: String) {
        itemService.addedItemToCoreData(setupData: { item in
            item.itemID = model.groceryID
            item.itemName = model.itemName
            item.itemPrice = model.price
            item.itemQunatity = Int64(model.quantity)
            item.itemType = model.itemType
            item.periodID = self.periodID
        }, completion: { [weak self] result in
            switch result {
            case .success:
                self?.updateTypeTodolist(todolistID: todolistID)
            case .failure:
                let msg = "gagal nih nyimpen datanya :("
                self?.listenStateChange?(.error(msg))
            }
        })
    }
    
    private func updateTypeTodolist(todolistID: String) {
        todolistService.updateItem(toDoListID: todolistID) { item in
            item.listType = "cart"
        } completion: { [weak self] result in
            switch result {
            case .success:
                self?.getData()
            case .failure:
                let msg = "gagal nih nyimpen datanya :("
                self?.listenStateChange?(.error(msg))
            }
        }

    }
}
