//
//  ProfileCommentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-14.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import MarkdownKit

class ProfileCommentCell: UITableViewCell {
    
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var commentBody: UITextView!
    @IBOutlet var upVoteLabel: UILabel!
    
    func setContent(profileComment: CommentType) {
        
        self.authorLabel.text = profileComment.author
        let markdownParser = MarkdownParser(font: UIFont.systemFont(ofSize: 15))
        self.upVoteLabel.text = String(profileComment.upvotes)
        self.timeLabel.text = "NA"
        self.commentBody.attributedText = markdownParser.parse(profileComment.textbody)
    }
}
