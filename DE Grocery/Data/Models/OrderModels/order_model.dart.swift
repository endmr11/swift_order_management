// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
class OrderResponseModel: Codable {
    var status: Int?
    var message: String?
    var path: String?
    var model: [OrderModel]?


    init(status: Int?, message: String?, path: String?, model: [OrderModel]?) {
        self.status = status
        self.message = message
        self.path = path
        self.model = model
    }
}

// MARK: - Model
class OrderModel: Codable {
    var order_id: Int?
    var user_id: Int?
    var products: [Product?]?
    var user_name: String?
    var user_surname: String?
    var order_status: Int?

    init(order_id: Int?, user_id: Int?, products: [Product?]?, user_name: String?, user_surname: String?, order_status: Int?) {
        self.order_id = order_id
        self.user_id = user_id
        self.products = products
        self.user_name = user_name
        self.user_surname = user_surname
        self.order_status = order_status
    }
}

// MARK: - Product
class Product: Codable {
    var product_id: Int?
    var count: Int?

    init(product_id: Int?, count: Int?) {
        self.product_id = product_id
        self.count = count
    }
}


