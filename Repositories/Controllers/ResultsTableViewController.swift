//
//  ResultsTableViewController.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    let searchService: RepositoriesSearchServiceProtocol = RepositoriesSearchService(
        searchProvider: RepositoriesSearchProvider(baseURL: URL(string: "https://api.github.com/")!),
        storage: LocalStorage()
    )
        
    var results: [String] {
        return self.searchService.cachedQueries()
    }
    
    let repositoriesTableViewController = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "RepositoriesTableViewController") as! RepositoriesTableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        self.navigationItem.searchController = {
            
            let searchController = UISearchController(searchResultsController: self.repositoriesTableViewController)
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.showsCancelButton = false
            searchController.searchBar.delegate = self
            searchController.searchResultsUpdater = self
            searchController.isActive = true
            searchController.delegate = self
            
            return searchController
        }()
    }
    
    func updateSearchResults(with searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            self.searchService.search(with: searchText) { (repositories) in
                self.repositoriesTableViewController.repositories = repositories
            }
        } else {
            self.repositoriesTableViewController.repositories.removeAll()
        }
    }
    
    func invalidateSearchResults() {
        self.searchService.cancel()
        self.repositoriesTableViewController.repositories.removeAll()
    }
}

extension ResultsTableViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.tableView.reloadData()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.updateSearchResults(with: searchController.searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.updateSearchResults(with: searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.invalidateSearchResults()
    }
}

extension ResultsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = self.results[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let searchController = self.navigationItem.searchController {
            searchController.searchBar.text = self.results[indexPath.row]
            searchController.isActive = true
        }
    }
}
