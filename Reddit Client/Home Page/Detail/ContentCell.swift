//
//  ContentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-05.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    
    @IBOutlet weak var upvoteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    
    func setContent(Content: Content) {
        upvoteLabel.text = String(Content.upVoteCount)
        timeLabel.text = Content.time
        postTitleLabel.text = Content.postTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
