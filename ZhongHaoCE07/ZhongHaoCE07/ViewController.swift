//
//  ViewController.swift
//  ZhongHaoCE07
//
//  Created by Hao Zhong on 7/21/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use the prototype cell#1
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_reuseid_1", for: indexPath) as! CustomCell1
        
        // Configure cell
        cell.title1?.text = searchResult[indexPath.row].name + ", " + searchResult[indexPath.row].state
        cell.detail1?.text = "Population: \(searchResult[indexPath.row].population)"
        cell.info1?.text = "Zip: " + searchResult[indexPath.row].zip
        
        // Return configured cell
        return cell
    }

    @IBOutlet weak var resultTable: UITableView!
    
    var cityArray = [City]()
    var searchResult = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Get the path to the .json file
        if let path = Bundle.main.path(forResource: "zips", ofType: ".json") {
            
            // Create url from the path
            let url = URL(fileURLWithPath: path)
            
            do {
                // Create a data object from the url
                let data = try Data.init(contentsOf: url)
                
                // Create a json object and cast it as an any type array
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any]
                
                // Parse through jsonObj and instantiate city objects
                Parse(jsonObject: jsonObj)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }

    func Parse(jsonObject: [Any]?) {
        // Bind the optional jsonObject to the non-optional json
        guard let jsonObj = jsonObject
        else {
            print("Parse failed to unwrap the optional")
            return
        }
        
        // Loop through every first level item in the JSON array
        for firstLevelItem in jsonObj {
            // Optional unwrap all these items, return if any of them cannot be unwrapped
            guard let object = firstLevelItem as? [String: Any],
                  let city = object["city"] as? String,
                  let pop = object["pop"] as? Int,
                  let state = object["state"] as? String,
                  let id = object["_id"] as? String
            else {continue}
            
            cityArray.append(City(city: city, state: state, pop: pop, zip: id))
        }
    }
    
    @IBAction func clear(_ sender: UIBarButtonItem) {
        searchResult.removeAll()
        
        resultTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SearchTableViewController {
            destination.allCities = self.cityArray
        }
    }
    
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! SearchTableViewController
        // Use data from the view controller which initiated the unwind segue
        self.searchResult = sourceViewController.filteredArray
        
        resultTable.reloadData()
    }
    
}

