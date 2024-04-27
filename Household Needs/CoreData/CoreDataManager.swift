//
//  CoreDataManager.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 06/12/23.
//

import Foundation
import CoreData

typealias FetchResult<T: NSManagedObject> = (Result<[T]?, Error>) -> Void
typealias RequestResult = (Result<Bool, Error>) -> Void

protocol BaseCoreDataService: AnyObject {
    var manager: CoreDataManager { get }
}

protocol BaseCoreData: BaseCoreDataService {
    var manageContext: NSManagedObjectContext { get }
}

extension BaseCoreData {
    var manageContext: NSManagedObjectContext {
        manager.manageContext
    }
    
    func create(completion: @escaping RequestResult) {
        do {
            try manageContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>, completion: @escaping (Result<[T]?, Error>) -> Void) {
        do {
            let datas = try manageContext.fetch(request)
            completion(.success(datas))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func update<T: NSManagedObject>(
        request: NSFetchRequest<T>,
        update: (inout T) -> Void,
        completion: @escaping RequestResult
    ) {
        do {
            let fetch = try manageContext.fetch(request)
            guard var dataToUpdate = fetch.first else {
                debugPrint("data not found!")
                let error = NSError(domain: HouseholdConstant.bundleID, code: -1)
                completion(.failure(error))
                return
            }
            update(&dataToUpdate)
            try manageContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func delete<T: NSManagedObject>(request: NSFetchRequest<T>, completion: @escaping RequestResult) {
        do {
            let fetch = try manageContext.fetch(request)
            guard let dataToDelete = fetch.first else {
                debugPrint("data not found!")
                let error = NSError(domain: HouseholdConstant.bundleID, code: -1)
                completion(.failure(error))
                return
            }
            manageContext.delete(dataToDelete)
            try manageContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteAll<T:NSManagedObject>(request: NSFetchRequest<T>, completion: @escaping RequestResult) {
        do {
            let fetch = try manageContext.fetch(request)
            fetch.forEach {
                manageContext.delete($0)
            }
            try manageContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}

class CoreDataManager: NSObject {
    
    static var shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer?
    
    var manageContext: NSManagedObjectContext {
        guard let context = persistentContainer?.viewContext else {
            fatalError("recheck when init persistentContainer!")
        }
        return context
    }
    
    override init() {
        super.init()
        self.setupPersistentContainer(with: "coredata_householdNeeds")
    }
    
    private func setupPersistentContainer(with name: String) {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.persistentContainer = container
    }
    
    // MARK: - Core Data Saving support
    func save () {
        if manageContext.hasChanges {
            do {
                try manageContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("❗️Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
