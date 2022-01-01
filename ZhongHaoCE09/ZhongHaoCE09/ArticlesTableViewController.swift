//
//  ArticlesTableViewController.swift
//  ZhongHaoCE09
//
//  Created by Hao Zhong on 7/31/21.
//

import UIKit

class ArticlesTableViewController: UITableViewController {

    var sourceID = ""
    var sourceName = ""
    var articles = [Article]()
    var colorSet = [UIColor.black, UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = sourceName
        
        downloadnParse(jsonAtUrl: "https://newsapi.org/v2/top-headlines?sources=\(sourceID)&apiKey=234075dc1ad74149be69d0d63cd1bfd5")
        
        if let savedTheme = UserDefaults.standard.colors(forKey: "themeColors") {
            colorSet = savedTheme
            tableView.reloadData()
        }
    }

    func downloadnParse(jsonAtUrl urlString: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        if let validURL = URL(string: urlString) {
            let task = session.dataTask(with: validURL, completionHandler: {(opt_data, opt_response, opt_error) in
                // Bail out on an error
                if opt_error != nil {return}
                
                // Check the response, status code and data
                guard let response = opt_response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = opt_data
                else {return}
                
                do {
                    // de-serialize data object
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        
                        // Parse data
                        guard let results = json["articles"] as? [Any]
                              else {return}
                        
                        for piece in results {
                            guard let article = piece as? [String: Any],
                                  let name = article["title"] as? String,
                                  let imageURL = article["urlToImage"] as? String,
                                  let note = article["description"] as? String,
                                  let writer = article["author"] as? String,
                                  let dateTime = article["publishedAt"] as? String,
                                  let link = article["url"] as? String
                            else {continue}
                            
                            // Map to an Article class instance and then add to articles array
                            self.articles.append(Article(title: name, imageURL: imageURL, description: note, author: writer, dateTime: dateTime, link: link))
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            task.resume()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID_2", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = articles[indexPath.row].title
        cell.textLabel?.textColor = colorSet[0]
        cell.imageView?.image = articles[indexPath.row].image
        cell.backgroundColor = colorSet[1]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let destination = segue.destination as? ArticleDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                // Pass the selected object to the new view controller.
                destination.currentArticle = self.articles[indexPath.row]
                destination.source = self.sourceName
            }
        }
    }
    
    @IBAction func unwindToArticles(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}
