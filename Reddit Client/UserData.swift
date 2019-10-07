//
//  UserData.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-04.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

struct UserData: Codable {
    var logStatus: Bool
    var userName: String
    var accessToken: String
    var refreshToken: String
    var subredditList: [String]
}
