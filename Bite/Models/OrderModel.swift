//
//  OrderModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 29/07/21.
//

import Foundation
import UIKit

struct OrderModel: Codable {
    var restaurantId: String
    var menuItemId: Int
    var category: String
    var name: String
    var description: String
    var price: Float
    var createdDate: String
    var availableOptionsCount: Int
    var offerPrice: Float
    var quantity: Int
    var finalPrice: CGFloat
    var orderItemOptions: [[String:String]]?
    var localId: Int?
}

extension OrderModel: Identifiable {
    var id: Int { return localId! }
}
