//
//  TableViewController.swift
//  ZhongHaoCE05
//
//  Created by Hao Zhong on 7/14/21.
//

import UIKit

class TableViewController: UITableViewController {
// All members from initial download
    var congress = [Congressman]()
    
    // Container to hold members filtered by different parties
    var filteredPartyMembers = [[Congressman](), [Congressman](), [Congressman]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        downloadJSON(chamber: "senate")
        downloadJSON(chamber: "house")
    }

    func downloadJSON(chamber: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        if let validURL = URL(string: "https://api.propublica.org/congress/v1/117/\(chamber)/members.json") {
            var request = URLRequest(url: validURL)
            // Set the header values
            request.setValue("Fz0SnQCjxlyprLyqWlVTBw8O5VUezqa9zmV1gc0l", forHTTPHeaderField: "X-API-Key")
            // Request type
            request.httpMethod = "GET"
            
            // Create task with request, not url
            let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
                // Bail out on error
                if error != nil {return}
                
                // Check the response, statusCode, and data
                guard let result = response as? HTTPURLResponse,
                      result.statusCode == 200,
                      let info = data
                else {return}
                
                do {
                    // De-serialize data
                    if let json = try JSONSerialization.jsonObject(with: info, options: .mutableContainers) as? [String: Any] {
                        guard let results = json["results"] as? [Any],
                              let secondLevelItem = results[0] as? [String: Any],
                              let members = secondLevelItem["members"] as? [Any]
                              else {return}
                        
                        // Loop through members array, here is where the actual members list is
                        for member in members {
                            guard let congressMember = member as? [String: Any]
                            else { return }
                            
                            do {
                                let newMember = try Congressman(jsonAPIData: congressMember)
                                self.congress.append(newMember)
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        }
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                // Load UI
                DispatchQueue.main.async {
                    self.filterMembersByParty()
                    self.tableView.reloadData()
                }
            })
            
            task.resume()
        }
    }
    
    func filterMembersByParty() {
        filteredPartyMembers[0] = congress.filter({$0.party == "R"})
        filteredPartyMembers[1] = congress.filter({$0.party == "D"})
        filteredPartyMembers[2] = congress.filter({$0.party == "ID"})
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredPartyMembers[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cast the reusable cell to our custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? ProPublicaCell
        else {
            return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        }
        
        // Configure the cell...
        let currentMember = filteredPartyMembers[indexPath.section][indexPath.row]
        
        cell.name.text = currentMember.lastCommaFirstName
        cell.title.text = currentMember.title
        cell.partyState.text = currentMember.party + " - " + currentMember.state
        
        if currentMember.party == "R" {
            cell.backgroundColor = UIColor.red
            cell.name.textColor = UIColor.white
            cell.title.textColor = UIColor.white
            cell.partyState.textColor = UIColor.white
            
        } else if currentMember.party == "D" {
            cell.backgroundColor = UIColor.blue
            cell.name.textColor = UIColor.white
            cell.title.textColor = UIColor.white
            cell.partyState.textColor = UIColor.white
            
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        
        return cell
    }
    
// MARK: - Header Methods
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Republicans"
        case 1:
            return "Democrats"
        case 2:
            return "Independents"
        default:
            return "Oops should not get here"
        }
    }
    
    // Set header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let memberToSend = filteredPartyMembers[indexPath.section][indexPath.row]
            
            // Get the new view controller using segue.destination.
            if let destination = segue.destination as? DetailViewController {
                // Pass the selected object to the new view controller.
                destination.congressMember = memberToSend
                
            }
        }
        
    }
    

}
