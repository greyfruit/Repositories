//
//  RepositoriesTableViewController.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit

typealias RepositoriesSearchResultsController = RepositoriesDisplayer & UIViewController

protocol RepositoriesDisplayer {
    func display(repositories: [Repository])
    func invalidate()
}

class RepositoriesTableViewController: UITableViewController {
    
    var repositories: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let webViewController = segue.destination as? WebViewController, let repository = sender as? Repository {
            
            webViewController.urlPath = repository.htmlUrl
            webViewController.preferredContentSize = CGSize(width: self.view.bounds.width * 0.85, height: self.view.bounds.height * 0.75)
            
            if let popoverPresentationController = webViewController.popoverPresentationController {
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0.0, height: 0.0)
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.delegate = self
            }
        }
    }
}

extension RepositoriesTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension RepositoriesTableViewController: RepositoriesDisplayer {
    
    func display(repositories: [Repository]) {
        self.repositories = repositories
    }
    
    func invalidate() {
        self.repositories = []
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
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        self.performSegue(withIdentifier: "toWebViewController", sender: self.repositories[indexPath.row])
    }
}
