//
//  CommentJson.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-10.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

final class CommentList: Codable {
    var kind: String
    var data: CommentList2
}

final class CommentList2: Codable {
    var children: [CommentList3]?
}

final class CommentList3: Codable {
    var kind: String?
    var data: FinalCommentData?
    
    
}

final class FinalCommentData: Codable {
    var name: String?
    var author: String?
    var body: String?
    var replies: [String: CommentList2]?
}
