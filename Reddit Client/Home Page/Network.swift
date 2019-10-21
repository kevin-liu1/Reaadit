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
                commentcelllist.append(CommentType(author: com.author ?? "NoAuthor", upvotes: com.ups ?? 0, time: com.created_utc ?? 0, textbody: com.body ?? "NoBody"))
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
            var array = defaults.object(forKey: "upVoteList") as? [String] ?? [String]()
            for i in jsonPosts.data.children {
                array.append(i.data.name)
            }
            defaults.set(Array(Set(array)), forKey: "upVoteList")
            print("Got UpVote List!!!")
            //print(defaults.object(forKey: "upVoteList") as? [String] ?? [String]())
        }
        
    }
    
    func getDownVotedList() {
        
        accessToken = defaults.string(forKey: "accessToken")
        let downVoteJson = Just.get("https://oauth.reddit.com/user/" + defaults.string(forKey: "userName")! + "/downvoted", params: ["limit": 20], headers: ["Authorization": "bearer " + accessToken!])
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(UpVoteList.self, from: downVoteJson.content!) {
            var array = defaults.object(forKey: "downVoteList") as? [String] ?? [String]()
            for i in jsonPosts.data.children {
                array.append(i.data.name)
            }
            defaults.set(Array(Set(array)), forKey: "downVoteList")
            print("Got DownVote List!!!")
            //print(defaults.object(forKey: "downVoteList") as? [String] ?? [String]())
        }
    }
    
    func getVoteList() {
        //upvotes
        print("Start Vote List Loading")
        accessToken = defaults.string(forKey: "accessToken")
        let upVoteJson = Just.get("https://oauth.reddit.com/user/" + defaults.string(forKey: "userName")! + "/upvoted", params: ["limit": 50], headers: ["Authorization": "bearer " + accessToken!])
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
        let downVoteJson = Just.get("https://oauth.reddit.com/user/" + defaults.string(forKey: "userName")! + "/downvoted", params: ["limit": 25], headers: ["Authorization": "bearer " + accessToken!])
        
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
        //update UpVotes
        accessToken = defaults.string(forKey: "accessToken")
        let upVoteJson = Just.get("https://oauth.reddit.com/user/" + defaults.string(forKey: "userName")! + "/upvoted", params: ["limit": 10], headers: ["Authorization": "bearer " + accessToken!])
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(UpVoteList.self, from: upVoteJson.content!) {
            //var array = defaults.object(forKey: "upVoteList") as? [String] ?? [String]()
            var array = [String]()
            for i in jsonPosts.data.children {
                array.append(i.data.name)
            }
            defaults.set(Array(Set(array)), forKey: "upVoteList")
            print("Got UpVote List!!!")
            //print(defaults.object(forKey: "upVoteList") as? [String] ?? [String]())
        }
        
        //update Downvotes
        let downVoteJson = Just.get("https://oauth.reddit.com/user/" + defaults.string(forKey: "userName")! + "/downvoted", params: ["limit": 10], headers: ["Authorization": "bearer " + accessToken!])
        if let jsonPosts = try? decoder.decode(UpVoteList.self, from: downVoteJson.content!) {
            //var array = defaults.object(forKey: "downVoteList") as? [String] ?? [String]()
            var array = [String]()
            for i in jsonPosts.data.children {
                array.append(i.data.name)
            }
            defaults.set(Array(Set(array)), forKey: "downVoteList")
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
    
    func soMuchTimeAgo(postedDate: Int) -> String? {
        if Double(postedDate) == nil {
            return nil
        }
        let diff = Date().timeIntervalSince1970 - Double(postedDate)
        var str: String = ""
        if  diff < 60 {
            str = "now"
        } else if diff < 3600 {
            let out = Int(round(diff/60))
            str = (out == 1 ? "1 minute ago" : "\(out) minutes ago")
        } else if diff < 3600 * 24 {
            let out = Int(round(diff/3600))
            str = (out == 1 ? "1 hour ago" : "\(out) hours ago")
        } else if diff < 3600 * 24 * 2 {
            str = "yesterday"
        } else if diff < 3600 * 24 * 7 {
            let out = Int(round(diff/(3600*24)))
            str = (out == 1 ? "1 day ago" : "\(out) days ago")
        } else if diff < 3600 * 24 * 7 * 4{
            let out = Int(round(diff/(3600*24*7)))
            str = (out == 1 ? "1 week ago" : "\(out) weeks ago")
        } else if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4)))
            str = (out == 1 ? "1 month ago" : "\(out) months ago")
        } else {//if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4*12)))
            str = (out == 1 ? "1 year ago" : "\(out) years ago")
        }
        return str
    }
}
