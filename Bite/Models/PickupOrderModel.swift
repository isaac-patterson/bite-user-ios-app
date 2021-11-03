//
//  PickupOrderModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 10/08/21.
//

import Foundation
import UIKit

struct PickupOrderModel: Codable {
    
    var cognitoUserId: String
    var createdDate: String
    var currency: String
    var notes: String?
    var orderId: Int
    var pickupDate: String?
    var pickupName: String?
    var restaurantId: String
    var status: String
    var total: Float?
    var orderItems: [OrderItemsModel] = []
    var restaurantInfo: RestaurantModel?

}

struct PickupOrderModelData: Codable {
    var data : [PickupOrderModel]
    var message : String
}

struct OrderDetailModelData: Codable {
    var data : PickupOrderModel
    var message : String
}

struct OrderItemsModel: Codable {
    var price : Float?
    var name : String?
    var orderId : Int?
    var orderItemId : Int?
    var orderItemOptions : [OrderItemOptionsModel]?
}

struct OrderItemOptionsModel: Codable {
    var name : String
    var orderItemId : Int
    var orderItemOptionId : Int
    var price : Float?
    var value : String?
}

extension OrderItemsModel: Identifiable{
    var id: Int { return orderItemId!}
}

extension PickupOrderModel: Identifiable{
    var id: Int { return orderId}
}
