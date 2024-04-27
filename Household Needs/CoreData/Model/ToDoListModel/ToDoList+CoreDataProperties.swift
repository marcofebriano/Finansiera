//
//  ToDoList+CoreDataProperties.swift
//  Finansiera
//
//  Created by Marco Febriano Ramadhani on 13/12/23.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var toDoListID: String
    @NSManaged public var itemName: String
    @NSManaged public var periodID: String
    @NSManaged public var listType: String

}

extension ToDoList : Identifiable {

}
