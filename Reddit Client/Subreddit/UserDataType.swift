//
//  UserDataType.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-03.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
import UIKit

struct RedditUser: Codable {
    let subreddit: Subreddit
    let name: String
    let link_karma: Int
    let comment_karma: Int
}

struct Subreddit: Codable {
    let display_name: String
}
