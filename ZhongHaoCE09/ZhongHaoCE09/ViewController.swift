//
//  ViewController.swift
//  ZhongHaoCE09
//
//  Created by Hao Zhong on 7/27/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sourceValues[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID_1", for: indexPath)
        
        cell.textLabel?.text = sourceValues[indexPath.section][indexPath.row].name
        cell.textLabel?.textColor = colorSet[0]
        cell.backgroundColor = colorSet[1]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let topics = [String](categories.keys)
        
        return topics[section]
    }
    
    @IBOutlet weak var sourcesTable: UITableView!
    
    var sourceList = [Source]()
    var categories = ["business": [Source](), "entertainment": [Source](), "general": [Source](), "health": [Source](), "science": [Source](), "sports": [Source](), "technology": [Source]()]
    var sourceValues = [[Source]]()
    var colorSet = [UIColor.black, UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for network in sourceList {
            if categories.keys.contains(network.category) {
                categories[network.category]?.append(network)
            }
        }
        for category in categories {
            if category.value.count == 0 {
                categories.removeValue(forKey: category.key)
            }
        }
        sourceValues = [[Source]](categories.values)
        
        if let savedTheme = UserDefaults.standard.colors(forKey: "themeColors") {
            colorSet = savedTheme
            sourcesTable.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArticlesTableViewController {
            if let indexPath = sourcesTable.indexPathForSelectedRow {
                destination.sourceID = self.sourceValues[indexPath.section][indexPath.row].id
                destination.sourceName = self.sourceValues[indexPath.section][indexPath.row].name
            }
        }
    }
    
    @IBAction func unwindToRoot(_ unwindSegue: UIStoryboardSegue) {
        // Instead of sending variables across screens, we can use UserDefaults to do the job.
        if let savedTheme = UserDefaults.standard.colors(forKey: "themeColors") {
            colorSet = savedTheme
            sourcesTable.reloadData()
        }
        
    }
}

