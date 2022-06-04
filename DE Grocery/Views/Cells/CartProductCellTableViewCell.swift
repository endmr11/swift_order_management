//
//  CartProductCellTableViewCell.swift
//  DE Grocery
//
//  Created by Eren Demir on 24.05.2022.
//

import UIKit



class CartProductCellTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productCount: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    var cellProtocol: CartProductCellCollectionViewCellProtocol?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func incrementOrDecrement(_ sender: UIStepper) {
        cellProtocol?.increment(indexPath: self.indexPath!, count: Int(sender.value))
    }
}
