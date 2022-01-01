//
//  Article.swift
//  ZhongHaoCE09
//
//  Created by Hao Zhong on 7/30/21.
//

import Foundation
import UIKit

class Article {
    // Stored Properties
    let title: String
    var image: UIImage!
    let description: String
    let author: String
    let date: Date?
    let url: URL?
    
    // Initializer
    init(title: String, imageURL: String, description: String, author: String, dateTime: String, link: String) {
        self.title = title
        self.image = UIImage(imageLiteralResourceName: "News")
        self.description = description
        self.author = author
        self.url = URL(string: link)
        
        if let urlToImage = URL(string: imageURL) {
            do {
                let data = try Data(contentsOf: urlToImage)
                self.image = UIImage(data: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        self.date = dateFormatter.date(from: dateTime)
    }
}
