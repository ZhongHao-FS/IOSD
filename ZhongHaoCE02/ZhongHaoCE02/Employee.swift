//
//  Employee.swift
//  ZhongHaoCE02
//
//  Created by Hao Zhong on 7/3/21.
//

import Foundation

class Employee {
    // Stored Properties
    let employeeName: String
    let userName: String
    let macAddress: String
    let currentTitle: String
    let skills: [String]! // May be empty
    let pastEmployers: [Employer]! // May be empty
    
    // Calculated Properties
    var totalSkills: Int {
        get {
            return self.skills.count
        }
    }
    
    var pastNumEmployers: Int {
        get {
            return self.pastEmployers.count
        }
    }
    
    // Initializer
    init(eName: String, uName: String, address: String, title: String, skillSet: [String], employers: [Employer]) {
        self.employeeName = eName
        self.userName = uName
        self.macAddress = address
        self.currentTitle = title
        self.skills = skillSet
        self.pastEmployers = employers
    }
}
