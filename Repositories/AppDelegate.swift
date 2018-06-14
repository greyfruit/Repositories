//
//  AppDelegate.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard
            let navigationController = self.window?.rootViewController as? UINavigationController,
            let searchTableViewController = navigationController.topViewController as? SearchTableViewController,
            let repositoriesTableViewController = UIStoryboard.main.viewController(withType: RepositoriesTableViewController.self)
            else { return false }
        
        let baseURL: URL = URL(string: "https://api.github.com/")!
        let storage: Storage = LocalStorage(fileManager: .default)
        let searchService = RepositoriesSearchService(
            searchProvider: RepositoriesSearchProvider(baseURL: baseURL),
            searchStorage: RepositoriesSearchStorage(storage: storage)
        )
        
        searchTableViewController.searchService = searchService
        searchTableViewController.searchResultsController = repositoriesTableViewController
        
        return true
    }
}
