//
//  RepositoriesSearchStorage.swift
//  Repositories
//
//  Created by Ivan Petrukha on 14.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

protocol RepositoriesSearchStorageProtocol {    
    func store(repositories: [Repository], for query: String)
    func retrieveRepositories(for query: String) -> [Repository]?
    func cachedQueries() -> [String]
    func cacheQuery(_ query: String)
}

class RepositoriesSearchStorage: RepositoriesSearchStorageProtocol {
    
    let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    private let cachedQueriesKey: String = "cachedQueries"
    
    func store(repositories: [Repository], for query: String) {
        try? self.storage.store(repositories, for: query)
        self.cacheQuery(query)
    }
    
    func retrieveRepositories(for query: String) -> [Repository]? {
        let repositories = try? self.storage.retrieve([Repository].self, for: query)
        return repositories
    }
    
    func cachedQueries() -> [String] {
        let cachedQueries = (try? self.storage.retrieve([String].self, for: self.cachedQueriesKey)) ?? []
        return cachedQueries
    }
    
    func cacheQuery(_ query: String) {
        let cachedQueries = self.cachedQueries().appending(query).unique()
        try? self.storage.store(cachedQueries, for: self.cachedQueriesKey)
    }
}
