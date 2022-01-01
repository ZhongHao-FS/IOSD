//
//  Subreddit.swift
//  ZhongHaoCE08
//
//  Created by Hao Zhong on 7/25/21.
//

import Foundation
import UIKit

class Subreddit {
    // Stored Properties
    let name: String
    var threads = [Thread]()
    
    // Initializer
    init(keyWord: String) {
        self.name = keyWord
        
    }
}
