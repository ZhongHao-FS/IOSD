//
//  ArticleDetailViewController.swift
//  ZhongHaoCE09
//
//  Created by Hao Zhong on 8/1/21.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionBox: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var currentArticle: Article? = nil
    var source = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = source
        
        if let article = currentArticle {
            image.image = article.image
            titleLabel.text = article.title
            descriptionBox.text = article.description
            authorLabel.text = "by: " + article.author
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateLabel.text = dateFormatter.string(from: Date(timeIntervalSinceNow: 0))
            if let date = article.date {
                dateLabel.text = dateFormatter.string(from: date)
            }
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let destination = segue.destination as? WebViewController {
            if let url = currentArticle?.url {
                // Pass the selected object to the new view controller.
                destination.enterURL = url
                destination.source = self.source
            }
        }
    }

}
