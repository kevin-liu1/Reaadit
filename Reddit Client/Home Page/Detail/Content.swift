//
//  Content.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-05.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

// Models for Content
struct Content {
    
    var postTitle: String
    var upVoteCount: Int
    var time: String
    var selftext: String
    var thumbnail: String
}

struct ContentImage {

    var postTitle: String
    var upVotecount: Int
    var time: String
    var image: String
    
}

struct ContentLink {
    var postTitle: String
    var upVotecount: Int
    var time: String
    var link: String
}

struct ContentVideo {
    var postTitle: String
    var upVotecount: Int
    var time: String
    var link: String
    var videolink: String
}



//Json Codables
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
    var preview: Preview?
    var url: String?
    
    //getVideoContent for Content
    var secure_media: Embed?
    
    
    //for both
    var ups: Int?
    
    //var replies: PostKind?
}



//To Get high quality images
struct Preview: Codable {
    var images: [ContentImagePreview]?
}

struct ContentImagePreview: Codable {
    var source: ImageData?
}
struct ImageData: Codable{
    var url: String?
}


//To get video link
struct Embed: Codable {
    var oembed: VideoInfo?
    var type: String? //tells what type of video it is, gyf or youtube. 
}

struct VideoInfo: Codable {
    
    var thumbnail_url: String?
    var html: String?
    
}
