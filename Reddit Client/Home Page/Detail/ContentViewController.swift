//
//  ContentViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-05.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import Just

class ContentViewController: UITableViewController {
    
    var currentSub: String? //passed by prev VC
    var currentTitle: String?
    var upVotes: Int?
    
    var contentCell = [Content]()
    var contentID: String? //passed by previous VC
    var accessToken: String?
    
    var commentListFinal = [CommentType]()
    
    
    
    
    var commentList = [CommentKind]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentSub
        
        

        
//        print("THis is current sub from view controller" + (currentSub ?? "non"))
//        print("This is content view controller" + (contentID ?? "No Content String"))
//        print("This is access token from conteview" + (accessToken ?? "No Access Token"))
        
        accessToken = UserDataExtract().getAccessToken()
        let userJson = Just.get("https://oauth.reddit.com/r/" + (self.currentSub!).lowercased() + "/comments/" + contentID! + "?limit=60", headers:["Authorization": "bearer \(accessToken ?? "")"])
        
        //print(userJson.json)
        //we need to implement enum in struct
        let decoder = JSONDecoder()
        if let comments = try? decoder.decode([PostKind].self, from: userJson.content!) {
            self.commentList = comments[1].data.children
            
            
        } else {
            
            print("Error with getting comment json") 
            
        }
        
        createContent()
        createComments()
        

    }

    func createContent() {
        
        self.contentCell = [Content(postTitle: currentTitle ?? "", upVoteCount: self.upVotes ?? 10, time: "10 Minutes")]

    }
    
    func createComments() {
        for comment in self.commentList {
            let com = comment.data
            let commentcell = CommentType(author: com.author ?? "No Author", upvotes: com.ups ?? -1, time: "10 Minutes", textbody: com.body ?? "Empty Body")
            commentListFinal.append(commentcell)
            
        }
    }
    
    func getAccessToken() -> String {
        if  let path        = Bundle.main.path(forResource: "UserData", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let userdata = try? PropertyListDecoder().decode(UserData.self, from: xml)
        {
            print("This is user data from another view:" + userdata.userName)
            self.title = userdata.userName
            return userdata.accessToken 
        } else {
            return "extraction didn't work"
        }


    }
    func getSubList() -> [String] {
        if  let path        = Bundle.main.path(forResource: "UserData", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let userdata = try? PropertyListDecoder().decode(UserData.self, from: xml)
        {
            print("This is user data from another view:" + userdata.userName)
            //self.testArray = userdata.subredditList
            return userdata.subredditList
        } else {
            return [""]
        }


    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return commentListFinal.count
        default:
            return 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as! ContentCell
            cell.setContent(Content: contentCell[0])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comments", for: indexPath) as! CommentCell
            let comment = commentListFinal[indexPath.row]
            cell.setCommentCell(comment: comment)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as! ContentCell
            return cell
        }
        
    }
    


}
