//
//  LogIn.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-06.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
import AuthenticationServices
import UIKit
import Just


class LogIn{
    var webAuthSession: ASWebAuthenticationSession?
    var subredditresults = [SubbedSubs]() //list of subreddit objects
    var subredditResultsStr = [String]() //names of subreddit objects
    let defaults = UserDefaults.standard
    
    
    func getAccessToken(_ code: String) {
        let r = Just.post("https://www.reddit.com/api/v1/access_token", data:["grant_type":"authorization_code","code": "\(code)", "redirect_uri": "myreddit://kevin"], auth: ("AOZZ5Fc3a1V3Rg", ""))
        
        
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(AccessToken.self, from: r.content!) {

            print(jsonPosts.access_token)
            parseUserJson(accesstoken: jsonPosts.access_token, refreshtoken: jsonPosts.refresh_token)
            //tableView.reloadData()
        } else {
            print("Error with getting accesstoken json")
            
        }

    }
    
    
    func parseUserJson(accesstoken: String, refreshtoken: String) {
        var username: String?
        
        let userJson = Just.get("https://oauth.reddit.com/api/v1/me", headers:["Authorization": "bearer \(accesstoken)"])
        let decoder = JSONDecoder()
        if let user = try? decoder.decode(RedditUser.self, from: userJson.content!) {
            
            username = user.name
            print(user.name)
            
            
        } else {
            print("Error with getting subreddit list json")
            
        }
        
        let userSubs = Just.get("https://oauth.reddit.com/subreddits/mine/subscriber?limit=100", headers:["Authorization": "bearer \(accesstoken)"])
        if let subs = try? decoder.decode(Listing.self, from: userSubs.content!) {
            
            self.subredditresults = subs.data.children
            
            //filling up SubredditResultsStr
            for i in 1...subs.data.children.count {
                subredditResultsStr.append(subs.data.children[i-1].data.display_name)
            }
        } else {
            print("Error with getting json")
            
        }
        
        defaults.set(username, forKey: "userName")
        defaults.set(accesstoken, forKey: "accessToken")
        defaults.set(refreshtoken, forKey: "refreshToken")
        defaults.set(subredditResultsStr, forKey: "subredditList")
        
        let selectedarray = ["placeholder","yes"]
        defaults.set(selectedarray, forKey: "selectedList") // the list of selected posts
        print("Log in Data Retrieved")
        
        let upvoteArray = [String]()
        self.defaults.set(upvoteArray, forKey: "upVoteList")
    }
}
