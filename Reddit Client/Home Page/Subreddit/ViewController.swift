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
    var subredditResultsStr = [String]() //names of subreddit objects logged in 
    
    
    var username: String?
    var webAuthSession: ASWebAuthenticationSession?
    var accessCode: String?
    var accessToken: String?
    var refreshToken: String?
    
    let dispatchGroup = DispatchGroup()
    
    let defaults = UserDefaults.standard
    
    
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if UserDataExtract().loggedInStatus() == true {
//            self.loggedstatus = true
//        }
//
        
        //loggedstatus = UserDataExtract().loggedInStatus()
        
        //loggedstatus = defaults.bool(forKey: "logStatus")
        
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSubreddit))
        navigationController?.navigationBar.prefersLargeTitles = false
        subredditnames += ["Mac", "Apple", "Android", "NBA", "Toronto", "NYC", "ApolloApp", "AskTO"]
        topsubreddit += ["Popular", "All"]
        
        if defaults.bool(forKey: "logStatus") == false {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(logIn))

        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
            subredditResultsStr = defaults.object(forKey: "subredditList") as? [String] ?? [String]()
        }
        
        title = "Subreddits"
        
    }
    @objc func logOut(){
        defaults.set(false, forKey: "logStatus")
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log In", style: .plain, target: self, action: #selector(self.logIn))
        tableView.reloadData()
    }
    
    @objc func logIn(){
        getAuthTokenWithWebLogin(context: self)
        
        dispatchGroup.notify(queue: .main){
            print("Dispatch Group Reached")
            
            self.defaults.set(true, forKey: "logStatus")
            self.subredditResultsStr = self.defaults.object(forKey: "subredditList") as? [String] ?? [String]()
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(self.logOut))
            self.tableView.reloadData()
            
         }
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
        dispatchGroup.enter()
        
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
            
            LogIn().getAccessToken(oauthToken?.value ?? "Error")
            
            self.dispatchGroup.leave()
            
        })
        self.webAuthSession?.presentationContextProvider = context
        // Kick it off
        self.webAuthSession?.start()
        
    }
    
    
    
    // MARK: - Table view data source

    
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
        else if defaults.bool(forKey: "logStatus") {
            return subredditResultsStr.count
        }
        else {
             return subredditnames.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var name: String
        //let name = subredditnames[indexPath.row]
        if defaults.bool(forKey: "logStatus") {
            name = indexPath.section == 0 ? topsubreddit[indexPath.row] : subredditResultsStr[indexPath.row]
           
        } else {
            name = indexPath.section == 0 ? topsubreddit[indexPath.row] : subredditnames[indexPath.row]
            
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
                
            } else if defaults.bool(forKey: "logStatus") {
                
                vc.subreddit = subredditResultsStr[indexPath.row]
            } else {
                //vc.subreddit = subredditresults[indexPath.row].data.display_name
                vc.subreddit = subredditnames[indexPath.row]
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
}
