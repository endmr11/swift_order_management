//
//  order_request_model.swift
//  DE Grocery
//
//  Created by Eren Demir on 24.05.2022.
//

import Foundation


class OrderRequestModel:Codable {
    var user_id:Int?
    var products:[OrderProductModel]?
    var user_name:String?
    var user_surname:String?
    var order_status:Int?
    
    init(user_id:Int,products:[OrderProductModel],user_name:String,user_surname:String,order_status:Int){
        self.user_id = user_id
        self.products = products
        self.user_name = user_name
        self.user_surname = user_surname
        self.order_status = order_status
    }
    
}


class OrderProductModel:Codable {
    var product_id:Int?
    var count:Int?
    
    init(product_id:Int,count:Int) {
        self.product_id = product_id
        self.count = count
    }
    
}
