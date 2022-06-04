//
//  MyOrdersCellTableViewCell.swift
//  DE Grocery
//
//  Created by Eren Demir on 24.05.2022.
//

import UIKit

class MyOrdersCellTableViewCell: UITableViewCell {

    @IBOutlet weak var orderStatusImage: UIImageView!
    @IBOutlet weak var orderOwner: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
