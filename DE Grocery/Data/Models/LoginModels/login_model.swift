//
//  login_model.swift
//  DE Grocery
//
//  Created by Eren Demir on 21.05.2022.
//

import Foundation

class LoginResponseModel: Codable {
    var status: Int?
    var message, path: String?
    var model: [LoginModel]?

    init(status: Int?, message: String?, path: String?, model: [LoginModel]?) {
        self.status = status
        self.message = message
        self.path = path
        self.model = model
    }
}

class LoginModel: Codable {
    var id: Int?
    var name, surname, email, token: String?
    var user_type: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, surname, email, token
        case user_type
    }

    init(id: Int?, name: String?, surname: String?, email: String?, token: String?, user_type: Int?) {
        self.id = id
        self.name = name
        self.surname = surname
        self.email = email
        self.token = token
        self.user_type = user_type
    }
}
