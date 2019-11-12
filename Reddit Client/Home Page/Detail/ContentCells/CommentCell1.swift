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
import SwiftyJSON

protocol linkHandlingProtocol {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

class CommentCell1: UITableViewCell, UITextViewDelegate {
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
        self.timeLabel.text = Network().soMuchTimeAgo(postedDate: comment.time)
        
    }
}



class GenerateComments {
    var comments: [AttributedTextComment]! = []
    //static var Json = Data()

    static func generate(size: Int = 5, maximumChildren: Int = 4, json: Data) -> GenerateComments {
        let discussion = GenerateComments()
        for commentIndex in 0 ..< size {
            var rootComment = randomComent(commentIndex, json: json)
            let replyJson = JSON(json)
            let nextJson = replyJson[1]["data"]["children"][commentIndex]["data"]["replies"]
            addReplyRecurs(&rootComment, maximumChildren: maximumChildren, currentJson: nextJson)
            discussion.comments.append(rootComment)
        }
        return discussion
    }

    static func randomComent(_ commentIndex: Int, json: Data) -> AttributedTextComment {
        let com = AttributedTextComment()
        let commentjson = JSON(json)
        com.id = commentjson[1]["data"]["children"][commentIndex]["data"]["id"].string
        com.body = commentjson[1]["data"]["children"][commentIndex]["data"]["body"].string
        com.posterName = commentjson[1]["data"]["children"][commentIndex]["data"]["author"].string
        com.postedDate = commentjson[1]["data"]["children"][commentIndex]["data"]["created_utc"].int
        com.upvotes = commentjson[1]["data"]["children"][commentIndex]["data"]["ups"].int
        //com.title = commentjson[1]["data"]["children"][commentIndex]["data"]["ups"].string
        //print(com.body)
        //com.downvotes = Int(arc4random_uniform(100)) + 1
        //com.title = Lorem.sentence
        return com
    }
    
    static func replyComment(replyJson: JSON, commentIndex: Int) -> AttributedTextComment? {
        let com = AttributedTextComment()
        com.id = replyJson["data"]["children"][commentIndex]["data"]["id"].string
        com.body = replyJson["data"]["children"][commentIndex]["data"]["body"].string
        com.posterName = replyJson["data"]["children"][commentIndex]["data"]["author"].string
        com.postedDate = replyJson["data"]["children"][commentIndex]["data"]["created_utc"].int
        com.upvotes = replyJson["data"]["children"][commentIndex]["data"]["ups"].int
        com.id = replyJson["data"]["children"][commentIndex]["data"]["id"].string
        com.isFolded = false
        
//        print(com.posterName)
        //print(com.body)
        if com.body == nil {
            return nil
        } else {
            return com
        }
    }

    private static func addReplyRecurs( _ parent: inout AttributedTextComment, maximumChildren: Int, currentJson: JSON) {
        if maximumChildren == 0 { return }
        
        //for the comments in same layer
        for i in 0...(5) {
            if var com = replyComment(replyJson: currentJson, commentIndex: i) {
                parent.addReply(com)
                com.replyTo = parent
                com.level = parent.level+1
//                print(com.level)
//                print(com.body)
                let nextjson = currentJson["data"]["children"][i]["data"]["replies"]
                
                
                //for comments in next layer
                addReplyRecurs(&com, maximumChildren: maximumChildren-1, currentJson: nextjson)
//                if nextjson.string != "" {
//                    addReplyRecurs(&com, maximumChildren: maximumChildren-1, currentJson: nextjson)
//                } else {
//                    return
//                }
            } else {
                //print("nah")
                return
            }


        }
    }
}


class AttributedTextComment: RichComment {
    var attributedContent: NSAttributedString?
}

class RichComment: BaseComment {
    var id: String?
    var upvotes: Int?
    var downvotes: Int?
    var body: String?
    var title: String?
    var posterName: String?
    var postedDate: Int? // epochtime (since 1970)
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
        let diff = Date().timeIntervalSince1970 - Double(self.postedDate!)
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
