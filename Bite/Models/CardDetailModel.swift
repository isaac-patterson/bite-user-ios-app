//
//  CardDetailModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 09/08/21.
//

import Foundation
import UIKit

struct CardDetailModel: Codable {
    var brand : String
    var expMonth : Int
    var expYear : Int
    var id : Int
    var last4 : String
    var type : String
}

struct CardDetailModelData: Codable {
    var data : [CardDetailModel]
    var message : String
}

extension CardDetailModel: Identifiable {
    var idcard: Int { return id }

}
