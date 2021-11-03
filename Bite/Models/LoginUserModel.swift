//
//  LoginUserModel.swift
//  Bite
//
//  Created by Ravi kant Tiwari on 23/07/21.
//

import Foundation

class LoginUserModel: ObservableObject {
    
    struct LoginData {
        var user_id: String!
        var user_idWORegionStr: String!
        var idToken: String!
        var accessToken: String!
        var refreshToken: String!
    }
    
    @Published var data = LoginData()
    
    init() {
        data.user_id = ""
        data.user_idWORegionStr = ""
        data.idToken = ""
        data.accessToken = ""
        data.refreshToken = ""
    }
    
    static var shared = LoginUserModel()
}
