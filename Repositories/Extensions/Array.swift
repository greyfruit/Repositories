//
//  Array.swift
//  Repositories
//
//  Created by Ivan Petrukha on 14.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

extension Array {
    func appending(_ newElement: Element) -> Array {
        var arrayCopy = Array(self)
        arrayCopy.append(newElement)
        return arrayCopy
    }
}

extension Array where Element: Hashable {
    func unique() -> Array<Element> {
        return Array(Set(self))
    }
}
