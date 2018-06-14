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
        let avatarUrl: String
        
        var hashValue: Int {
            return self.id.hashValue
        }
    }
    
    let id: Int
    let name: String
    let owner: Owner
    let htmlUrl: String
    let description: String?
    let stargazersCount: Int
    
    var hashValue: Int {
        return self.id.hashValue
    }
}
