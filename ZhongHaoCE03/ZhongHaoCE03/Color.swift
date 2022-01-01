//
//  Color.swift
//  ZhongHaoCE03
//
//  Created by Hao Zhong on 7/4/21.
//

import Foundation

class Color {
    // Stored Properties
    let hexCode: String
    let description: String
    
    // Initializer
    init(hex: String, note: String) {
        self.hexCode = hex
        self.description = note
    }
}
