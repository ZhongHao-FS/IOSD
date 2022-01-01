//
//  MainTableViewController.swift
//  ZhongHaoCE06
//
//  Created by Hao Zhong on 7/16/21.
//

import UIKit

class MainTableViewController: UITableViewController {

    var stores = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelectionDuringEditing = true

        // Register xib
        let headerNib = UINib.init(nibName: "CustomHeader", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "header_ID1")
        
        // Get the path to the .json file
        if let path = Bundle.main.path(forResource: "ShoppingLists", ofType: ".json") {
            
            // Create url from the path
            let url = URL(fileURLWithPath: path)
            
            do {
                // Create a data object from the url
                let data = try Data.init(contentsOf: url)
                
                // Create a json object and cast it as an any type array
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any]
                
                // Parse through jsonObj and instantiate objects
                Parse(jsonObject: jsonObj)
            } catch {
                print(error.localizedDescription)
            }
            
            // Display data
            tableView.reloadData()
        }
        
    }

    func Parse(jsonObject: [Any]?) {
        // Bind the optional jsonObject to the non-optional json
        if let jsonObj = jsonObject {
            // Loop through every first level item in the JSON array
            for firstLevelItem in jsonObj {
                // Optional unwrap all these items, return if any of them cannot be unwrapped
                guard let object = firstLevelItem as? [String: Any],
                      let shop = object["name"] as? String,
                      let list = object["shoppingList"] as? [Any]
                else {continue}
                
                // Create a local variable to temporarily hold the object
                let store = Store(storeName: shop)
                for secondLevelItem in list {
                    guard let item = secondLevelItem as? [String: Any],
                          let name = item["name"] as? String,
                          let done = item["purchased"] as? Bool
                          else {continue}
                    
                    let grocery = Item(name: name)
                    grocery.purchased = done
                    // Append each item to a store's shopping list
                    store.shoppingList.append(grocery)
                }
                // Append each store to the stores array
                self.stores.append(store)
            }
        }
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Store", message: "Enter the name of the store below", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let answer = alert.textFields?[0].text {
                self.stores.append(Store(storeName: answer))
                self.tableView.reloadData()
            }
        })
        saveAction.isEnabled = false
        alert.addAction(saveAction)
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { _ in
                saveAction.isEnabled = textField.hasText
            })
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.rightBarButtonItem?.title = "Done"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashAllSelected))
        } else {
            navigationItem.setLeftBarButtonItems(nil, animated: true)
            navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    @objc func trashAllSelected() {
        let alert = UIAlertController(title: "Delete Stores", message: "Are you sure you want to delete these stores?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            if var selectedIPs = self.tableView.indexPathsForSelectedRows {
                // Sort in large to small index numbers to remove items from back to front
                selectedIPs.sort(by: { (a, b) -> Bool in
                    a.row > b.row
                })
                
                for indexpath in selectedIPs {
                    // Update the stores list first
                    self.stores.remove(at: indexpath.row)
                }
                // Simply reload to remove the selected rows in tableview
                self.tableView.reloadData()
            }
        })
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stores.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 118
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create the view
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header_ID1") as? CustomHeaderView
        
        // Configure the view
        header?.headerTitle.text = "My Stores"
        header?.headerCount.text = "Stores: \(self.stores.count)"
        header?.headerEditButton.isHidden = true
        
        // Return the view
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier_1", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.stores[indexPath.row].name
        cell.detailTextLabel?.text = "Needed: \(self.stores[indexPath.row].itemsNeeded)"
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Store", message: "Are you sure you want to delete this store?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                // Delete the data and the row from tableView
                self.stores.remove(at: indexPath.row)
                tableView.reloadData()
            })
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        // Get the new view controller using segue.destination.
        if let destination = segue.destination as? StoreTableViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                // Pass the selected object to the new view controller.
                destination.store = self.stores[indexPath.row]
                destination.storeIndex = indexPath.row
            }
        }
        
    }
    
    // Prevent the segue from happening when you are editing the tableview
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tableView.isEditing {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func save(segue: UIStoryboardSegue) {
        if let source = segue.source as? StoreTableViewController {
            // Pass back the edited store to MainTableViewController's store list
            self.stores[source.storeIndex] = source.store
            tableView.reloadData()
        }
    }
}
