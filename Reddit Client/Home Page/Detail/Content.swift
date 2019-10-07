//
//  Content.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-05.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

struct Content {
    var postTitle: String
    var upVoteCount: Int
    var time: String
    var selftext: String
    var thumbnail: String
}



struct PostKind: Codable {
    var kind: String
    var data: CommentData
}

struct CommentData: Codable{
    //var modhash: String
    //var dist: Int
    var children = [CommentKind]()
    
}

struct CommentKind: Codable {
    var kind: String
    var data: ContentorComment
    
}


struct ContentorComment: Codable {
    //
    
    //for Comment
    var author: String?
    var body: String?
    
    //for Content
    var title: String?
    var is_self: Bool?
    var post_hint: String? // This tells you what kind of post it is.
    var selftext: String? //If this is not empty then Content is a Title + Body Type
    var thumbnail: String?
    
    
    //for both
    var ups: Int?
    
    //var replies: PostKind?
}



