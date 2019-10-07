//
//  GetRefreshToken.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
import Just

class RefreshLogin {
    let defaults = UserDefaults.standard
    
    func getAccessToken() -> String{
        let r = Just.post("https://www.reddit.com/api/v1/access_token", data:["grant_type":"refresh_token","code": "\(defaults.string(forKey: "refreshToken"))", "redirect_uri": "myreddit://kevin"], auth: ("AOZZ5Fc3a1V3Rg", ""))
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(RefreshedAccessToken.self, from: r.content!) {
            
            print(jsonPosts.access_token)
            return jsonPosts.access_token
            //tableView.reloadData()
        } else {
            print("Error with getting refresh access token json")
            
        }
        return "invalid refresh token"
    }
}
