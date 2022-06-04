//
//  MainPageViewController.swift
//  DE Grocery
//
//  Created by Eren Demir on 20.05.2022.
//

import UIKit

class MainPageViewController: UIViewController,CartListClearProtocol {
    
    
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var exitBtn: UIBarButtonItem!
    
    let btn = BadgedButtonItem(with: UIImage(systemName: "cart"))
    var productList = [ProductModel]()
    var cartProductList = [ProductModel]()
    var cartProductCount = [Int]()
    var sayi = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = btn
        SocketConfig().initSocket()
        btn.tapAction = {
            self.performSegue(withIdentifier: "toCartPage", sender: nil)
        }
        btn.setBadge(with: sayi)
        
        let tasarim:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let genislik = self.productCollectionView.frame.size.width
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumInteritemSpacing = 10
        tasarim.minimumLineSpacing = 0
        let hucreGenislik = (genislik-30)/2
        tasarim.itemSize = CGSize(width: hucreGenislik, height: hucreGenislik * 1.7)
        productCollectionView!.collectionViewLayout = tasarim
        
        APIService().getAllProducts(onSuccess: { response in
            if let productList = response.model {
                self.productList = productList
                DispatchQueue.main.async {
                    self.productCollectionView.reloadData()
                }
            }
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCartPage" {
            print("toCartPage")
            let gidilecekVC = segue.destination as! ShoppingCartPageViewController
            gidilecekVC.cartProductList = self.cartProductList
            gidilecekVC.cartProductCount = self.cartProductCount
            gidilecekVC.clearProtocol = self
        }else if segue.identifier == "toMyOrdersPage" {
            _ = segue.destination as! MyOrdersPageViewController
        }
    }
    
    @IBAction func exitBtnAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Menü", message: "Lütfen işleminizi seçin!", preferredStyle: .actionSheet)
        let myOrdersAction = UIAlertAction(title: "Siparişlerim", style:.default){ action in
            print("Siparişlerim Tıklandı")
            self.performSegue(withIdentifier: "toMyOrdersPage", sender: nil)
        }
        let exitAction = UIAlertAction(title: "Çıkış Yap", style:.destructive){ action in
            LocaleDatabaseHelper().userSessionClear()
            SocketConfig().closeSocket()
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        alertController.addAction(myOrdersAction)
        alertController.addAction(exitAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        
        
    }
    
    func clear() {
        DispatchQueue.main.async {
            self.sayi = 0
            self.cartProductList.removeAll()
            self.cartProductCount.removeAll()
            self.btn.setBadge(with: self.sayi)
        }
    }
    
    
}

extension MainPageViewController:UICollectionViewDelegate,UICollectionViewDataSource,ProductCellCollectionViewCellProtocol{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = productList[indexPath.row]
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCellCollectionViewCell
        cell.cellProtocol = self
        cell.indexPath = indexPath
        cell.productName.text = product.product_name
        cell.productDescription.text = product.product_desc
        cell.priceLabel.text = "\(product.product_price!)₺"
        cell.productImage.image = UIImage(named: product.product_url!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Section: \(indexPath.section) Row: \(indexPath.row)")
    }
    func addCartFunc(indexPath: IndexPath) {
        print("Add Cart Section: \(indexPath.section) Row: \(indexPath.row)")
        
        let productControl = cartProductList.filter {$0.product_id == self.productList[indexPath.row].product_id}
        print(productControl.isEmpty)
        if productControl.isEmpty {
            cartProductList.append(productList[indexPath.row])
            self.sayi = cartProductList.count
            self.btn.setBadge(with: self.sayi)
            cartProductCount.append(1)
        }else{
            let alertController = UIAlertController(title: "Ürün zaten var", message: "Ürün sepetinizde var. Sepet kısmından sayısını arttırabilirsiniz.", preferredStyle: .alert)
            let tamamAction = UIAlertAction(title: "Tamam", style:.default){ action in
                print("Tamam Tıklandı")
            }
            alertController.addAction(tamamAction)
            self.present(alertController, animated: true)
        }
        
        
    }
    
}


class BadgedButtonItem: UIBarButtonItem {
    
    public func setBadge(with value: Int) {
        self.badgeValue = value
    }
    
    private var badgeValue: Int? {
        didSet {
            if let value = badgeValue,
               value > 0 {
                lblBadge.isHidden = false
                lblBadge.text = "\(value)"
            } else {
                lblBadge.isHidden = true
            }
        }
    }
    
    var tapAction: (() -> Void)?
    
    private let cartBtn = UIButton()
    private let lblBadge = UILabel()
    
    override init() {
        super.init()
        setup()
    }
    
    init(with image: UIImage?) {
        super.init()
        setup(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(image: UIImage? = nil) {
        
        self.cartBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.cartBtn.setImage(image, for: .normal)
        self.cartBtn.tintColor = UIColor(hex: 0xFF39993A)
        self.cartBtn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        self.lblBadge.frame = CGRect(x: 20, y: 0, width: 20, height: 20)
        self.lblBadge.backgroundColor = .red
        self.lblBadge.clipsToBounds = true
        self.lblBadge.layer.cornerRadius = 7
        self.lblBadge.textColor = UIColor.white
        self.lblBadge.font = UIFont.systemFont(ofSize: 15)
        self.lblBadge.textAlignment = .center
        self.lblBadge.isHidden = true
        self.lblBadge.minimumScaleFactor = 0.1
        self.lblBadge.adjustsFontSizeToFitWidth = true
        self.cartBtn.addSubview(lblBadge)
        self.customView = cartBtn
    }
    
    @objc func buttonPressed() {
        if let action = tapAction {
            action()
        }
    }
    
}
extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
