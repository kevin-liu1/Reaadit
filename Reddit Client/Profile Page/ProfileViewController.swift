//
//  SearchViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import Just
class ProfileViewController: UITableViewController {
    
    var accessToken: String?
    var profileCellFinal: ProfileHolder?
    var profileholder: ProfileHolder? // hold the information for log out
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = defaults.string(forKey: "userName")
        
        let profilecell = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(profilecell, forCellReuseIdentifier: "Profile Cell")
        
        if defaults.bool(forKey: "logStatus") {
            getProfileJson()
        } else {
            profileCellFinal = ProfileHolder(comment_karma: 0, name: "NoUser", link_karma: 0, created_utc: 0, coins: 0, icon_img: "", display_name: "noUser")
        }
        
    }
    
    func refreshData() {
        if defaults.bool(forKey: "logStatus") {
            profileCellFinal = profileholder
            
        } else {
            profileCellFinal = ProfileHolder(comment_karma: 0, name: "NoUser", link_karma: 0, created_utc: 0, coins: 0, icon_img: "", display_name: "noUser")
        }
    }
    
    func getProfileJson() {
        accessToken = defaults.string(forKey: "accessToken")
        let profileJson = Just.get("https://oauth.reddit.com/api/v1/me/", headers:["Authorization": "bearer \(accessToken ?? "")"])
        let decoder = JSONDecoder()
        if let contents = try? decoder.decode(Profile.self, from: profileJson.content!) {
            profileholder = ProfileHolder(comment_karma: contents.comment_karma, name: contents.name, link_karma: contents.link_karma, created_utc: contents.created_utc, coins: contents.coins, icon_img: contents.icon_img, display_name: contents.subreddit.display_name)
            profileCellFinal = profileholder
        } else {
            print("Can't get profile JSON")
            if defaults.bool(forKey: "logStatus") {
                RefreshLogin().getAccessToken()
                getProfileJson()
            }
        }
    }
        
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        self.refreshData()
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Profile Cell", for: indexPath) as! ProfileCell
        
        if defaults.bool(forKey: "logStatus") {
            cell.setUp(profilecell: profileCellFinal!)
        } else {
            let defaultcell = ProfileHolder(comment_karma: 0, name: "NoUser", link_karma: 0, created_utc: 0, coins: 0, icon_img: "", display_name: "noUser")
            cell.setUp(profilecell: defaultcell)
        }
        
        return cell
    }

}
