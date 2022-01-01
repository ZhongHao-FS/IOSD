//
//  SubredditsViewController.swift
//  ZhongHaoCE08
//
//  Created by Hao Zhong on 7/24/21.
//

import UIKit

class SubredditsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subredditsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use the prototype cell#2
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_ID_2", for: indexPath)
        
        // Configure cell
        cell.textLabel?.text = subredditsList[indexPath.row]
        
        // Return configured cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subredditsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBOutlet weak var redditsTable: UITableView!
    @IBOutlet weak var textEntry: UITextField!
    
    var subredditsList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let savedList = UserDefaults.standard.object(forKey: "subredditNames") as? [String] {
            subredditsList = savedList
        } else {
            subredditsList.append("movies")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        if textEntry?.text != "" {
            if let keyWord = textEntry?.text {
                subredditsList.append(keyWord)
            }
        }
        
        textEntry.text = ""
        redditsTable.reloadData()
    }
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(subredditsList, forKey: "subredditNames")
        
        performSegue(withIdentifier: "Save_Subreddits", sender: sender)
    }
    
    @IBAction func resetList(_ sender: UIBarButtonItem) {
        subredditsList = ["movies"]
        redditsTable.reloadData()
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
