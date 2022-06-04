//
//  ShoppingCartPageViewController.swift
//  DE Grocery
//
//  Created by Eren Demir on 21.05.2022.
//

import UIKit




class ShoppingCartPageViewController: UIViewController {
    
    @IBOutlet weak var cartProductTableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    var cartProductList = [ProductModel]()
    var orderProductList = [OrderProductModel]()
    var cartProductCount = [Int]()
    var clearProtocol: CartListClearProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        cartProductTableView.delegate = self
        cartProductTableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor(hex: 0xFF39993A)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalPrice.text = priceCalculate()
    }
    
    @IBAction func addOrder(_ sender: Any) {
        let model = OrderRequestModel(
            user_id: LocaleDatabaseHelper().currentUserId!,
            products: orderProductList,
            user_name: LocaleDatabaseHelper().currentUserName!,
            user_surname: LocaleDatabaseHelper().currentUserSurname!,
            order_status: 0)
        APIService().setOrder(model: model, onSuccess: {
            response in
            guard response != false else {return}
            let alertController = UIAlertController(title: "Sipariş Oluşturuldu!", message: "Siparişiniz başarıyla oluşturuldu. Siparişlerim sayfasından göz atmayı unutmayın!", preferredStyle: .alert)
            let tamamAction = UIAlertAction(title: "Tamam", style:.default){ action in
                print("Tamam Tıklandı")
                self.clearProtocol?.clear()
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(tamamAction)
            self.present(alertController, animated: true)
        })
    }
    
    
    
    func priceCalculate() -> String {
        var price:Int = 0
        orderProductList.removeAll()
        for i in 0..<cartProductList.count {
            orderProductList.append(OrderProductModel(product_id: cartProductList[i].product_id!, count: cartProductCount[i]))
        }
        orderProductList.forEach({element in
            let tempProduct:ProductModel = cartProductList.first(where: {$0.product_id == element.product_id})!
            price += (tempProduct.product_price! * (element.count!))
        })
        return "Toplam: \(price)₺"
    }
    
    
}


extension ShoppingCartPageViewController:UITableViewDelegate,UITableViewDataSource,CartProductCellCollectionViewCellProtocol {
    func increment(indexPath: IndexPath, count: Int) {
        print(">>>>> \(count)")
        self.cartProductCount[indexPath.row] = count
        DispatchQueue.main.async {
            self.totalPrice.text = self.priceCalculate()
            self.cartProductTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = cartProductList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCartCell", for: indexPath) as! CartProductCellTableViewCell
        cell.productName.text = product.product_name
        cell.productImage.image = UIImage(named: product.product_url!)
        cell.productPrice.text = "\(product.product_price!) ₺"
        cell.productCount.text = "\(self.cartProductCount[indexPath.row]) Adet"
        cell.cellProtocol = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
    
}
