//
//  ListOfPeriodVM.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 07/12/23.
//

import Foundation

enum PeriodState {
    case showData(_ period: [Period])
    case updateChart(_ period: [Period])
    case error(_ message: String)
}

protocol periodVM: AnyObject {
    var sections: [PeriodSection] { get }
    var listenData: ((PeriodState) -> Void)? { get set }
    func fetchPeriod()
    func createNewPeriod(from date: Date)
    func deleteData(periodID: String)
    func pushToListOfGrocery(periodID: String)
    func getSumOfTheYear(from section: Int) -> Double
    func updateChartDataBased(_ year: String)
}

class ListOfPeriodVM: periodVM {
    
    private var data: [Period] = [] {
        didSet {
            listenData?(.showData(data))
        }
    }
    
    var listenData: ((PeriodState) -> Void)?
    
    var sections: [PeriodSection] {
        let setSection = Set(data.compactMap { $0.getYear })
        return setSection.sorted(by: >).compactMap { return PeriodSection(title: $0) }
    }
    
    private var router: ListOfPeriodRouting
    private var periodService: PeriodService
    private var itemService: ItemService
    private var todolistService: ToDoListService
    private var periodDeletionHelper: PeriodDeleteHelper
    
    init(router: ListOfPeriodRouting, 
         periodService: PeriodService = PeriodServiceManager(),
         itemService: ItemService = ItemServiceManager(),
         todolistService: ToDoListService = ToDoListServiceManager()
    ) {
        self.router = router
        self.periodService = periodService
        self.itemService = itemService
        self.todolistService = todolistService
        self.periodDeletionHelper = ListOfPeriodDeleteHelper(periodService, todolistService, itemService)
    }
    
    func fetchPeriod() {
        periodService.getDataPeriods(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let periods = data else { return }
                self.data = periods
                
                guard let latestYear = self.data.first?.getYear else { return }
                self.updateChartDataBased(latestYear)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        })
    }
    
    func createNewPeriod(from date: Date) {
        let text = date.asPeriodName
        dataEligibleToSave(text: text) { [weak self] isEligible in
            if isEligible {
                self?.saveNewPeriod(text: text, timestamp: date.timeIntervalSince1970)
            } else {
                self?.listenData?(.error("Periode itu udah pernah dipilih ges!"))
            }
        }
    }
    
    func deleteData(periodID: String) {
        periodDeletionHelper.deletePeriod(periodID: periodID) { [weak self] result in
            switch result {
            case .success:
                self?.fetchPeriod()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func pushToListOfGrocery(periodID: String) {
        router.pushToListOfGrocery(.push(animated: true), data: periodID, delegate: self)
    }
    
    func getSumOfTheYear(from section: Int) -> Double {
        let year = sections[section].title
        let colTotalSpend: [Double] = data.compactMap { each in
            guard each.getYear == year else { return nil }
            return each.totalSpend
        }
        return colTotalSpend.sum
    }
    
    func updateChartDataBased(_ year: String) {
         guard year.count > 0 else {
             listenData?(.updateChart(data))
             return
         }
         let copyDatas: [Period] = data
            .filter { $0.getYear.contains(year) }
        listenData?(.updateChart(copyDatas))
     }
}

extension ListOfPeriodVM {
    private func dataEligibleToSave(text: String, isEligible: ((Bool) -> Void)?) {
        periodService.checkDataPeriod(period: text, completion: { result in
            switch result {
            case .success(let periods):
                if periods == nil {
                    isEligible?(true)
                } else if let periods = periods {
                    let eligible: Bool =
                        if periods.isEmpty { true }
                        else if periods.first?.period != text { true }
                        else { false }
                    isEligible?(eligible)
                } else {
                    isEligible?(false)
                }
                
            default:
                debugPrint("fail check!")
                isEligible?(false)
            }
        })
    }
    
    private func saveNewPeriod(text: String, timestamp: Double) {
        periodService.addedPeriodToCoreData(text, timestamp, completion: { [weak self] result in
            switch result {
            case .success:
                self?.fetchPeriod()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        })
    }
}

extension ListOfPeriodVM: ListOfGroceryVMDelegate {
    func shouldUpdateTotalSpend(periodID: String, grandTotal: Double) {
        periodService.updatePeriod(periodID: periodID, update: { period in
            period.totalSpend = grandTotal
        }, completion: { [weak self] result in
            switch result {
            case .success:
                self?.fetchPeriod()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        })
    }
}
