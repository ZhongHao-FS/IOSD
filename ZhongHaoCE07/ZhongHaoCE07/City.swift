//
//  City.swift
//  ZhongHaoCE07
//
//  Created by Hao Zhong on 7/21/21.
//

import Foundation

class City {
    // Stored Properties
    let name: String
    let state: String
    let population: Int
    let zip: String
    
    // Initializer
    init(city: String, state: String, pop: Int, zip: String) {
        self.name = city
        self.state = state
        self.population = pop
        self.zip = zip
    }
}
