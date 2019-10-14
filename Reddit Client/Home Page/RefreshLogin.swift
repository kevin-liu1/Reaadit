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
    
    func getAccessTokenRefresh(){
        //print(defaults.string(forKey: "refreshToken"))
        let refreshtoken = defaults.string(forKey: "refreshToken")
        let r = Just.post("https://www.reddit.com/api/v1/access_token", data:["grant_type":"refresh_token", "refresh_token": refreshtoken!], auth: ("AOZZ5Fc3a1V3Rg", ""))
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(RefreshedAccessToken.self, from: r.content!) {
            print("got refresh token")
            print(jsonPosts.access_token)
            defaults.set(jsonPosts.access_token, forKey: "accessToken")
            
        } else {
            print("Error with getting refresh access token json")
            
        }
        
    }
}
