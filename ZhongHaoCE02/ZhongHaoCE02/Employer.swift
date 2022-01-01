//
//  Employer.swift
//  ZhongHaoCE02
//
//  Created by Hao Zhong on 7/4/21.
//

import Foundation

class Employer {
    // Stored Properties
    let company: String
    let responsibilities: [String]! // May be empty
    
    // Calculated Property
    var resTotal: Int {
        get {
            return self.responsibilities.count
        }
    }
    
    // Initializers
    init(name: String, responsibilityArray: [String]) {
        self.company = name
        self.responsibilities = responsibilityArray
    }
    
    convenience init(name: String) {
        self.init(name: name, responsibilityArray: [String]())
    }
}
