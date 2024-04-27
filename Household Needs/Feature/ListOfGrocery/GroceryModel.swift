//
//  GroceryModel.swift
//  Household Needs
//
//  Created by Marco Febriano Ramadhani on 27/11/23.
//

import Foundation

public struct GroceryModel: Codable, Hashable, Equatable {
    var groceryID: String
    var itemName: String
    var itemType: String
    var price: Double
    var quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case groceryID
        case itemName
        case price
        case quantity
        case itemType
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(groceryID)
    }
    
    public static func == (lhs: GroceryModel, rhs: GroceryModel) -> Bool {
        return lhs.groceryID == rhs.groceryID
    }
}
