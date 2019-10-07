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
    
    
    func getAccessToken(_ code: String) {
        let r = Just.post("https://www.reddit.com/api/v1/access_token", data:["grant_type":"authorization_code","code": "\(code)", "redirect_uri": "myreddit://kevin"], auth: ("AOZZ5Fc3a1V3Rg", ""))
        
        
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(AccessToken.self, from: r.content!) {
            //self.accessToken = jsonPosts.access_token
            //self.refreshToken = jsonPosts.refresh_token
            
            parseUserJson(accesstoken: jsonPosts.access_token, refreshtoken: jsonPosts.refresh_token)
            //tableView.reloadData()
        } else {
            print("Error with getting json")
            
        }
        
        //print("This is refresh token:" + (self.refreshToken ?? "no r Token"))
        //print("This is access token" + (self.accessToken ?? "no access Token"))
        
        
    }
    
    
    func parseUserJson(accesstoken: String, refreshtoken: String) {
        var username: String?
        
        let userJson = Just.get("https://oauth.reddit.com/api/v1/me", headers:["Authorization": "bearer \(accesstoken)"])
        let decoder = JSONDecoder()
        if let user = try? decoder.decode(RedditUser.self, from: userJson.content!) {
            
            username = user.name
            //self.title = "\(self.username ?? "noname") Subreddits"
            print(user.name)
            
            
        } else {
            print("Error with getting json")
            
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
        
        let userdata = UserData(logStatus: true, userName: username ?? "No UserName", accessToken: accesstoken, refreshToken: refreshtoken, subredditList: subredditResultsStr)
        saveData(UserData: userdata)
        
        
        
        //self.loggedstatus = true
        
    }
    
    
    func saveData(UserData userdata: UserData) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let paths = Bundle.main.url(forResource: "UserData", withExtension: "plist")
        
        do {
            let data = try encoder.encode(userdata)
            try data.write(to: paths!)
        } catch {
            print(error)
        }
    }
    
}
