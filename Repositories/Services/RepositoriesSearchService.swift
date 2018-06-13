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
    private let storage: Storage
    
    init(searchProvider: RepositoriesSearchProviderProtocol, storage: Storage) {
        self.searchProvider = searchProvider
        self.storage = storage
    }
    
    private var runningOperations: [Cancelable] = []
    private let firstSearchQueue = DispatchQueue(label: "firstSearchQueue")
    private let secondSearchQueue = DispatchQueue(label: "secondSearchQueue")
    
    func search(with query: String, completion: @escaping (([Repository]) -> Void)) {
        
        self.cancel()
        
        var searchResults = [Repository]()
        let dispatchGroup = DispatchGroup()
//        let firstSearchQueue = DispatchQueue(label: "firstSearchQueue")
//        let secondSearchQueue = DispatchQueue(label: "secondSearchQueue")
        
        func search(in queue: DispatchQueue, group: DispatchGroup, completion: @escaping (([Repository]) -> Void)) {
            group.enter()
            queue.async {
                self.runningOperations.append(
                    self.searchProvider.search(with: query) { (repositories) in
                        completion(repositories)
                        group.leave()
                    }
                )                
            }
        }
        
        if let repositories = try? self.storage.retrieve([Repository].self, for: query) {
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
            
            self.cancel()
            
            let repositories = searchResults
                .unique()
                .sorted(by: { $0.score > $1.score })
            
            try? self.storage.store(
                repositories,
                for: query
            )
            
            self.cache(
                query: query
            )
            
            completion(repositories)
        }
    }
    
    func cachedQueries() -> [String] {
        return (try? self.storage.retrieve([String].self, for: "cachedQueries")) ?? []
    }
    
    func cache(query: String) {
        var cachedQueries = self.cachedQueries()
        cachedQueries.append(query)
        try? self.storage.store(cachedQueries.unique(), for: "cachedQueries")
    }
    
    func cancel() {
        
        defer {
            self.runningOperations.removeAll()
        }
        
        self.runningOperations.forEach {
            $0.cancel()
        }
    }
}
