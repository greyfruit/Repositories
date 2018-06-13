//
//  Repository.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

struct Repository: Codable, Hashable {
    
    struct Owner: Codable, Hashable {
        
        let id: Int
        let login: String
        let avatarUrl: String
        
        var hashValue: Int {
            return self.id.hashValue
        }
    }
    
    let id: Int
    let url: String
    let name: String
    let owner: Owner
    let score: Double
    let stargazersCount: Int
    let description: String?
    let htmlUrl: String
    
    var hashValue: Int {
        return self.id.hashValue
    }
}
