//
//  login_request_model.swift
//  DE Grocery
//
//  Created by Eren Demir on 21.05.2022.
//

import Foundation

class LoginRequestModel {
    
    var email:String?
    var password:String?
    
    init(email:String,password:String) {
        self.email = email
        self.password = password
    }
}
