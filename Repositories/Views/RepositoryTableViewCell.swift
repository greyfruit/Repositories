//
//  RepositoryTableViewCell.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.text = nil
        self.descriptionLabel.text = nil
        self.avatarImageView.image = nil
    }
}

extension RepositoryTableViewCell: Configurable {
    
    func configure(with repository: Repository) {
        
        self.nameLabel.text = repository.name
        self.descriptionLabel.text = repository.description
        
        DispatchQueue.global(qos: .background).async {
            if let imageURL = URL(string: repository.owner.avatarUrl), let imageData = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    self.avatarImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
}
