//
//  PeriodService.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 14/12/23.
//

import Foundation
import CoreData

protocol PeriodService: AnyObject {
    func checkDataPeriod(period: String, completion: @escaping FetchResult<Period>)
    func getDataPeriods(completion: @escaping FetchResult<Period>)
    func addedPeriodToCoreData(_ period: String, _ timestamp: Double, completion: @escaping RequestResult)
    func updatePeriod(periodID: String, update: (inout Period) -> Void, completion: @escaping RequestResult)
    func deletePeriod(periodID: String, completion: @escaping RequestResult)
}


class PeriodServiceManager: BaseCoreData, PeriodService {
    var manager: CoreDataManager {
        CoreDataManager.shared
    }
    
    func checkDataPeriod(period: String, completion: @escaping FetchResult<Period>) {
        let request: NSFetchRequest<Period> = Period.fetchRequest()
        request.predicate = NSPredicate(format: "period = %@", period)
        fetch(request: request, completion: completion)
    }
    
    func getDataPeriods(completion: @escaping FetchResult<Period>) {
        let request: NSFetchRequest<Period> = Period.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetch(request: request, completion: completion)
    }
    
    func addedPeriodToCoreData(_ period: String, _ timestamp: Double, completion: @escaping RequestResult) {
        let periodModel = Period(context: manageContext)
        periodModel.period = period
        periodModel.periodID = UUID().uuidString
        periodModel.timestamp = timestamp
        self.create(completion: completion)
    }
    
    func updatePeriod(periodID: String, update: (inout Period) -> Void, completion: @escaping RequestResult) {
        let request: NSFetchRequest<Period> = Period.fetchRequest()
        request.predicate = NSPredicate.init(format: "periodID = %@", "\(periodID)")
        self.update(request: request, update: update, completion: completion)
    }
    
    func deletePeriod(periodID: String, completion: @escaping RequestResult) {
        let request: NSFetchRequest<Period> = Period.fetchRequest()
        request.predicate = NSPredicate.init(format: "periodID = %@", "\(periodID)")
        self.delete(request: request, completion: completion)
    }
}
