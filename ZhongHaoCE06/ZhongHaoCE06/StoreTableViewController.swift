//
//  StoreTableViewController.swift
//  ZhongHaoCE06
//
//  Created by Hao Zhong on 7/16/21.
//

import UIKit

class StoreTableViewController: UITableViewController {

    var store: Store! = nil
    var storeIndex: Int = 0
    var filteredList = [[Item](), [Item]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelectionDuringEditing = true

        // Register xib
        let headerNib = UINib.init(nibName: "CustomHeader", bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "header_ID1")
        
        navigationItem.title = store.name
        
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item", message: "Enter the item name below", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let answer = alert.textFields?[0].text {
                self.store.shoppingList.append(Item(name: answer))
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
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.leftBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashAllSelected)))
        } else {
            navigationItem.leftBarButtonItems?.removeLast()
        }
    }
    
    // Loop through and delete all selected items in edit mode
    @objc func trashAllSelected() {
        let alert = UIAlertController(title: "Delete Items", message: "Are you sure you want to delete these items?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            if let selectedIPs = self.tableView.indexPathsForSelectedRows {
                var names = [String]()
                for indexpath in selectedIPs {
                    // Update the shopping list first
                    names.append(self.filteredList[indexpath.section][indexpath.row].name)
                }
                
                // Sort in large to small index numbers to remove items from back to front
                for i in stride(from: self.store.shoppingList.count - 1, through: 0, by: -1) {
                    if names.contains(self.store.shoppingList[i].name)  {
                        self.store.shoppingList.remove(at: i)
                    }
                }
                self.filterItems()
                
                // Simply reload to remove the selected rows in tableview
                self.tableView.reloadData()
            }
        })
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func filterItems() {
        filteredList[0] = store.shoppingList.filter({$0.purchased == false})
        filteredList[1] = store.shoppingList.filter({$0.purchased == true})
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return store.itemsNeeded
        } else {
            return store.itemsPurchased
        }
        
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 118
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create the view
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header_ID1") as? CustomHeaderView
        
        // Configure the view
        header?.headerAddButton.isHidden = true
        if section == 0 {
            header?.headerTitle.text = "Items Needed"
            header?.headerCount.text = "Total Items: \(self.store.itemsNeeded)"
        } else {
            header?.headerTitle.text = "Purchased Items"
            header?.headerCount.text = "Total Items: \(self.store.itemsPurchased)"
        }
        
        // Return the view
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier_2", for: indexPath)

        self.filterItems()
        // Configure the cell...
        cell.textLabel?.text = self.filteredList[indexPath.section][indexPath.row].name
        if indexPath.section == 0 {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        } else if indexPath.section == 1 {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        return cell
    }

    // Action when tapping a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            for i in 0...store.shoppingList.count - 1 {
                if store.shoppingList[i].name == filteredList[indexPath.section][indexPath.row].name {
                    store.shoppingList[i].purchased = !store.shoppingList[i].purchased
                }
            }
            
            tableView.reloadData()
        }
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
            let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this Item?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                // Delete the row from the data source
                for i in 0...self.store.shoppingList.count - 1 {
                    if self.store.shoppingList[i].name == self.filteredList[indexPath.section][indexPath.row].name {
                        self.store.shoppingList.remove(at: i)
                    }
                }
                self.filterItems()
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

}
