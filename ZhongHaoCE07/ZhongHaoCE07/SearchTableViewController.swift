//
//  SearchTableViewController.swift
//  ZhongHaoCE07
//
//  Created by Hao Zhong on 7/22/21.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        // Using the variable searchController, we will filter the incoming array using searchBar text and the scope title selected. Then the result is stored in the filteredArray variable.
        // Get the user entered text
        let searchText = searchController.searchBar.text
        
        // Get the scope selected
        let scopeSelected = searchController.searchBar.selectedScopeButtonIndex
        let allScopeTitles = searchController.searchBar.scopeButtonTitles!
        let selectedTitle = allScopeTitles[scopeSelected]
        
        // Filter our content
        filteredArray = allCities
        
        if searchText != "" {
            // Add on a feature to search by zip codes
            if Int(searchText!) != nil {
                filteredArray = filteredArray.filter({$0.zip.range(of: searchText!) != nil})
            } else {
                filteredArray = filteredArray.filter({$0.name.lowercased().range(of: searchText!.lowercased()) != nil})
            }
        }
        
        if selectedTitle != "All" {
            filteredArray = filteredArray.filter({$0.state.range(of: selectedTitle) != nil})
        }
        
        tableView.reloadData()
    }
    
    @IBAction func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResults(for: searchController)
        searchController.dismiss(animated: true, completion: {self.performSegue(withIdentifier: "Done_with_search", sender: self)})
    }
    
    // Use the current ViewController to display the search result
    var searchController = UISearchController(searchResultsController: nil)
    var filteredArray = [City]()
    var allCities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup search controller
        searchController.definesPresentationContext = true
        searchController.searchResultsUpdater = self
        
        // Setup searchBar and scope
        searchController.searchBar.scopeButtonTitles = ["All", "FL", "IL"]
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        updateSearchResults(for: searchController)
    }

    // Delegate method for when user changes the scope.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_reuseid_2", for: indexPath) as! CustomCell2

        // Configure the cell...
        cell.title2?.text = filteredArray[indexPath.row].name + ", " + filteredArray[indexPath.row].state
        cell.detail2?.text = "Population: \(filteredArray[indexPath.row].population)"
        cell.info2?.text = "Zip: " + filteredArray[indexPath.row].zip
        
        // Return configured cell
        return cell
    }

}
