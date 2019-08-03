//
//  RepositoryTableViewCell.swift
//  testTask
//
//  Created by Danil Shchegol on 8/3/19.
//  Copyright © 2019 Danil Shchegol. All rights reserved.
//

import UIKit
import SDWebImage

final class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func configure(with repository: Repository?) {
        guard let url = repository?.repURL else { return }
        nameLabel.text = repository?.name
        urlLabel.text = "\(url)"
        avatarImageView.sd_setImage(with: URL(string: repository?.avatarURL ?? ""), completed: nil)
    }
}
