//
//  RepositoriesSearchProvider.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

protocol RepositoriesSearchProviderProtocol {    
    func search(with query: String, completion: @escaping(([Repository]) -> Void)) -> Cancelable
}

class RepositoriesSearchProvider: RepositoriesSearchProviderProtocol {
    
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func search(with query: String, completion: @escaping(([Repository]) -> Void)) -> Cancelable {
        
        var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: true)!
        urlComponents.path = "/search/repositories"
        urlComponents.query = "q=\(query)"
        
        let dataTask = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            
            if let data = data {
                
                struct ResponseModel: Codable {
                    
                    let items: [Repository]
                }
                
                if let responseModel = try? JSONDecoder.fromSnakeCase.decode(ResponseModel.self, from: data) {
                    
                    completion(responseModel.items)
                }
            }
        }
        
        dataTask.resume()
        
        return dataTask
    }
}
