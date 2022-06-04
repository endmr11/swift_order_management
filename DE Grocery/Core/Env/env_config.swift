//
//  env_config.swift
//  DE Grocery
//
//  Created by Eren Demir on 21.05.2022.
//

import Foundation

class EnvConfig{
    static let  apiURL:String = "http://localhost:8080";
    static let  refreshTokenEP:String = "/refresh/token";
    static let  loginEP:String = "/login";
    static let  allProductsEP:String = "/products/all-products";
    static let  allOrdersEP:String = "/orders/all-orders"
    static let  myOrdersEP:String = "/orders/my-orders/";
    static let  orderCreateEP:String = "/orders/order-create";
    static let  orderUpdateEP:String = "/orders/order-update/";
}
