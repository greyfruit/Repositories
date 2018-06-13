//
//  RepositoriesTableViewController.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit

class RepositoriesTableViewController: UITableViewController {
    
    let searchService: RepositoriesSearchServiceProtocol = RepositoriesSearchService(
        searchProvider: RepositoriesSearchProvider(baseURL: URL(string: "https://api.github.com/")!),
        storage: LocalStorage()
    )
    
    var repositories: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.definesPresentationContext = true
//        self.navigationItem.searchController = {
//
//            let searchController = UISearchController(searchResultsController: nil)
//            searchController.hidesNavigationBarDuringPresentation = false
//            searchController.dimsBackgroundDuringPresentation = false
//            searchController.searchBar.showsCancelButton = false
//            searchController.searchBar.delegate = self
//            searchController.searchResultsUpdater = self
//            searchController.delegate = self
//
//            return searchController
//        }()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        DispatchQueue.main.async {
//            self.navigationItem.searchController?.isActive = true
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let webViewController = segue.destination as? WebViewController, let popoverPresentationController = webViewController.popoverPresentationController {
            webViewController.preferredContentSize = CGSize(width: self.view.bounds.width * 0.85, height: self.view.bounds.height * 0.75)
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0.0, height: 0.0)
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.delegate = self
        }
    }
}

extension RepositoriesTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension RepositoriesTableViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchService.cancel()
        self.repositories.removeAll()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchService.search(with: searchBar.text ?? "") { (repositories) in
            self.repositories = repositories
        }
    }
}

extension RepositoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView
            .dequeueReusableCell(withType: RepositoryTableViewCell.self, for: indexPath)
            .configured(with: self.repositories[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "popoverSegue", sender: tableView.cellForRow(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
