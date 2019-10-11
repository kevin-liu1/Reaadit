//
//  ContentType.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-09.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

//Models For Content

struct Content {
    var author: String
    var postTitle: String
    var upVoteCount: Int
    var time: String
    var selftext: String
    var thumbnail: String
}

struct ContentImage {
    var author: String
    var postTitle: String
    var upVotecount: Int
    var time: String
    var image: String
    
}

struct ContentLink {
    var author: String
    var postTitle: String
    var upVotecount: Int
    var time: String
    var link: String
    var thumbnail: String
}

struct ContentVideo {
    var author: String
    var postTitle: String
    var upVotecount: Int
    var time: String
    var link: String
    var videolink: String
}
