//
//  Logo.swift
//  ZhongHaoCE03
//
//  Created by Hao Zhong on 7/4/21.
//

import Foundation

class Logo {
    // Stored Properties
    let company: String
    let name: String
    let version: String
    let catchPhrase: String
    let dRevene: String
    let colors: [Color]
    
    // Initializers
    init(company: String, logoName: String, ver: String, phrase: String, revene: String, colorSet: [Color]) {
        self.company = company
        self.name = logoName
        self.version = ver
        self.catchPhrase = phrase
        self.dRevene = revene
        self.colors = colorSet
    }
    
    convenience init(company: String, logoName: String, ver: String, phrase: String, colorSet: [Color]) {
        let income = "$0"
        
        self.init(company: company, logoName: logoName, ver: ver, phrase: phrase, revene: income, colorSet: colorSet)
    }
}
