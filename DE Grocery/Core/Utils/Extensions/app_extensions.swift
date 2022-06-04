//
//  app_extensions.swift
//  DE Grocery
//
//  Created by Eren Demir on 25.05.2022.
//

import Foundation


extension NSDictionary {
  
  var swiftDictionary: [String : AnyObject] {
    var swiftDictionary: [String : AnyObject] = [:]
      let keys = self.allKeys.compactMap { $0 as? String }
    for key in keys {
      let keyValue = self.value(forKey: key) as AnyObject
      swiftDictionary[key] = keyValue
    }
    return swiftDictionary
  }
}
