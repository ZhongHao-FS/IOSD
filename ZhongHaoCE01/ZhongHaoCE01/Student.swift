//
//  Student.swift
//  ZhongHaoCE01
//
//  Created by Hao Zhong on 6/30/21.
//

import Foundation

class Student {
    // Stored Properties
    let name: String
    let age: Int
    let male: Bool
    let scores: [Int]
    
    // Computed Properties
    var average: Int {
        get {
            var sum = 0
            
            for score in scores {
                sum += score
            }
            
            return sum / scores.count
        }
    }
    
    // Initializer
    init(name: String, age: Int, male: Bool, scores: [Int]) {
        self.name = name
        self.age = age
        self.male = male
        self.scores = scores
    }
    
}
