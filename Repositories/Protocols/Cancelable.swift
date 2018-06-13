//
//  Cancelable.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

protocol Cancelable {
    func cancel()
}

extension URLSessionTask: Cancelable { }
