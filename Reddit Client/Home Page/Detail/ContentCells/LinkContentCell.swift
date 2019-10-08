//
//  LinkContentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

class LinkContentCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var buttonLabel: UIButton!
    
    @IBOutlet var upvoteLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    func setContent(contentLink: ContentLink) {
        self.titleLabel.text = contentLink.postTitle
        buttonLabel.titleLabel?.text = contentLink.link
        upvoteLabel.text = String(contentLink.upVotecount)
        timeLabel.text = contentLink.time
    }
}
