//
//  protocols.swift
//  DE Grocery
//
//  Created by Eren Demir on 24.05.2022.
//

import Foundation


protocol CartListClearProtocol {
    func clear()
}

protocol ProductCellCollectionViewCellProtocol {
    func addCartFunc(indexPath:IndexPath)
}

protocol CartProductCellCollectionViewCellProtocol {
    func increment(indexPath:IndexPath,count:Int)
}
