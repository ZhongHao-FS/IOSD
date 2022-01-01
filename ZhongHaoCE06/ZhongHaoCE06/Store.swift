//
//  Store.swift
//  ZhongHaoCE06
//
//  Created by Hao Zhong on 7/16/21.
//

import Foundation

class Store {
    // Stored Properties
    let name: String
    var shoppingList: [Item]
    
    // Computed Properties
    var itemsNeeded: Int {
        get {
            var needed = 0
            for item in shoppingList {
                if item.purchased == false {
                    needed += 1
                }
            }
            return needed
        }
    }
    
    var itemsPurchased: Int {
        get {
            var purchased = 0
            for item in shoppingList {
                if item.purchased == true {
                    purchased += 1
                }
            }
            return purchased
        }
    }
    
    // Initializer
    init(storeName: String) {
        self.name = storeName
        // Start with an empty shopping list when creating a new store
        self.shoppingList = [Item]()
    }
}
