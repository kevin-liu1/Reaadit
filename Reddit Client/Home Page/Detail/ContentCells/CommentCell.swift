//
//  CommentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import MarkdownKit
import SafariServices

protocol linkHandlingProtocol {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

class CommentCell: UITableViewCell, UITextViewDelegate {
    var delegate: linkHandlingProtocol!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet var textBodyLabel: UITextView!
    @IBOutlet weak var upVoteButton: UIButton!
    @IBOutlet weak var upVoteLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    func setCommentCell(comment: CommentType) {
        self.authorLabel.text = comment.author
        
        let markdownParser = MarkdownParser(font: UIFont.systemFont(ofSize: 15))
        
        self.textBodyLabel.attributedText = markdownParser.parse(comment.textbody)
        self.upVoteLabel.text = String(comment.upvotes)
        self.timeLabel.text = "NA"
        
    }
    
    
    
}
