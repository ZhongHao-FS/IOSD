//
//  ViewController.swift
//  ZhongHaoCE03
//
//  Created by Hao Zhong on 7/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var versionNum: UILabel!
    @IBOutlet weak var catch_Phrase: UILabel!
    @IBOutlet weak var daily_Revene: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var hexCodes: UILabel!
    
    var jsonObjOne: [Any]? = nil
    var jsonObjTwo: [Any]? = nil
    var logos = [Logo]()
    var logoIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Setup concurrent dispatch queue so that both parts can be downloaded simultaneously
        let concurrentQueue = DispatchQueue(label: "CE03.concurrent.queue", attributes: .concurrent)
        concurrentQueue.async {
            // Download Part1
            self.DownloadJSON(url: "https://fullsailmobile.firebaseio.com/T1NVC.json", tag: 1)
            
            // Download Part2
            self.DownloadJSON(url: "https://fullsailmobile.firebaseio.com/T2CRC.json", tag: 2)
        }
        
    }
    
    func DownloadJSON(url: String, tag: Int) {
        // Create a default configuration
        let config = URLSessionConfiguration.default
        // Create a session
        let session = URLSession(configuration: config)
        
        // Validate URL
        if let validURL = URL(string: url) {
            var jsonObj: [Any]?
            // Create a task that downloads from the URL as a data object
            let task = session.dataTask(with: validURL, completionHandler: { (data, response, error) in
                // Error response
                if error != nil {
                    print("Error downloading data")
                    return
                }
                
                // Check status, validate data
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200,
                      let validData = data
                else {
                    print("Https Error")
                    return}
                
                do {
                    jsonObj = try JSONSerialization.jsonObject(with: validData, options: .mutableContainers) as? [Any]
                    // Assign downloaded JSON object to the correct variable
                    if tag == 1 {
                        self.jsonObjOne = jsonObj
                    } else {
                        self.jsonObjTwo = jsonObj
                    }
                    
                    // Check if both downloads are finished
                    guard self.jsonObjOne != nil,
                          self.jsonObjTwo != nil
                    else {return}
                    
                    // Then only start the rest of the app if both downloads are finished
                    self.Parse(jsonObjOne: self.jsonObjOne, jsonObjTwo: self.jsonObjTwo)
                    
                    self.Display(index: self.logoIndex)
                }
                catch {
                    print("Error handling JSON object")
                }
            })
            
            task.resume()
            
        }
        
    }
    
    func Parse(jsonObjOne: [Any]?, jsonObjTwo: [Any]?) {
        if let jOO = jsonObjOne, let jOT = jsonObjTwo {
            // Parse part1[0] with part2[0] up until the end of the array
            for i in 0...(jOO.count - 1) {
                guard let pOne = jOO[i] as? [String: Any],
                      let company = pOne["company"] as? String,
                      let logo = pOne["name"] as? String,
                      let ver = pOne["version"] as? String,
                      let pTwo = jOT[i] as? [String: Any],
                      let slogan = pTwo["catch_phrase"] as? String,
                      let pColors = pTwo["colors"] as? [[String: Any]]
                else { print("Guard1 error")
                    return}
                
                var colors = [Color]()
                for color in pColors {
                    guard let hex = color["color"] as? String,
                          // tricky typo
                          let descript = color["desription"] as? String
                          else { print("Guard2 error")
                        return }
                    
                    colors.append(Color(hex: hex, note: descript))
                }
                // Another tricky typo
                // This property is not present in all entries, thus an optional binding for convenience init is used here.
                if let income = pTwo["daily_revene"] as? String {
                    logos.append(Logo(company: company, logoName: logo, ver: ver, phrase: slogan, revene: income, colorSet: colors))
                } else {
                    logos.append(Logo(company: company, logoName: logo, ver: ver, phrase: slogan, colorSet: colors))
                }
                
            }
        }
    }
    
    func Display(index: Int) {
        // UI elements must be assigned using the main queue
        DispatchQueue.main.async {
            self.nameLabel.text = self.logos[index].name
            self.companyLabel.text = self.logos[index].company
            self.versionNum.text = "Version: " + self.logos[index].version
            self.catch_Phrase.text = self.logos[index].catchPhrase
            self.daily_Revene.text = "Daily Revene: " + self.logos[index].dRevene
            
            var stages = ""
            var hexes = ""
            for color in self.logos[index].colors {
                stages += "\(color.description): \n"
                hexes += "\(color.hexCode)\n"
            }
            self.descriptions.text = stages
            self.hexCodes.text = hexes
        }
        
    }

    @IBAction func Previous(_ sender: UIButton) {
        if logoIndex != 0 {
            logoIndex -= 1
        } else {
            logoIndex = logos.count - 1
        }
        
        Display(index: logoIndex)
    }
    
    @IBAction func Next(_ sender: UIButton) {
        if logoIndex != (logos.count - 1) {
            logoIndex += 1
        } else {
            logoIndex = 0
        }
        
        Display(index: logoIndex)
    }
}

