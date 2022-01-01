//
//  SettingsViewController.swift
//  ZhongHaoCE09
//
//  Created by Hao Zhong on 7/30/21.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID_3", for: indexPath)
        
        cell.textLabel?.text = "Lorem ipsum dolor sit er elit lamet"
        cell.textLabel?.textColor = self.textColor
        cell.backgroundColor = self.background
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    @IBOutlet weak var sampleTable: UITableView!
    @IBOutlet weak var themeTabs: UISegmentedControl!
    
    var textColor = UIColor.black
    var background = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let savedTheme = UserDefaults.standard.colors(forKey: "themeColors") {
            textColor = savedTheme[0]
            background = savedTheme[1]
            sampleTable.reloadData()
        }
    }
    
    @IBAction func themeSwitched(_ sender: UISegmentedControl) {
        switch themeTabs.selectedSegmentIndex {
        case 1:
            textColor = UIColor.blue
            background = UIColor.systemYellow
        case 2:
            textColor = UIColor.white
            background = UIColor.black
        default:
            textColor = UIColor.black
            background = UIColor.white
        }
        
        sampleTable.reloadData()
    }
    
    @IBAction func resetTapped(_ sender: UIBarButtonItem) {
        themeTabs.selectedSegmentIndex = 0
        
        textColor = UIColor.black
        background = UIColor.white
        
        sampleTable.reloadData()
    }
    
    @IBAction func saveAndPop(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(colorSet: [textColor, background], forKey: "themeColors")
        
        performSegue(withIdentifier: "To_Root", sender: sender)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
