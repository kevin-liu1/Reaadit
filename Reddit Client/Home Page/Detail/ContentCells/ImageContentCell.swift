//
//  ImageContentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-09.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

class ImageContentCell: UITableViewCell {

    
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var contentImage: UIImageView!
    
    @IBOutlet var postTitleLabel: UILabel!
    

    @IBOutlet var upvoteLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    
    func setContent(content: ContentImage) {
        authorLabel.text = content.author
        contentImage.sd_setImage(with: URL(string: content.image), placeholderImage: UIImage(named: "Ash-Grey"))
        contentImage.layer.cornerRadius = 7
        
        postTitleLabel.text = content.postTitle
        upvoteLabel.text = String(content.upVotecount)
        timeLabel.text = "10"
        
    }
}
