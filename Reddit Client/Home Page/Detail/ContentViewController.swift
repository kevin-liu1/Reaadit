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
    
    var contentCell = [Content]()
    var contentID: String?
    var accessToken: String?
    var currentSub: String?
    
    
    var commentList = [CommentKind]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        accessToken = getAccessToken()
        print("THis is current sub from view controller" + (currentSub ?? "non"))
        print("This is content view controller" + (contentID ?? "No Content String"))
        print("This is access token from conteview" + (accessToken ?? "No Access Token"))
        let userJson = Just.get("https://oauth.reddit.com/r/" + (self.currentSub!).lowercased() + "/comments/" + contentID! + "?count=60", headers:["Authorization": "bearer \(accessToken ?? "")"])
        
        //print(userJson.json)
        //we need to implement enum in struct
        let decoder = JSONDecoder()
        if let comments = try? decoder.decode([PostKind].self, from: userJson.content!) {
            commentList = comments[1].data.children
            
            
        } else {
            print("Error with getting json") 
            
        }
        
        createContent()
        

    }

    func createContent() {
        
        self.contentCell = [Content(postTitle: "Sample Title", upVoteCount: 5, time: "10 Minutes")]

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
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return 1
        case 1:
            return commentList.count
        default:
            return 1
        }
        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as! ContentCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Comments", for: indexPath) 
            cell.textLabel?.text = commentList[indexPath.row].data.body
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as! ContentCell
            return cell
        }
        


    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
