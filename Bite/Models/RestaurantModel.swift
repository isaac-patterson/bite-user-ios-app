//
//  RestaurantModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 26/07/21.
//

import Foundation

struct RestaurantModel: Codable {
    var name: String
    var address: String
    var countryCode: String
    var createdDate: String
    var description: String
    var restaurantId: String
    var category: String
    var logoIcon: String
    var offer: Float?
    var restaurantOpenDays: [RestaurantOpenDaysModel]?
    
   
}

struct RestaurantModelData: Codable {
    var data: [RestaurantModel]
    var message: String
}

struct RestaurantOpenDaysModel: Codable {
    var closeTime : OpenCloseTimeModel
    var createdDate : String
    var day : String
    var id : Int
    var isOpen : Bool
    var openTime : OpenCloseTimeModel
    var restaurantId : String
}

struct OpenCloseTimeModel: Codable {
    
    var days : Int?
    var hours : Int?
    var milliseconds : Int?
    var minutes : Int?
    var seconds : Int?
    var ticks : Int?
    var totalDays : Float?
    var totalHours : Float?
    var totalMilliseconds : Int?
    var totalMinutes : Int?
    var totalSeconds : Int?

}
extension RestaurantModel: Identifiable {
    var id: String { return restaurantId}
}
