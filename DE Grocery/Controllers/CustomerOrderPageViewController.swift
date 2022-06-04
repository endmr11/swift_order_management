//
//  CustomerOrderPageViewController.swift
//  DE Grocery
//
//  Created by Eren Demir on 25.05.2022.
//

import UIKit

class CustomerOrderPageViewController: UIViewController {
    @IBOutlet weak var myOrdersTableView: UITableView!
    var myOrderList = [OrderModel]()
    var allProductsList = [ProductModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let indicatorView = self.activityIndicator(style: .medium,
                                                   center: self.view.center)
        self.view.addSubview(indicatorView)
        indicatorView.startAnimating()
        APIService().getAllOrders(onSuccess: {response in
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
        SocketConfig().initSocket()

        self.navigationItem.hidesBackButton = true

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
        
        SocketConfig().socket.on("createOrderResponse") {
            data, ack in
            guard let json = data.first as? NSDictionary else { return }
            let map = json.swiftDictionary
            let user_id = map["user_id"] as? Int
            let order_id = map["order_id"] as? Int
            let user_name = map["user_name"] as? String
            let user_surname = map["user_surname"] as? String
            let order_status = map["order_status"] as? Int
            let nsProducts = map["products"] as? NSArray
            var products = [Product?]()
            nsProducts?.forEach({
                element in
                let elementMap = element as? [String:Any]
                products.append(Product(
                    product_id: elementMap!["product_id"] as? Int,
                    count: elementMap!["product_id"] as? Int
                ))
            })
            
            let modelData = OrderModel(order_id: order_id, user_id: user_id, products: products, user_name: user_name, user_surname: user_surname, order_status: order_status)
            DispatchQueue.main.async {
                self.myOrderList.insert(modelData, at: 0)
                self.myOrdersTableView.reloadData()
            }
        }

        
    }
    
    @IBAction func exitBtnAction(_ sender: Any) {
        LocaleDatabaseHelper().userSessionClear()
        SocketConfig().closeSocket()
        self.navigationController?.popToRootViewController(animated: true)
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
extension CustomerOrderPageViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = myOrderList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerOrdersCell", for: indexPath) as! CustomerOrdersCellTableViewCell
        cell.orderOwner.text = "\(order.user_name ?? "") \(order.user_surname ?? "")"
        cell.orderStatusImage.tintColor = order.order_status == 1 ?.green : .red
        cell.orderTotalPrice.text = self.priceCalculate(model: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let okeyAction = UIContextualAction(style: .destructive, title: "Tamam") { (contextualAction, view, boolValue) in
            self.myOrderList[indexPath.row].products?.forEach({
                element in
            })
            var products = [OrderProductModel]()
            self.myOrderList[indexPath.row].products?.forEach({
                element in
                let prodModel = OrderProductModel(
                    product_id: Int((element?.product_id)!),
                    count: Int((element?.count)!))
                products.append(prodModel)
            })

            let model = OrderRequestModel(
                user_id: self.myOrderList[indexPath.row].user_id!,
                products: products,
                user_name: self.myOrderList[indexPath.row].user_name!,
                user_surname: self.myOrderList[indexPath.row].user_surname!,
                order_status: self.myOrderList[indexPath.row].order_status!)
            APIService().updateOrder(model: model, orderId: String(self.myOrderList[indexPath.row].order_id!))
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [okeyAction])
        
        return swipeActions
    }
}
