//
//  ContentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
import UIKit
import Nantes
import MarkdownKit

class ContentCellSelf: UITableViewCell {

    
    @IBOutlet weak var upvoteLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    //@IBOutlet weak var bodyTextLabel: UILabel?
    
    @IBOutlet var bodyTextLabel: UITextView!
    
    
    @IBOutlet var postTitleLabel: UILabel!
    
    func setContent(Content: Content) {
        upvoteLabel.text = String(Content.upVoteCount)
        timeLabel.text = Content.time
        
        let markdownParser = MarkdownParser(font: UIFont.systemFont(ofSize: 15))
        
        postTitleLabel.text = Content.postTitle
        //setupTitleLabel(markdownText: markdownParser.parse(Content.postTitle), content: Content)
        bodyTextLabel?.attributedText = markdownParser.parse(Content.selftext)
    }
    
//    func setupTitleLabel(markdownText: NSAttributedString, content: Content) {
//        //postTitleLabel.attributedTruncationToken = NSAttributedString(string: "... more")
//        postTitleLabel.numberOfLines = 3
//        postTitleLabel.labelTappedBlock = {
//            self.postTitleLabel.numberOfLines = self.postTitleLabel.numberOfLines == 0 ? 3 : 0 // Flip between limiting lines and not
//
//            UIView.animate(withDuration: 0.2, animations: {
//            self.contentView.layoutIfNeeded()
//          })
//        }
//
//        postTitleLabel.text = content.postTitle
        
        
    }


