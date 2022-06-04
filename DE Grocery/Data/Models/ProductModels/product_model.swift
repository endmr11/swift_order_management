import Foundation

// MARK: - ProductResponseModel
class ProductResponseModel: Codable {
    var status: Int?
    var message, path: String?
    var model: [ProductModel]?

    init(status: Int?, message: String?, path: String?, model: [ProductModel]?) {
        self.status = status
        self.message = message
        self.path = path
        self.model = model
    }
}

// MARK: - Model
class ProductModel: Codable{
    var product_id: Int?
    var product_name, product_desc: String?
    var product_price: Int?
    var product_url: String?

    enum CodingKeys: String, CodingKey {
        case product_id
        case product_name
        case product_desc
        case product_price
        case product_url
    }

    init(product_id: Int?, product_name: String?, product_desc: String?, product_price: Int?, product_url: String?) {
        self.product_id = product_id
        self.product_name = product_name
        self.product_desc = product_desc
        self.product_price = product_price
        self.product_url = product_url
    }
}
