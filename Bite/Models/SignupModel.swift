//
//  SignupModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 19/07/21.
//

import Foundation

class SignupModel: ObservableObject {
    
    struct SignupData {
        var mobileNumber: String!
        var schoolEmail: String!
        var email: String!
        var username: String!
        var password: String!
        var bithDate: String!
        var firstName: String!
        var lastName: String!
    }
    
    @Published var data = SignupData()
    
    init() {
        data.mobileNumber = ""
        data.schoolEmail = ""
        data.email = ""
        data.username = ""
        data.password = ""
        data.bithDate = ""
        data.firstName = ""
        data.lastName = ""
    }
    
    static var shared = SignupModel()
}
