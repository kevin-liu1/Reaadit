//
//  Network.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-14.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
import Just
class Network {
    let defaults = UserDefaults.standard
    var accessToken: String?
    var userName: String?
    var commentList: [CommentType]?
    
    func getUserRecentComments() -> [CommentType]? {
        accessToken = defaults.string(forKey: "accessToken")
        userName = defaults.string(forKey: "userName")
        print(userName)
        let userJson = Just.get("https://oauth.reddit.com/user/\(userName!)/comments", headers:["Authorization": "bearer \(accessToken!)"])
        let decoder = JSONDecoder()
        if let contents = try? decoder.decode(PostKind.self, from: userJson.content!){
            print(" got user comment json")
            var commentcelllist = [CommentType]()
            for comment in contents.data.children! {
                let com = comment.data
                commentcelllist.append(CommentType(author: com.author ?? "NoAuthor", upvotes: com.ups ?? 0, time: "10", textbody: com.body ?? "NoBody"))
            }
            return commentcelllist
        } else {
            print("can't get user comment Json")
            return nil
        }
    }
    
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
