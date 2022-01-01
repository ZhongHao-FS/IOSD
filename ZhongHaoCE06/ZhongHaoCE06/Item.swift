//
//  Item.swift
//  ZhongHaoCE06
//
//  Created by Hao Zhong on 7/16/21.
//

import Foundation

class Item {
    // Stored Properties
    let name: String
    var purchased: Bool
    
    // Initializer
    init(name: String) {
        self.name = name
        // Always assume that the item has yet to be purchased when it is just added
        self.purchased = false
    }
}
