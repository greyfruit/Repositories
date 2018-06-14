//
//  SearchTableViewController.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var searchService: RepositoriesSearchServiceProtocol!
    var searchResultsController: RepositoriesSearchResultsController!
    
    var cachedQueries: [String] {
        return self.searchService.cachedQueries()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        self.navigationItem.searchController = {
            
            let searchController = UISearchController(searchResultsController: self.searchResultsController)
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = true
            searchController.searchResultsUpdater = self
            searchController.searchBar.delegate = self
            searchController.delegate = self
            
            return searchController
        }()
    }
}

private extension SearchTableViewController {
    
    func updateSearchResults(with searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            self.searchService.search(with: searchText) { (repositories) in
                self.searchResultsController.display(repositories: repositories)
            }
        } else {
            self.searchResultsController.invalidate()
        }
    }
    
    func invalidateSearchResults() {
        self.searchService.cancel()
        self.searchResultsController.invalidate()
    }
}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
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

extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cachedQueries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView
            .dequeueReusableCell(withType: QueryTableViewCell.self, for: indexPath)
            .configured(with: self.cachedQueries[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if let searchController = self.navigationItem.searchController {
            searchController.searchBar.text = self.cachedQueries[indexPath.row]
            searchController.isActive = true
        }
    }
}
