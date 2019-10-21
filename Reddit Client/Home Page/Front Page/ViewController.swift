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
    
    var headers = [Header]()
    var headerlist = ["", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var sortedDict: [String:[String]] = ["A":[],"B":[],"C":[], "D":[], "E":[], "F":[], "G":[], "H":[], "I":[], "J":[], "K":[], "L":[], "M":[], "N":[], "O":[], "P":[], "Q":[], "R":[], "S":[], "T":[], "U":[], "V":[], "W":[], "X":[], "Y":[], "Z":[]]
    
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        if defaults.bool(forKey: "logStatus") {
            let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
            let group = DispatchGroup()
            group.enter()
            dispatchQueue.async{
                self.subredditResultsStr = self.defaults.object(forKey: "subredditList") as? [String] ?? [String]()
                for i in 0...self.subredditResultsStr.count-1 {
                    self.subredditResultsStr[i] = self.subredditResultsStr[i].lowercased()
                }
                self.subredditResultsStr = self.subredditResultsStr.sorted()
                for (letter, sub) in self.sortedDict {
                    for subreddit in self.subredditResultsStr{
                        if subreddit.lowercased().hasPrefix(letter.lowercased()){
                            self.sortedDict[letter]?.append(subreddit)
                        }
                    }
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                self.tableView.reloadData()
                sender.endRefreshing()
            }
        } else {
            topsubreddit = ["Popular", "All"]
            subredditnames += ["Gifs", "Movies", "Entertainment", "News", "AskReddit", "Technology", "OddlySatisfying"]
            sender.endRefreshing()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        topsubreddit = ["Popular", "All"]
        if defaults.bool(forKey: "logStatus") {
            //self.subredditResultsStr = self.defaults.object(forKey: "subredditList") as? [String] ?? [String]()
            topsubreddit = ["Home", "Popular", "All"]
            accessToken = defaults.string(forKey: "accessToken")
            let userJson = Just.get("https://oauth.reddit.com/api/v1/me", headers:["Authorization": "bearer \(accessToken ?? "")"])
            
            //testing for refreshcode
            let decoder = JSONDecoder()
            if let contents = try? decoder.decode(Profile.self, from: userJson.content!) {
                print("STILL LOGGED IN")
                let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
                dispatchQueue.async{
                    //Network().getVoteList()
                }
            } else {
                print("ACCESS CODE EXPIRED")
                Network().getAccessTokenRefresh()
            }
        }
        tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        let headercell = UINib(nibName: "HeaderViewCell", bundle: nil)
        tableView.register(headercell, forCellReuseIdentifier: "HeaderCell")
        
        self.headers = [Header(label: "Favorites")]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSubreddit))
        navigationController?.navigationBar.prefersLargeTitles = false
        subredditnames += ["Gifs", "Movies", "Entertainment", "News", "AskReddit", "Technology", "OddlySatisfying"]
        topsubreddit = ["Popular", "All"]
        
        if defaults.bool(forKey: "logStatus") {
            Network().getVoteList() // elongate loading screen
            topsubreddit = ["Home", "Popular", "All"]
            subredditResultsStr = defaults.object(forKey: "subredditList") as? [String] ?? [String]()
            for i in 0...subredditResultsStr.count-1 {
                subredditResultsStr[i] = subredditResultsStr[i].lowercased()
            }
            subredditResultsStr = subredditResultsStr.sorted()
            for (letter, sub) in sortedDict {
                for subreddit in subredditResultsStr{
                    if subreddit.lowercased().hasPrefix(letter.lowercased()){
                        sortedDict[letter]?.append(subreddit)
                    }
                }
            }

        }
        
        title = "Subreddits"
        
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
            if answer != "" {
                self?.subredditnames.insert(answer, at: (self?.subredditnames.count)!)
                let indexPath = IndexPath(row: (self?.subredditnames.count)! - 1, section: 1)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        }
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if defaults.bool(forKey: "logStatus"){
            return headerlist.count
        } else {
            return 2
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = Bundle.main.loadNibNamed("HeaderViewCell", owner: self, options: nil)?.first as! HeaderViewCell
        
        if defaults.bool(forKey: "logStatus") {
            let label = Header(label: headerlist[section])
            headerView.setHeader(header: label)
        } else {
            if section == 1 {
                let label = Header(label: "Favorites")
                headerView.setHeader(header: label)
            } else {
                let label = Header(label: "none")
                headerView.setHeader(header: label)
            }
            
        }

        return headerView

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            if defaults.bool(forKey: "logStatus") {
                let currentletter = headerlist[section]
                if sortedDict[currentletter]?.count == 0 {
                    return 0
                } else {
                    return 25
                }
            } else {
                return 25
            }

            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topsubreddit.count
        }
        else if defaults.bool(forKey: "logStatus") {
            let currentletter = headerlist[section]
            return sortedDict[currentletter]?.count ?? 0
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
            if indexPath.section == 0 {
                name = topsubreddit[indexPath.row]
            } else {
                let currentletter = headerlist[indexPath.section]
                name = sortedDict[currentletter]?[indexPath.row] ?? "no value"
            }
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
        //createSpinnerView()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DisplayPosts") as? PostsViewController {
            if indexPath.section == 0 {
                vc.subreddit = topsubreddit[indexPath.row]
            } else if defaults.bool(forKey: "logStatus") {
                let currentletter = headerlist[indexPath.section]
                vc.subreddit = sortedDict[currentletter]?[indexPath.row]
            } else {
                vc.subreddit = subredditnames[indexPath.row]
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    

}


