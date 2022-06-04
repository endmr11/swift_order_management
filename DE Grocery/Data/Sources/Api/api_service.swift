//
//  api_service.swift
//  DE Grocery
//
//  Created by Eren Demir on 21.05.2022.
//

import Foundation
import Alamofire

class APIService {
    func login(model:LoginRequestModel,onSuccess:@escaping (LoginResponseModel)->Void) {
        let parameters = ["email":model.email! as String,"password":model.password! as String]
        AF.request("\(EnvConfig.apiURL)\(EnvConfig.loginEP)",method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).responseDecodable(of:LoginResponseModel.self,completionHandler: {
            response in
            guard let value = response.value else {return}
            onSuccess(value)
        })
    }
    
    func getAllProducts(onSuccess:@escaping (ProductResponseModel)->Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: LocaleDatabaseHelper().currentUserToken!)]
        AF.request("\(EnvConfig.apiURL)\(EnvConfig.allProductsEP)",method: .get,headers: headers).responseDecodable(of:ProductResponseModel.self,decoder: JSONDecoder() ,completionHandler: {
            response in
            guard let value = response.value else {return}
            onSuccess(value)
        })
    }
    
    func setOrder(model:OrderRequestModel ,onSuccess:@escaping (Bool)->Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: LocaleDatabaseHelper().currentUserToken!),.contentType("application/json")
        ]
        var dataMap = [[String:Any]]()
        
        model.products?.forEach({
            element in
            dataMap.append(["product_id":element.product_id!,"count":element.count!])
        })
        
        let parameters = [
            "user_id":model.user_id!,
            "products":dataMap,
            "user_name":model.user_name!,
            "user_surname":model.user_surname!,
            "order_status":0
        ] as [String : Any]
        
        AF.request(
            "\(EnvConfig.apiURL)\(EnvConfig.orderCreateEP)",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(
            of:OrderResponseModel.self,
            completionHandler: {
                response in
                if response.response?.statusCode == 200 {
                    onSuccess(true)
                }else{
                    onSuccess(false)
                }
            })
    }
    
    func getMyOrders( userId:String,onSuccess:@escaping (OrderResponseModel)->Void)  {
        let headers: HTTPHeaders = [.authorization(bearerToken: LocaleDatabaseHelper().currentUserToken!)]
        AF.request(
            "\(EnvConfig.apiURL)\(EnvConfig.myOrdersEP)\(userId)",
            method: .get,
            headers: headers).responseDecodable(
                of:OrderResponseModel.self,
                decoder: JSONDecoder(),
                completionHandler: {
                    response in
                    print(response)
                    if let res = response.value {
                        onSuccess(res)
                    }
                })
    }
    
    func getAllOrders(onSuccess:@escaping (OrderResponseModel)->Void){
        
        let headers: HTTPHeaders = [.authorization(bearerToken: LocaleDatabaseHelper().currentUserToken!)]
        AF.request("\(EnvConfig.apiURL)\(EnvConfig.allOrdersEP)",method: .get,headers: headers).responseDecodable(
            of:OrderResponseModel.self,
            decoder: JSONDecoder(),
            completionHandler:{
                response in
                if let res = response.value {
                    onSuccess(res)
                }
            } )
    }
    
    func updateOrder(model:OrderRequestModel,orderId:String){
        let headers: HTTPHeaders = [.authorization(bearerToken: LocaleDatabaseHelper().currentUserToken!),.contentType("application/json")
        ]
        var dataMap = [[String:Any]]()
        
        model.products?.forEach({
            element in
            dataMap.append(["product_id":element.product_id!,"count":element.count!])
        })
        
        let parameters = [
            "user_id":model.user_id!,
            "products":dataMap,
            "user_name":model.user_name!,
            "user_surname":model.user_surname!,
            "order_status":1
        ] as [String : Any]
        
        AF.request(
            "\(EnvConfig.apiURL)\(EnvConfig.orderUpdateEP)\(orderId)",
            method: .put,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        ).resume()
    }
}
