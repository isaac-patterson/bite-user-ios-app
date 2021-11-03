//
//  OrderStatusModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 01/09/21.
//

import Foundation
import UIKit

class OrderStatusModel: ObservableObject,Identifiable {
    
    struct OrderStatusData {
        var orderId: Int!
        var pickupDate: String!
        var pickupName: String!
        var status: String!
    }
    
    @Published var data = OrderStatusData()
    
    init() {
        data.orderId = 0
        data.pickupDate = ""
        data.pickupName = ""
        data.status = ""
    }
    
    static var shared = OrderStatusModel()
  

}

