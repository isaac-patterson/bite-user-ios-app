//
//  MenuModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 27/07/21.
//

import Foundation

struct MenuModel: Codable {
    var restaurantId: String?
    var menuItemId: Int?
    var category: String?
    var name: String?
    var description: String?
    var price: Float?
    var createdDate: String?
    var menuItemOptions: [MenuItemOptionModel] = []
    //var availableOptionsCount: Int = 0
    //var offerPrice: Int
  
}

struct MenuItemOptionModel: Codable {
    var menuItemOptionId: Int
    var menuItemId: Int
    var name: String
    var menuItemOptionValues: [MenuItemOptionValueModel] = []
}

struct MenuItemOptionValueModel: Codable {
    var menuItemOptionValueId: Int
    var menuItemOptionId: Int
    var name: String
    var price: Float?
}

extension MenuModel: Identifiable {
    var id: Int {return menuItemId! }
}

extension MenuItemOptionModel: Identifiable {
    var id: Int {return menuItemOptionId }
}

extension MenuItemOptionValueModel: Identifiable {
    var id: Int {return menuItemOptionValueId }
}
