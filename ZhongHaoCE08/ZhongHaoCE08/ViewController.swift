//
//  ViewController.swift
//  ZhongHaoCE08
//
//  Created by Hao Zhong on 7/23/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subreddits[section].threads.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subreddits.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return subreddits[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use the prototype cell#1
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID_1", for: indexPath)
        
        // Configure cell
        cell.textLabel?.text = subreddits[indexPath.section].threads[indexPath.row].title
        cell.textLabel?.textColor = colorTheme[0]
        cell.detailTextLabel?.text = subreddits[indexPath.section].threads[indexPath.row].by
        cell.detailTextLabel?.textColor = colorTheme[1]
        cell.imageView?.image = subreddits[indexPath.section].threads[indexPath.row].thumbnail
        
        // Return configured cell
        return cell
    }
    
    @IBOutlet weak var table: UITableView!
    
    var subreddits = [Subreddit]()
    var colorTheme: [UIColor] = [UIColor.black, UIColor.black, UIColor.systemBackground]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let savedTheme = UserDefaults.standard.colors(forKey: "themeColorSet") {
            colorTheme = savedTheme
        }
        table.backgroundColor = colorTheme[2]
        
        if let savedList = UserDefaults.standard.object(forKey: "subredditNames") as? [String] {
            for subred in savedList {
                subreddits.append(Subreddit(keyWord: subred))
            }
        } else {
            subreddits.append(Subreddit(keyWord: "movies"))
        }
        downloadnParse()
    }

    func downloadnParse() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        for i in subreddits.indices {
            if let validURL = URL(string: "https://www.reddit.com/r/\(subreddits[i].name)/.json") {
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
                                    self.subreddits[i].threads.append(newThread)
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
    
    @IBAction func unwindToSetColor(_ unwindSegue: UIStoryboardSegue) {
        // Instead of sending variables across screens, we can use UserDefaults to do the job.
        if let savedTheme = UserDefaults.standard.colors(forKey: "themeColorSet") {
            colorTheme = savedTheme
        }
        table.backgroundColor = colorTheme[2]
        table.reloadData()
    }
    
    @IBAction func unwindToSaveReddits(_ unwindSegue: UIStoryboardSegue) {
        // Instead of sending variables across screens, we can use UserDefaults to do the job.
        if let savedList = UserDefaults.standard.object(forKey: "subredditNames") as? [String] {
            subreddits.removeAll()
            
            for subred in savedList {
                subreddits.append(Subreddit(keyWord: subred))
            }
        }
        
        downloadnParse()
    }
}

