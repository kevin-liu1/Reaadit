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

    
    init(postTitle: String, postSubtitle: String, upVotes: Int, comments: Int) {
        self.postTitle = postTitle
        self.postSubtitle = postSubtitle

        self.comments = comments
        self.upVotes = upVotes
    }
}
