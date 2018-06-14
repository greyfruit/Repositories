//
//  RepositoriesSearchService.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

protocol RepositoriesSearchServiceProtocol {
    func search(with query: String, completion: @escaping (([Repository]) -> Void))
    func cachedQueries() -> [String]
    func cancel()
}

class RepositoriesSearchService: RepositoriesSearchServiceProtocol {
    
    private let searchProvider: RepositoriesSearchProviderProtocol
    private let searchStorage: RepositoriesSearchStorageProtocol
    
    init(searchProvider: RepositoriesSearchProviderProtocol, searchStorage: RepositoriesSearchStorageProtocol) {
        self.searchProvider = searchProvider
        self.searchStorage = searchStorage
    }
    
    private var runningRequests: [Cancelable] = []
    private let firstSearchQueue = DispatchQueue(label: "firstSearchQueue")
    private let secondSearchQueue = DispatchQueue(label: "secondSearchQueue")
    
    func search(with query: String, completion: @escaping (([Repository]) -> Void)) {
        
        self.cancel()
        
        var searchResults = [Repository]()
        let dispatchGroup = DispatchGroup()
        
        func search(in queue: DispatchQueue, group: DispatchGroup, completion: @escaping (([Repository]) -> Void)) {
            group.enter()
            queue.async {
                self.runningRequests.append(
                    self.searchProvider.search(with: query) { (repositories) in
                        completion(repositories)
                        group.leave()
                    }
                )                
            }
        }
        
        if let repositories = self.searchStorage.retrieveRepositories(for: query) {
            completion(repositories)
        }
        
        search(in: firstSearchQueue, group: dispatchGroup) { (repositories) in
            searchResults.append(
                contentsOf: repositories.prefix(15)
            )
        }
        
        search(in: secondSearchQueue, group: dispatchGroup) { (repositories) in
            searchResults.append(
                contentsOf: repositories.suffix(15)
            )
        }
        
        dispatchGroup.notify(queue: .global(qos: .background)) {
            
            self.runningRequests.removeAll()
            
            let repositories = searchResults
                .unique()
                .sorted(by: { $0.stargazersCount > $1.stargazersCount })
            
            self.searchStorage.store(
                repositories: repositories,
                for: query
            )
            
            completion(repositories)
        }
    }
    
    func cachedQueries() -> [String] {
        return self.searchStorage.cachedQueries()
    }
    
    func cancel() {
        self.runningRequests.forEach { $0.cancel() }
        self.runningRequests.removeAll()
    }
}
