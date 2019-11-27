//
//  SearchViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import Just
import AuthenticationServices

class ProfileViewController: UITableViewController, ASWebAuthenticationPresentationContextProviding {
    let defaults = UserDefaults.standard
    
    var accessToken: String?
    var profileCellFinal: ProfileHolder?
    var profileholder: ProfileHolder? // hold the information for log out
    var profileCommentsHolder = [CommentType]() //hold the comments
    
    let dispatchGroup = DispatchGroup()
    var webAuthSession: ASWebAuthenticationSession?
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
         return self.view.window ?? ASPresentationAnchor()
     }
    
    override func viewDidAppear(_ animated: Bool) {
        if defaults.bool(forKey: "logStatus") {
            getProfileJson()
            profileCommentsHolder = Network().getUserRecentComments() ?? [CommentType]()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logOut))
            tableView.reloadData()
            
        } else {
            profileCellFinal = ProfileHolder(comment_karma: 0, name: "NoUser", link_karma: 0, created_utc: 0, coins: 0, icon_img: "", display_name: "noUser")
            profileCommentsHolder = [CommentType]()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(self.logIn))
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = defaults.string(forKey: "userName")
        
        if defaults.bool(forKey: "logStatus") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(logIn))
        }
        
        let profilecell = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(profilecell, forCellReuseIdentifier: "Profile Cell")
        let profilecommentcell = UINib(nibName: "ProfileCommentCell", bundle: nil)
        tableView.register(profilecommentcell, forCellReuseIdentifier: "ProfileComments")
        if defaults.bool(forKey: "logStatus") {
            let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
            let group = DispatchGroup()
            group.enter()
            dispatchQueue.async{
                self.getProfileJson()
                group.leave()
            }
            group.notify(queue: .main) {
                self.tableView.reloadData()
            }
            
            profileCommentsHolder = Network().getUserRecentComments() ?? [CommentType]()
            
        } else {
            profileCellFinal = ProfileHolder(comment_karma: 0, name: "NoUser", link_karma: 0, created_utc: 0, coins: 0, icon_img: "", display_name: "noUser")
            profileCommentsHolder = [CommentType]()
        }
    }
    
    @objc func logIn(){
           getAuthTokenWithWebLogin(context: self)
           
           dispatchGroup.notify(queue: .main){
               print("Dispatch Group Reached")
               
               self.defaults.set(true, forKey: "logStatus")
               //self.subredditResultsStr = self.defaults.object(forKey: "subredditList") as? [String] ?? [String]()
               
               self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logOut))
               self.tableView.reloadData()
               
            }
       }
    
    @objc func logOut(){
        defaults.set(false, forKey: "logStatus")
        defaults.set("", forKey: "accessToken")
        defaults.set("", forKey:  "refreshToken")
        defaults.set("User", forKey: "userName")
        defaults.set([String](), forKey: "upVoteList")
        defaults.set([String](), forKey: "subredditList")
        defaults.set([String](), forKey: "selectedList")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(self.logIn))
        tableView.reloadData()
    }
    
    func getAuthTokenWithWebLogin(context: ASWebAuthenticationPresentationContextProviding) {
        dispatchGroup.enter()
        
        let authURL = URL(string: "https://www.reddit.com/api/v1/authorize.compact?client_id=AOZZ5Fc3a1V3Rg&response_type=code&state=authorizationcode&redirect_uri=myreddit://kevin&duration=permanent&scope=identity,mysubreddits,read,save,subscribe,vote,edit,history,submit,subscribe,flair,report,privatemessages")
        let callbackUrlScheme = "myreddit://kevin"
        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }
            print("no error so far" )
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first

            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken?.value ?? "No OAuth Token")
            //self.accessCode = oauthToken?.value
            
            LogIn().getAccessToken(oauthToken?.value ?? "Error")
            
            self.dispatchGroup.leave()
            
        })
        self.webAuthSession?.presentationContextProvider = context
        // Kick it off
        self.webAuthSession?.start()
        
    }
    
    
    func refreshData() {
        if defaults.bool(forKey: "logStatus") {
            profileCellFinal = profileholder
            
        } else {
            profileCellFinal = ProfileHolder(comment_karma: 0, name: "NoUser", link_karma: 0, created_utc: 0, coins: 0, icon_img: "", display_name: "noUser")
            profileCommentsHolder = [CommentType]()
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
                RefreshLogin().getAccessTokenRefresh()
                getProfileJson()
            }
        }
    }
        
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        self.refreshData()
        tableView.reloadData()
        sender.endRefreshing()
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
            return profileCommentsHolder.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Profile Cell", for: indexPath) as! ProfileCell
            
            if defaults.bool(forKey: "logStatus") {
                if let profilecell = profileCellFinal {
                    cell.setUp(profilecell: profilecell)
                    cell.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    print("No Profile Cell made")
                    return cell
                }
                
            } else {
                let defaultcell = ProfileHolder(comment_karma: 0, name: "NoUser", link_karma: 0, created_utc: 0, coins: 0, icon_img: "", display_name: "noUser")
                cell.setUp(profilecell: defaultcell)
            }
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileComments", for: indexPath) as! ProfileCommentCell
            
            cell.setContent(profileComment: profileCommentsHolder[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Profile Cell", for: indexPath) as! ProfileCell
            let defaultcell = ProfileHolder(comment_karma: 0, name: "NoUser", link_karma: 0, created_utc: 0, coins: 0, icon_img: "", display_name: "noUser")
            cell.setUp(profilecell: defaultcell)
            return cell
        }

    }

}
