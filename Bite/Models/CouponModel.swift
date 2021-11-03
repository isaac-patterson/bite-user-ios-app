//
//  CouponModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 30/07/21.
//

import Foundation
import UIKit

struct CouponModel: Codable {
    var couponId: Int
    var createdDate: String
    var expiryDate: String
    var discount: Int
    var discountCode: String
}

struct CouponModelData: Codable {
    var data : CouponModel
    var message: String
}
