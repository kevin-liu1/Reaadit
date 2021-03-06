//
//  ProfileJson.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-11.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
// /api/v1/me
struct Profile: Codable {
    var comment_karma: Int
    var name: String
    var link_karma: Int
    var created_utc: Int
    var coins: Int
    var icon_img: String
    var subreddit: ProfileDetails
}

struct ProfileDetails: Codable {
    var display_name: String
    
}



// /api/v1/me/karma
