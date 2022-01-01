//
//  Thread.swift
//  ZhongHaoCE08
//
//  Created by Hao Zhong on 7/23/21.
//

import Foundation
import UIKit

class Thread {
    // Stored Properties
    var title: String
    var by: String
    var thumbnail: UIImage!
    
    // Initializer
    init(headline: String, authorInfo: String, thumbnailURL: String) {
        self.title = headline
        self.by = authorInfo
        
        if let url = URL(string: thumbnailURL) {
            do {
                let data = try Data(contentsOf: url)
                self.thumbnail = UIImage(data: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
