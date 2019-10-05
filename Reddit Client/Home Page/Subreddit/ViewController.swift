//
//  ViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//
import UIKit
import Just
import SafariServices
import AuthenticationServices


class ViewController: UITableViewController, ASWebAuthenticationPresentationContextProviding {
    var topsubreddit = [String]()
    var subredditnames = [String]() //default subreddit list
    var subredditresults = [SubbedSubs]() //list of subreddit objects
    var subredditResultsStr = [String]() //names of subreddit objects
    
    
    
    var loggedstatus = false
    var username: String?
    var webAuthSession: ASWebAuthenticationSession?
    var accessCode: String?
    var accessToken: String?
    var refreshToken: String?
    
    
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSubreddit))
        navigationController?.navigationBar.prefersLargeTitles = false
        subredditnames += ["Mac", "Apple", "Android", "NBA", "Toronto", "NYC", "ApolloApp", "AskTO"]
        topsubreddit += ["Popular", "All"]
        
        
        
        
        if self.loggedstatus == false {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(logIn))
        }
        
        title = "Subreddits"
        

        
    
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
    
    @objc func logIn(){
        getAuthTokenWithWebLogin(context: self)
    }
    
    func userInfoSetup(ForUser user: RedditUser) {
        self.title = "\(user.name) Subreddits"
        self.navigationItem.rightBarButtonItem = nil
        
    }
    
    @objc func addSubreddit() {
        let ac = UIAlertController(title: "Add Subreddit", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            if answer != ""{
                self?.subredditnames.insert(answer, at: (self?.subredditnames.count)!)
                let indexPath = IndexPath(row: (self?.subredditnames.count)! - 1, section: 1)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        }
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    func getAuthTokenWithWebLogin(context: ASWebAuthenticationPresentationContextProviding) {

        let authURL = URL(string: "https://www.reddit.com/api/v1/authorize.compact?client_id=AOZZ5Fc3a1V3Rg&response_type=code&state=authorizationcode&redirect_uri=myreddit://kevin&duration=permanent&scope=identity,mysubreddits,read,save,subscribe,vote,edit")
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
            self.accessCode = oauthToken?.value
            self.getAccessToken(oauthToken?.value ?? "error")
            
            
            
        })
        self.webAuthSession?.presentationContextProvider = context
        // Kick it off
        self.webAuthSession?.start()
        
        
    }
    
    func getAccessToken(_ code: String) {
        let r = Just.post("https://www.reddit.com/api/v1/access_token", data:["grant_type":"authorization_code","code": "\(code)", "redirect_uri": "myreddit://kevin"], auth: ("AOZZ5Fc3a1V3Rg", ""))
        
        
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(AccessToken.self, from: r.content!) {
            self.accessToken = jsonPosts.access_token
            self.refreshToken = jsonPosts.refresh_token
            
            parseUserJson(accesstoken: jsonPosts.access_token)
            tableView.reloadData()
        } else {
            print("Error with getting json")
            
        }
        
        print("This is refresh token:" + (self.refreshToken ?? "no r Token"))
        print("This is access token" + (self.accessToken ?? "no access Token"))
        
        
    }
    
    
    func parseUserJson(accesstoken: String) {
        
        let userJson = Just.get("https://oauth.reddit.com/api/v1/me", headers:["Authorization": "bearer \(accesstoken)"])
        let decoder = JSONDecoder()
        if let user = try? decoder.decode(RedditUser.self, from: userJson.content!) {
            
            self.username = user.name
            //self.title = "\(self.username ?? "noname") Subreddits"
            userInfoSetup(ForUser: user)
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
        
        let userdata = UserData(userName: self.username ?? "", accessToken: self.accessToken ?? "", subredditList: subredditResultsStr)
        saveData(UserData: userdata)
        
        
        
        self.loggedstatus = true
        
    }
    

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section == 1 {
            label.text = "    FAVORITES"
            
            label.backgroundColor = UIColor.lightGray
            return label
        } else {
            //label.text = " Top Subreddits"
            //label.backgroundColor = UIColor.lightGray
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 30
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topsubreddit.count
        }
        else if loggedstatus == false {
            return subredditnames.count
        }
        else {
            return subredditresults.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var name: String
        //let name = subredditnames[indexPath.row]
        if loggedstatus == false {
            name = indexPath.section == 0 ? topsubreddit[indexPath.row] : subredditnames[indexPath.row]
        } else {
            name = indexPath.section == 0 ? topsubreddit[indexPath.row] : subredditResultsStr[indexPath.row] //subredditresults[indexPath.row].data.display_name
        }
        
        
        
        cell.textLabel?.text = name
        cell.selectionStyle = .default

        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DisplayPosts") as? PostsViewController {
            if indexPath.section == 0 {
                vc.subreddit = topsubreddit[indexPath.row]
                
            } else if loggedstatus == false {
                vc.subreddit = subredditnames[indexPath.row]
            } else {
                //vc.subreddit = subredditresults[indexPath.row].data.display_name
                vc.subreddit = subredditResultsStr[indexPath.row]
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
}