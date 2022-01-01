//
//  LoadingViewController.swift
//  ZhongHaoCE09
//
//  Created by Hao Zhong on 7/27/21.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var allSources = [Source]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        downloadnParse(jsonAtUrl: "https://newsapi.org/v2/top-headlines/sources?apiKey=234075dc1ad74149be69d0d63cd1bfd5")
        
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
                        guard let sources = json["sources"] as? [Any]
                              else {return}
                        
                        for source in sources {
                            guard let newsNetwork = source as? [String: String],
                                  let brand = newsNetwork["name"],
                                  let type = newsNetwork["category"],
                                  let iD = newsNetwork["id"]
                            else {continue}
                            
                            // Map to a Source class instance and then add to allSources
                            self.allSources.append(Source(name: brand, category: type, id: iD))
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ToLoad", sender: self.spinner)
                }
            })
            task.resume()
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if let navStack = segue.destination as? UINavigationController {
            if let destination = navStack.viewControllers[0] as? ViewController {
                // Pass the selected object to the new view controller.
                destination.sourceList = self.allSources
            }
        }
        
    }

}
