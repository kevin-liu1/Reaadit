//
//  CommentJson.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-10.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

struct CommentList: Decodable {
    var kind: String
    var data: CommentList2
}

struct CommentList2: Decodable {
    var children: [CommentList3]?
}

struct CommentList3: Decodable {
    var kind: String?
    var data: FinalCommentData?
    
    
}

struct FinalCommentData {
    var name: String?
    var author: String?
    var body: String?
    var replies: Kind?
    
    enum Kind {
        case node(CommentList)
        case leaf
    }
    init(name: String, author: String, body: String, replies: Kind) {
        self.name = name
        self.author = author
        self.body = body
        self.replies = replies
    }
    
}

extension FinalCommentData: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case author
        case body
        case nodes
    }
    enum CodableError: Error {
        case decoding(String)
        case encoding(String)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Assumes name exists for all objects
        if let name = try? container.decode(String.self, forKey: .name) {
            self.name = name
            self.replies = .leaf
            if let author = try? container.decode(String.self, forKey: .author) {
                self.author = author
                if let body = try? container.decode(String.self, forKey: .body) {
                    self.body = body
                    if let replies = try? container.decode(CommentList.self, forKey: .nodes) {
                        self.replies = .node(replies)
                    }
                }
            }

            return
        }
        throw CodableError.decoding("Decoding Error")
    }
}
