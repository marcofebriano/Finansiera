//
//  ListOfGroceryVM.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 08/12/23.
//

import Foundation

protocol ListOfGroceryVMDelegate: AnyObject {
    func shouldUpdateTotalSpend(periodID: String, grandTotal: Double)
}

protocol GroceryVM: AnyObject {
    var listenDataTable: ((_ datas: [Item], _ type: String) -> Void)? { get set}
    var listenDatas: (([Item]) -> Void)? { get set }
    func getItemData()
    func saveNewItem(from model: GroceryModel)
    func updateItem(from model: GroceryModel)
    func deleteItem(itemID: String)
    func selectedPieChart(_ type: String)
    func nothingSelectedPieChart()
    func openToDoListPage()
    func didDisappear()
    func searchItem(text: String)
}

class ListOfGroceryVM: GroceryVM {
    
    
    private var periodID: String
    private var datas: [Item] = [] {
        didSet {
            listenDatas?(datas)
        }
    }
    
    var listenDataTable: ((_ datas: [Item], _ type: String) -> Void)?
    
    var listenDatas: (([Item]) -> Void)?
    
    weak var delegate: ListOfGroceryVMDelegate?
    
    private var itemService: ItemService
    private var router: GroceryRouting
    
    init(router: GroceryRouting, periodID: String, itemService: ItemService = ItemServiceManager()) {
        self.router = router
        self.itemService = itemService
        self.periodID = periodID
    }
    
    func getItemData() {
        itemService.getDataItems(from: periodID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let datas):
                guard let datas = datas else { return }
                self.datas = datas
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func saveNewItem(from model: GroceryModel) {
        itemService.addedItemToCoreData { item in
            item.itemID = model.groceryID
            item.itemName = model.itemName
            item.itemPrice = model.price
            item.itemQunatity = Int64(model.quantity)
            item.itemType = model.itemType
            item.periodID = self.periodID
        } completion: { [weak self] result in
            switch result {
            case .success:
                self?.getItemData()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func updateItem(from model: GroceryModel) {
        itemService.updateItem(itemID: model.groceryID) { item in
            item.itemName = model.itemName
            item.itemPrice = model.price
            item.itemQunatity = Int64(model.quantity)
            item.itemType = model.itemType
        } completion: { [weak self] result in
            switch result {
            case .success:
                self?.getItemData()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func deleteItem(itemID: String) {
        itemService.deleteItem(itemID: itemID, completion: { [weak self] result in
            switch result {
            case .success:
                self?.getItemData()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    func selectedPieChart(_ type: String) {
        let types = HouseholdConstant.itemType
        let typeSelected = types.filter { $0.value == type }.first
        guard let typeSelected = typeSelected else { return }
        let copyDatas: [Item] = datas
            .compactMap { $0 }
            .filter { ($0.itemType ?? "") == typeSelected.key }
        listenDataTable?(copyDatas, type)
        
    }
    
    func nothingSelectedPieChart() {
        listenDataTable?(datas, "")
    }
    
    func openToDoListPage() {
        router.pushToToDoListPage(.push(animated: true), periodID: periodID)
    }
    
    func didDisappear() {
        let inTotals = datas.compactMap({ Double($0.itemQunatity) * $0.itemPrice })
        let grandTotal = inTotals.sum
        delegate?.shouldUpdateTotalSpend(periodID: periodID, grandTotal: grandTotal)
    }
    
   func searchItem(text: String) {
        guard text.count > 0 else {
            listenDatas?(datas)
            return
        }
        let copyDatas: [Item] = datas
           .filter { ($0.itemName ?? "").contains(text) }
       listenDatas?(copyDatas)
    }
}
