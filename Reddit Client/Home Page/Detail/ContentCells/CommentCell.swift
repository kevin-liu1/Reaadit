//
//  CommentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var textBodyLabel: UILabel!
    
    @IBOutlet weak var upVoteButton: UIButton!
    @IBOutlet weak var upVoteLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    func setCommentCell(comment: CommentType) {
        self.authorLabel.text = comment.author
        self.textBodyLabel.text = comment.textbody
        self.upVoteLabel.text = String(comment.upvotes)
        self.timeLabel.text = "NA"
    }
    

}
