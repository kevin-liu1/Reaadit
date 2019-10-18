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
            Network().getVoteList()
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
        let urlString = "https://www.reddit.com/r/" + subreddit!.lowercased() + ".json?limit=20"
        
        tableView.separatorStyle = .none
        createSpinnerView()
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        group.enter()
        dispatchQueue.async{
            self.getPostJson(urlString: urlString)
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
    
    
    
    func getPostJson(urlString: String){
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonPosts = try? decoder.decode(Wraps.self, from: json) {
            postsresult = jsonPosts.data.children
            afterParam = jsonPosts.data.after
            print("This is after param: " + (afterParam ?? "None"))
        } else {
            print("Error with getting json")
            return
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
                if self.subreddit == "Popular" || self.subreddit == "All" {
                    subtitle = post.subreddit
                } else {
                    subtitle = post.author
                }
                createdcells.append(PostObject(postTitle: post.title, postSubtitle: subtitle, upVotes: post.ups, comments: post.num_comments, id: post.id, thumbnailURL: post.preview?.images?[0].source?.url ?? ""))
            }
        }

        return createdcells
    }
    
    func getMorePosts() {
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        group.enter()
        dispatchQueue.async{
            let postJson = Just.get("https://www.reddit.com/r/" + self.subreddit! + ".json?limit=35&after=" + self.afterParam!)
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
        let lastElement = finishedposts.count - 15
        if indexPath.row == lastElement {
            self.getMorePosts()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DisplayContent") as? ContentViewController {
            vc.contentID = finishedposts[indexPath.row].id
            vc.currentSub = self.subreddit
            vc.currentTitle = finishedposts[indexPath.row].postTitle
            vc.upVotes = finishedposts[indexPath.row].upVotes
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    

}
