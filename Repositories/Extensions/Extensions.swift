//
//  Extensions.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

// Usualy I create separated files for every type, but its overhead for this case

extension Array where Element: Hashable {
    func unique() -> Array<Element> {
        return Array(Set(self))
    }
}

extension JSONEncoder {
    
    static var `default`: JSONEncoder {
        return JSONEncoder()
    }
}

extension JSONDecoder {
    
    static var `default`: JSONDecoder {
        return JSONDecoder()
    }
    
    static var fromSnakeCase: JSONDecoder {
        let decoder = JSONDecoder()        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
