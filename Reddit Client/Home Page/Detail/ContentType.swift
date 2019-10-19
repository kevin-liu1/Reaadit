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
    var timeposted: Int
}

struct ContentImage {
    var author: String
    var postTitle: String
    var upVotecount: Int
    var image: String
    var timeposted: Int
    
}

struct ContentLink {
    var author: String
    var postTitle: String
    var upVotecount: Int
    var link: String
    var thumbnail: String
    var timeposted: Int
}

struct ContentVideo {
    var author: String
    var postTitle: String
    var upVotecount: Int
    var time: Int
    var link: String
    var videolink: String
}
