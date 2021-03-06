//
//  Post.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-04.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
import UIKit

class PostObject {
    var postTitle: String
    var postSubtitle: String

    var upVotes: Int
    var comments: Int
    var id: String
    var likes: String
    var subreddit: String
    
    var thumbnailURL: String

    
    init(postTitle: String, postSubtitle: String, upVotes: Int, comments: Int, id: String, thumbnailURL: String, likes: String, subreddit: String) {
        self.postTitle = postTitle
        self.postSubtitle = postSubtitle

        self.comments = comments
        self.upVotes = upVotes
        self.id = id
        self.thumbnailURL = thumbnailURL
        self.likes = likes
        self.subreddit = subreddit
        
    }
}
