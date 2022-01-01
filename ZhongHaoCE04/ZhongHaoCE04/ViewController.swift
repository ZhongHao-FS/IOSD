//
//  ViewController.swift
//  ZhongHaoCE04
//
//  Created by Hao Zhong on 7/12/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Display all items in threads
        return threads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use the prototype cell#1
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID_1", for: indexPath)
        
        // Configure cell
        cell.textLabel?.text = threads[indexPath.row].title
        cell.detailTextLabel?.text = threads[indexPath.row].by
        cell.imageView?.image = threads[indexPath.row].thumbnail
        
        // Return configured cell
        return cell
    }
    
    @IBOutlet weak var table: UITableView!
    
    var threads = [Thread]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        downloadnParse(jsonAtUrl: "https://www.reddit.com/r/movies/.json")
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
                        guard let secondLevelItem = json["data"] as? [String: Any],
                              let subChannel = secondLevelItem["children"] as? [Any]
                              else {return}
                        
                        for thirdLevelItem in subChannel {
                            guard let content = thirdLevelItem as? [String: Any],
                                  let thread = content["data"] as? [String: Any],
                                  let title = thread["title"] as? String,
                                  let by = thread["author"] as? String,
                                  let jpgURL = thread["thumbnail"] as? String
                            else {continue}
                            
                            // Map to model objects if it has a thumbnail
                            if jpgURL.contains("https") {
                                let newThread = Thread(headline: title, authorInfo: by, thumbnailURL: jpgURL)
                                self.threads.append(newThread)
                            }
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            })
            task.resume()
        }
    }
}

