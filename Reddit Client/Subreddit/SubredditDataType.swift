//
//  SubredditDataType.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-04.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

struct Listing: Codable {
    var kind: String
    var data: Modhash
}

struct Modhash: Codable {
    var children: [SubbedSubs]
}

struct SubbedSubs: Codable {
    var data: SubbedInfo
}

struct SubbedInfo: Codable {
    var display_name: String
    var display_name_prefixed: String
    var subscribers: Int
    var community_icon: String
    
    
}


//struct for access Token, different from the rest
struct AccessToken: Codable {
    let access_token: String
    let token_type: String
}
