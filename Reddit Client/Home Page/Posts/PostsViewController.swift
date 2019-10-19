//
//  PostsView.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import SDWebImage
import Just

class PostsViewController: UITableViewController {
    
    var postsresult = [Posts]()
    var finishedposts = [PostObject]()
    var subreddit: String?
    var afterParam: String?
    let defaults = UserDefaults.standard
    
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        group.enter()
        dispatchQueue.async{
            self.getPostData()
            self.finishedposts = self.createCells()
            //Network().getVoteList()
            group.leave()
        }
        group.notify(queue: .main) {
            self.tableView.reloadData()
            sender.endRefreshing()
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = subreddit
        tableView.separatorStyle = .none
        createSpinnerView()
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        group.enter()
        dispatchQueue.async{
            self.getPostData()
            self.finishedposts = self.createCells()
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    
    func getPostData(){
        let accessToken = defaults.string(forKey: "accessToken")
        var postJson = Just.get("https://oauth.reddit.com/r/" + (self.subreddit ?? "none"), params: ["limit": 20], headers: ["Authorization": "bearer " + accessToken!])
        if defaults.bool(forKey: "logStatus") {
            if self.subreddit == "Home" {
                postJson = Just.get("https://oauth.reddit.com", params: ["limit": 20], headers: ["Authorization": "bearer " + accessToken!])
            }
        } else {
            postJson = Just.get("https://www.reddit.com/r/" + (self.subreddit ?? "") + ".json", params: ["limit": 20])
        }

        
        let decoder =  JSONDecoder()
        if let jsonPosts = try? decoder.decode(Wraps.self, from: postJson.content ?? Data()) {
            print("Got Json Data!!")
            self.postsresult = jsonPosts.data.children
            self.afterParam = jsonPosts.data.after
        } else {
            print("Error with getting posts JSON, Maybe check the null value")
        }
    }
    
    func createCells() -> [PostObject] {
        let cellnumber = self.postsresult.count
        var createdcells = [PostObject]()
        if cellnumber > 0 {
            for i in 1...cellnumber {
                let singlepost = postsresult[i-1]
                let post = singlepost.data
                
                //checking subtitle condition
                var subtitle: String
                if self.subreddit == "Popular" || self.subreddit == "All" || self.subreddit == "Home" {
                    subtitle = post.subreddit
                } else {
                    subtitle = post.author
                }
                //check post like condition
                var postlikes = "nil"
                if post.likes != nil {
                    if post.likes == true {
                        postlikes = "true"
                    } else if post.likes == false {
                        postlikes = "false"
                    }
                }
                defaults.set(postlikes, forKey: post.id)
                createdcells.append(PostObject(postTitle: post.title, postSubtitle: subtitle, upVotes: post.ups, comments: post.num_comments, id: post.id, thumbnailURL: post.preview?.images?[0].source?.url ?? "", likes: postlikes, subreddit: post.subreddit))
            }
        }

        return createdcells
    }
    
    func getMorePosts() {
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        group.enter()
        dispatchQueue.async{
            //let postJson = Just.get("https://www.reddit.com/r/" + self.subreddit! + ".json?limit=35&after=" + self.afterParam!)
            let accessToken = self.defaults.string(forKey: "accessToken")
            //let postJson = Just.get("https://oauth.reddit.com/r/" + (self.subreddit ?? "none"), params: ["limit": 35, "after": self.afterParam ?? ""], headers: ["Authorization": "bearer " + accessToken!])
            
            var postJson = Just.get("https://oauth.reddit.com/r/" + (self.subreddit ?? "none"), params: ["limit": 35, "after": self.afterParam ?? ""], headers: ["Authorization": "bearer " + accessToken!])
            if self.defaults.bool(forKey: "logStatus") {
                if self.subreddit == "Home" {
                    postJson = Just.get("https://oauth.reddit.com", params: ["limit": 35, "after": self.afterParam ?? ""], headers: ["Authorization": "bearer " + accessToken!])
                }
            } else {
                postJson = Just.get("https://www.reddit.com/r/" + self.subreddit! + ".json?limit=35&after=" + self.afterParam!)
            }

            let decoder = JSONDecoder()
            if let contents = try? decoder.decode(Wraps.self, from: postJson.content!) {
                self.afterParam = contents.data.after
                self.postsresult.append(contentsOf: contents.data.children)
                self.finishedposts = self.createCells()
            } else {
                print("Can't get more posts")
            }
            group.leave()
        }
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsresult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = finishedposts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Posts", for: indexPath) as! PostCellTableViewCell
        cell.setPost(postObject: post)
        return cell
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = finishedposts.count - 10
        if indexPath.row == lastElement {
            self.getMorePosts()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DisplayContent") as? ContentViewController {
            
            vc.contentID = finishedposts[indexPath.row].id
            if self.subreddit == "Home" {
                vc.currentSub = finishedposts[indexPath.row].subreddit
            } else {
                vc.currentSub = self.subreddit
            }
           
            vc.currentTitle = finishedposts[indexPath.row].postTitle
            vc.upVotes = finishedposts[indexPath.row].upVotes
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    

}
