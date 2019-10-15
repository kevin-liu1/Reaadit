//
//  ProfileCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-11.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileCell: UITableViewCell {
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var displayName: UILabel!
    
    @IBOutlet var postKarma: UILabel!
    
    @IBOutlet var commentKarma: UILabel!
    
    func setUp(profilecell: ProfileHolder) {
        profileImage.sd_setImage(with: URL(string: profilecell.icon_img), placeholderImage: UIImage(named: "Ash-Grey"))
        profileImage.layer.cornerRadius = 25
        
        userName.text = profilecell.name
        displayName.text = profilecell.display_name
        postKarma.text = String(profilecell.link_karma)
        commentKarma.text = String(profilecell.comment_karma)
        
    }
    
}
