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
    
    func Vote(id: String, direction: Int) {
        
        accessToken = defaults.string(forKey: "accessToken")
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        dispatchQueue.async{
            let _ = Just.post("https://oauth.reddit.com/api/vote", params: ["dir": direction, "id": id], headers: ["Authorization": "bearer " + self.accessToken!])
        }

//        accessToken = defaults.string(forKey: "accessToken")
//        let _ = Just.post("https://oauth.reddit.com/api/vote", params: ["dir": direction, "id": id], headers: ["Authorization": "bearer " + accessToken!])
        
    }
    
    func getUpVotedList() {
        
        accessToken = defaults.string(forKey: "accessToken")
        let upVoteJson = Just.get("https://oauth.reddit.com/user/" + defaults.string(forKey: "userName")! + "/upvoted", params: ["limit": 20], headers: ["Authorization": "bearer " + accessToken!])
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(UpVoteList.self, from: upVoteJson.content!) {
            var array = [String]()
            for i in jsonPosts.data.children {
                array.append(i.data.name)
            }
            defaults.set(array, forKey: "upVoteList")
            print("Got UpVote List!!!")
            //print(defaults.object(forKey: "upVoteList") as? [String] ?? [String]())
        }
        
    }
    
    func getVoteList() {
        //upvotes
        print("Start Vote List Loading")
        accessToken = defaults.string(forKey: "accessToken")
        let upVoteJson = Just.get("https://oauth.reddit.com/user/" + defaults.string(forKey: "userName")! + "/upvoted", params: ["limit": 20], headers: ["Authorization": "bearer " + accessToken!])
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(UpVoteList.self, from: upVoteJson.content!) {
            var array = [String]()
            for i in jsonPosts.data.children {
                array.append(i.data.name)
            }
            defaults.set(array, forKey: "upVoteList")
            //print(defaults.object(forKey: "upVoteList") as? [String] ?? [String]())
        }
        
        
        //downvotes
        let downVoteJson = Just.get("https://oauth.reddit.com/user/" + defaults.string(forKey: "userName")! + "/downvoted", params: ["limit": 20], headers: ["Authorization": "bearer " + accessToken!])
        
        if let jsonPosts = try? decoder.decode(UpVoteList.self, from: downVoteJson.content!) {
            var array = [String]()
            for i in jsonPosts.data.children {
                array.append(i.data.name)
            }
            defaults.set(array, forKey: "downVoteList")
            //print(defaults.object(forKey: "downVoteList") as? [String] ?? [String]())
        }
        
        print("Got All Vote List Stuff")
        
    }
    func updateVoteList() {
        
    }
    
    func getDownVotedList() {
        
        accessToken = defaults.string(forKey: "accessToken")
        let downVoteJson = Just.get("https://oauth.reddit.com/user/" + defaults.string(forKey: "userName")! + "/downvoted", params: ["limit": 20], headers: ["Authorization": "bearer " + accessToken!])
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(UpVoteList.self, from: downVoteJson.content!) {
            var array = [String]()
            for i in jsonPosts.data.children {
                array.append(i.data.name)
            }
            defaults.set(array, forKey: "downVoteList")
            print("Got DownVote List!!!")
            //print(defaults.object(forKey: "downVoteList") as? [String] ?? [String]())
        }
    }
    
    struct UpVoteList: Codable {
        var kind: String
        var data: UpVoteList1
    }
    struct UpVoteList1: Codable {
        var dist: Int
        var children: [UpVoteList2]
    }
    struct UpVoteList2: Codable {
        var kind: String
        var data: UpVoteData
    }
    
    struct UpVoteData: Codable {
        var name: String //full name
        var id: String //just id
    }
    
    
}
