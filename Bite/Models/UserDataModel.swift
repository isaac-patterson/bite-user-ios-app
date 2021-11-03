//
//  UserDataModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 04/08/21.
//

import Foundation
import UIKit
import SwiftUI

class UserDataModel: ObservableObject,Identifiable {
    
    struct UserData {
        var name: String!
        var phoneNumber: String!
        var email_verified: Bool!
        var phone_number_verified: Bool!
        var preferredUsername: String!
        var email: String!
        var sub: String!
        var last_name: String!
        var first_name: String!
        var birthDate: String!
        var profile_image: UIImage!
    }
    
    @Published var data = UserData()
    
    init() {
        data.name = ""
        data.phoneNumber = ""
        data.email_verified = false
        data.phone_number_verified = false
        data.preferredUsername = ""
        data.email = ""
        data.sub = ""
        data.last_name = ""
        data.first_name = ""
        data.birthDate = ""
        data.profile_image = UIImage(named: "ProfilePlaceholder_large")

    }
    
    static var shared = UserDataModel()
}
