//
//  ContentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
import UIKit

class ContentCellSelf: UITableViewCell {

    @IBOutlet weak var postTitleLabel: UILabel!
    
    @IBOutlet weak var upvoteLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var bodyTextLabel: UILabel?
    
    func setContent(Content: Content) {
        upvoteLabel.text = String(Content.upVoteCount)
        timeLabel.text = Content.time
        postTitleLabel.text = Content.postTitle
        bodyTextLabel?.text = Content.selftext
    }
    
}

class ContentCellRich: UITableViewCell {
    
    @IBOutlet var contentImage: UIImageView!
    
    @IBOutlet var postTitleLabel: UILabel!
    
    @IBOutlet var upvoteLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    func setContent(content: Content) {
        contentImage.sd_setImage(with: URL(string: content.thumbnail), placeholderImage: UIImage(named: "icons8-reddit-100"))
        postTitleLabel.text = content.postTitle
        upvoteLabel.text = String(content.upVoteCount)
        timeLabel.text = "10"
    }
}
