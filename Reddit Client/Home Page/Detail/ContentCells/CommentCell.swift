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
import SwiftyComments

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

class AttributedTextComment: RichComment {
    var attributedContent: NSAttributedString?
}

class RichComment: BaseComment {
    var id: Int?
    var upvotes: Int?
    var downvotes: Int?
    var body: String?
    var title: String?
    var posterName: String?
    var postedDate: Double? // epochtime (since 1970)
    var upvoted: Bool = false
    var downvoted: Bool = false
    var isFolded: Bool = false
    
    /**
     Express the postedDate in following format: "[x] [time period] ago"
     */
    func soMuchTimeAgo() -> String? {
        if self.postedDate == nil {
            return nil
        }
        let diff = Date().timeIntervalSince1970 - self.postedDate!
        var str: String = ""
        if  diff < 60 {
            str = "now"
        } else if diff < 3600 {
            let out = Int(round(diff/60))
            str = (out == 1 ? "1 minute ago" : "\(out) minutes ago")
        } else if diff < 3600 * 24 {
            let out = Int(round(diff/3600))
            str = (out == 1 ? "1 hour ago" : "\(out) hours ago")
        } else if diff < 3600 * 24 * 2 {
            str = "yesterday"
        } else if diff < 3600 * 24 * 7 {
            let out = Int(round(diff/(3600*24)))
            str = (out == 1 ? "1 day ago" : "\(out) days ago")
        } else if diff < 3600 * 24 * 7 * 4{
            let out = Int(round(diff/(3600*24*7)))
            str = (out == 1 ? "1 week ago" : "\(out) weeks ago")
        } else if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4)))
            str = (out == 1 ? "1 month ago" : "\(out) months ago")
        } else {//if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4*12)))
            str = (out == 1 ? "1 year ago" : "\(out) years ago")
        }
        return str
    }
}

class BaseComment: AbstractComment {
    var replies: [AbstractComment]! = []
    var level: Int!
    weak var replyTo: AbstractComment?
    
    convenience init() {
        self.init(level: 0, replyTo: nil)
    }
    init(level: Int, replyTo: BaseComment?) {
        self.level = level
        self.replyTo = replyTo
    }
    func addReply(_ reply: BaseComment) {
        self.replies.append(reply)
    }
    
}
