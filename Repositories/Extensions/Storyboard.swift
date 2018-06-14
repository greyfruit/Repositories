//
//  Storyboard.swift
//  Repositories
//
//  Created by Ivan Petrukha on 14.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func viewController<T: UIViewController>(withType type: T.Type) -> T? {
        return self.instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
}
