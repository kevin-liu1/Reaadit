//
//  Comment.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

struct CommentType {
    var author: String
    var upvotes: Int
    var time: String //keep it as a string for now
    var textbody: String
}

//we will use a class to store the tree that is the comments

class CommentTree {
    var author: String?
    var upvotes: Int?
    var time: String? //keep it as a string for now
    var textbody: String?
    var replies: [CommentTree]?
    
    init(author: String, upVotes: Int, time: String, textbody: String) {
        self.author = author
        self.upvotes = upVotes
        self.time = time
        self.textbody = textbody
    }
}
