//
//  Decoder.swift
//  Repositories
//
//  Created by Ivan Petrukha on 14.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

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
