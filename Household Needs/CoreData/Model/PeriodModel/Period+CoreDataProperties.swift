//
//  Period+CoreDataProperties.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 08/12/23.
//
//

import Foundation
import CoreData


extension Period {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Period> {
        return NSFetchRequest<Period>(entityName: "Period")
    }

    @NSManaged public var period: String?
    @NSManaged public var periodID: String?
    @NSManaged public var timestamp: Double
    @NSManaged public var totalSpend: Double

}

extension Period {
    var getYear: String {
        return Date(timeIntervalSince1970: timestamp).getYear
    }
    
    var getMonth: String {
        return Date(timeIntervalSince1970: timestamp).getMonth
    }
}

extension Period: Identifiable {

}
