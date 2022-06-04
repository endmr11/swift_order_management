//
//  UrunHucreCollectionViewCell.swift
//  DE Grocery
//
//  Created by Eren Demir on 21.05.2022.
//

import UIKit



class ProductCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    var cellProtocol: ProductCellCollectionViewCellProtocol?
    var indexPath:IndexPath?
    
    @IBAction func addCart(_ sender: Any) {
        cellProtocol?.addCartFunc(indexPath: self.indexPath!)
    }
}
