//
//  Content.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-05.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation


//Json Codables
struct PostKind: Codable {
    var kind: String
    var data: CommentData
}

struct CommentData: Codable{
    //var modhash: String
    //var dist: Int
    var children: [CommentKind]?
    
}

struct CommentKind: Codable {
    var kind: String
    var data: ContentorComment
    
}


struct ContentorComment: Codable {
    //
    
    //for Comment
    var name: String? //This is the id name of the original post
    var parent_id: String? // This is the parent name of the current comment
    var author: String?
    var body: String?
    //var replies: [Replies1]?
    
    
    //for Content
    
    var title: String?
    var is_self: Bool?
    var post_hint: String? // This tells you what kind of post it is.
    var selftext: String? //If this is not empty then Content is a Title + Body Type
    var thumbnail: String?
    var preview: Preview?
    var url: String?
    var domain: String?
    var likes: Bool?
    var created_utc: Int?
    
    //getVideoContent for Content
    var secure_media: Embed?
    
    
    //for both
    var ups: Int?
    
    //var replies: PostKind?
}

enum Replies1: CustomStringConvertible {
    case string(String)
    case array(Replies2)
    
    var description: String {
        switch self {
        case let .string(string): return string
        case let .array(array): return "\(array)"
        }
    }
}

extension Replies1: Codable {
    func encode(to encoder: Encoder) throws {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            self = .array(try container.decode(Replies2.self))
        }
    }
}



//struct Replies1: Codable {
//    var kind: String?
//    var data: Replies2?
//
//}

struct Replies2: Codable {
    //modhash, dist
    var children: [Replies3]?
}

struct Replies3: Codable {
    var kind: String?
    var data: ContentorComment?
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
    
    var reddit_video: RedditVideoInfo?
}

struct VideoInfo: Codable {
    
    var thumbnail_url: String?
    var html: String?
    
}

struct RedditVideoInfo: Codable {
    var fallback_url: String?
    var hls_url: String?
}
