//
//  Reusable.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit

protocol Reusable {
    
    static var reuseIdentifier: String { get }
}

extension Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable { }

extension UITableView {
    
    func register(_ cellType: Reusable.Type) {
        self.register(UINib(nibName: cellType.reuseIdentifier, bundle: nil), forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<T>(withType type: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
