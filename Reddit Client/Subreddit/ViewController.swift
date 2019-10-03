//
//  ViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import Just
import OAuth2
import SafariServices
import AuthenticationServices


struct Wraps: Codable {
    let kind: String
    let data: Wrap
}

struct Wrap: Codable {
    let dist: Int
    let children: [Posts]
}

struct Posts: Codable {
    let kind: String
    let data: Post
}

struct Post: Codable {
    let title: String
    let subreddit: String
    let author: String
    let selftext: String
    let url: String
    let thumbnail: String
    let ups: Int
    let permalink: String
    let num_comments: Int
    
    
}


struct AccessToken: Codable {
    let access_token: String
    let token_type: String
}




class ViewController: UITableViewController, ASWebAuthenticationPresentationContextProviding {
    var topsubreddit = [String]()
    var subredditnames = [String]()
    var webAuthSession: ASWebAuthenticationSession?
    var accessToken: String?
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Subreddits"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSubreddit))
        navigationController?.navigationBar.prefersLargeTitles = false
        subredditnames += ["Mac", "Apple", "Android", "NBA", "Toronto", "NYC", "ApolloApp", "AskTO"]
        topsubreddit += ["Popular", "All"]
        
        getAuthTokenWithWebLogin(context: self)
        
        
        
        
        
    }
    
    func getAuthTokenWithWebLogin(context: ASWebAuthenticationPresentationContextProviding) {

        let authURL = URL(string: "https://www.reddit.com/api/v1/authorize.compact?client_id=AOZZ5Fc3a1V3Rg&response_type=code&state=authorizationcode&redirect_uri=myreddit://kevin&duration=permanent&scope=identity,mysubreddits")
        let callbackUrlScheme = "myreddit://kevin"

        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in

            // handle auth response
            guard error == nil, let successURL = callBack else {
                print(error)
                return
                
            }
            print("no error so far" )
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first

            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken?.value ?? "No OAuth Token")
            self.accessToken = oauthToken?.value
        })
        self.webAuthSession?.presentationContextProvider = context
        // Kick it off
        self.webAuthSession?.start()
    }
    
    
    func showTutorial(_ which: Int) {
        if let url = URL(string: "https://www.reddit.com/api/v1/authorize") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    
    
    
    
    @objc func addSubreddit() {
        let ac = UIAlertController(title: "Add Subreddit", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.subredditnames.insert(answer, at: (self?.subredditnames.count)!)
            
            let indexPath = IndexPath(row: (self?.subredditnames.count)! - 1, section: 1)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        ac.addAction(submitAction)
        
        present(ac, animated: true)
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
        return subredditnames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //let name = subredditnames[indexPath.row]
        
        let name = indexPath.section == 0 ? topsubreddit[indexPath.row] : subredditnames[indexPath.row]
        
        
        cell.textLabel?.text = name
        if indexPath.section == 0 {
            cell.textLabel?.font = cell.textLabel?.font.withSize(20)
            cell.detailTextLabel?.text = "Interesting"
            
        }
        
        
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
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DisplayPosts") as? PostsView {
            if indexPath.section == 0 {
                vc.subreddit = topsubreddit[indexPath.row]
                
            } else {
                vc.subreddit = subredditnames[indexPath.row]
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
}

