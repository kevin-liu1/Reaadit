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
    var data: Comment
    
//    enum CodingKeys: String, CodingKey {
//    case kind = "t1"
//    case data
//    }
}

struct Comment: Codable {
    var ups: Int?
    var author: String?
    var body: String?
}


