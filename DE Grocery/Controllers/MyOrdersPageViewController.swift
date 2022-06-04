//
//  MyOrdersPageViewController.swift
//  DE Grocery
//
//  Created by Eren Demir on 24.05.2022.
//

import UIKit

class MyOrdersPageViewController: UIViewController {
    
    @IBOutlet weak var myOrdersTableView: UITableView!
    var myOrderList = [OrderModel]()
    var allProductsList = [ProductModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let indicatorView = self.activityIndicator(style: .medium,
                                            center: self.view.center)
        self.view.addSubview(indicatorView)
        indicatorView.startAnimating()
        APIService().getMyOrders(userId: String(LocaleDatabaseHelper().currentUserId!), onSuccess: {response in
            self.myOrderList = response.model!
            DispatchQueue.main.async {
                self.myOrdersTableView.reloadData()
            }
        })
        
        APIService().getAllProducts(onSuccess: {
            response in
            self.allProductsList = response.model!
            indicatorView.stopAnimating()
            indicatorView.hidesWhenStopped = true
            DispatchQueue.main.async {
                self.myOrdersTableView.delegate = self
                self.myOrdersTableView.dataSource = self
                self.myOrdersTableView.reloadData()
            }
        })
        
        SocketConfig().socket.on("updateOrderResponse") {
            data, ack in
            guard let json = data.first as? NSDictionary else { return }
            let map = json.swiftDictionary
            let tempOrder = self.myOrderList.first(where: {
                $0.order_id == map["order_id"] as? Int
            })
            
            DispatchQueue.main.async {
                tempOrder?.order_status = map["order_status"] as? Int
                self.myOrdersTableView.reloadData()
            }
        }
    }
    
    func priceCalculate(model:OrderModel) -> String {
        var price:Int = 0
        model.products?.forEach({
            element in
            let tempProduct = allProductsList.first(where: {
                $0.product_id == element?.product_id
            })
            price = ((tempProduct?.product_price!)! * element!.count!)
        })
        return "Toplam: \(price)₺"
    }
    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                       frame: CGRect? = nil,
                                       center: CGPoint? = nil) -> UIActivityIndicatorView {
        
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        if let center = center {
            activityIndicatorView.center = center
        }
        return activityIndicatorView
    }
}



extension MyOrdersPageViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = myOrderList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myOrdersCell", for: indexPath) as! MyOrdersCellTableViewCell
        cell.orderOwner.text = "\(order.user_name ?? "") \(order.user_surname ?? "")"
        cell.orderStatusImage.tintColor = order.order_status == 1 ?.green : .red
        cell.orderTotalPrice.text = priceCalculate(model: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
}
//            if let rawArray = map["products"] as? NSArray, let castArray = rawArray as? Array< Dictionary< String, AnyObject>>{
//                var products = [Product]()
//                castArray.forEach({
//                    element in
//                    var a = element["count"]
//                })
//            }
