//
//  Configurable.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

protocol Configurable: class {
    
    associatedtype Configurator
    
    func configure(with configurator: Configurator)
}

extension Configurable {
    
    func configured(with configurator: Configurator) -> Self {
        
        self.configure(with: configurator)
        
        return self
    }
}
