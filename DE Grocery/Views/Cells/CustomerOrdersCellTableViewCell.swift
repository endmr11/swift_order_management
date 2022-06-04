//
//  CustomerOrdersCellTableViewCell.swift
//  DE Grocery
//
//  Created by Eren Demir on 25.05.2022.
//

import UIKit

class CustomerOrdersCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderStatusImage: UIImageView!
    @IBOutlet weak var orderOwner: UILabel!
    @IBOutlet weak var orderTotalPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
