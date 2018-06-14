//
//  QueryTableViewCell.swift
//  Repositories
//
//  Created by Ivan Petrukha on 14.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit

class QueryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = nil
    }
}

extension QueryTableViewCell: Configurable {
    
    func configure(with query: String) {
        
        self.titleLabel.text = query
    }
}
