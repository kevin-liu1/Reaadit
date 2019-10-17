//
//  PostType.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-03.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

struct Wraps: Codable {
    let kind: String
    let data: Wrap
}

struct Wrap: Codable {
    let dist: Int
    let children: [Posts]
    let after: String
}

struct Posts: Codable {
    let kind: String
    let data: Post
}

struct Post: Codable {
    let title: String
    let subreddit: String
    let author: String
    let selftext: String
    let url: String
    let thumbnail: String
    let ups: Int
    let permalink: String
    let num_comments: Int
    let id: String
    
    let preview: Preview?
    
}

struct PreviewPosts: Codable {
    var images: [PostImagePreview]
}
struct PostImagePreview: Codable {
    var source: ImageDataPost?
}
struct ImageDataPost: Codable {
    var url: String?
}
