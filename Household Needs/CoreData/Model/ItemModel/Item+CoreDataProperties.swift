//
//  Item+CoreDataProperties.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 08/12/23.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var itemID: String?
    @NSManaged public var itemName: String?
    @NSManaged public var itemPrice: Double
    @NSManaged public var itemQunatity: Int64
    @NSManaged public var itemType: String?
    @NSManaged public var periodID: String?

}

extension Item {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.itemID == rhs.itemID &&
        lhs.itemQunatity == rhs.itemQunatity &&
        lhs.itemName == rhs.itemName &&
        lhs.itemPrice == rhs.itemPrice &&
        lhs.itemType == rhs.itemType
    }
}

extension Item: Identifiable {
    
}
