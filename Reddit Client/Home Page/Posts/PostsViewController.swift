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
    var sortstyle = "best"
    
    var searchstring: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        group.enter()
        dispatchQueue.async{
            self.sortPostData(sort: self.sortstyle)
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
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        if !(self.subreddit == "Search") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow.up.arrow.down.circle"), style: .plain, target: self, action: #selector(sortPostsAC))
        }
        initializeData()
        //navigationController?.navigationBar.backgroundColor = .red

        loadSearchBar()

    }
    
    @objc func sortPostsAC() {
        let image = UIImage(named: "checkmark")
        let ac = UIAlertController(title: "Sort Posts", message: nil, preferredStyle: .actionSheet)
        
        let best = UIAlertAction(title: "Best", style: .default) { [weak self] _ in
            self?.sortPostData(sort: "best")
        }
        let rising = UIAlertAction(title: "Rising", style: .default){ [weak self] _ in
            self?.sortPostData(sort: "rising")
        }
        let new = UIAlertAction(title: "New", style: .default){ [weak self] _ in
            self?.sortPostData(sort: "new")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        switch sortstyle {
        case "best":
            best.setValue(image, forKey: "image")
        case "rising":
            rising.setValue(image, forKey: "image")
        case "new":
            new.setValue(image, forKey: "image")
        default:
            best.setValue(image, forKey: "image")
        }
        
        
        ac.addAction(best)
        ac.addAction(rising)
        ac.addAction(new)
        ac.addAction(cancel)
        
        present(ac, animated: true)
    }
    
    func sortPostData(sort: String) {
        let accessToken = defaults.string(forKey: "accessToken")
        
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        group.enter()
        dispatchQueue.async{
            
            var postJson = HTTPResult(data: Data(), response: nil, error: nil, task: nil)
            
            
            
            switch sort {
            case "best":
                
                if self.subreddit == "Home" {
                    postJson = Just.get("https://oauth.reddit.com/", params: ["limit": 15], headers: ["Authorization": "bearer " + accessToken!])
                } else if self.subreddit == "Search" {
                    print("REACHED")
                    DispatchQueue.main.async {
                        self.title = "Search: " + (self.searchstring ?? "")
                    }
                    postJson = Just.get("https://oauth.reddit.com/search/?", params: ["q": self.searchstring ?? "", "limit": 15], headers: ["Authorization": "bearer " + accessToken!])
                }
                
                else{
                    postJson = Just.get("https://oauth.reddit.com/r/" + (self.subreddit ?? "none") + "/best", params: ["limit": 15], headers: ["Authorization": "bearer " + accessToken!])
                }
                self.sortstyle = "best"
            case "rising":
                if self.subreddit == "Home" {
                    postJson = Just.get("https://oauth.reddit.com/rising", params: ["limit": 15], headers: ["Authorization": "bearer " + accessToken!])
                } else {
                    postJson = Just.get("https://oauth.reddit.com/r/" + (self.subreddit ?? "none") + "/rising", params: ["limit": 15], headers: ["Authorization": "bearer " + accessToken!])
                }
                
                self.sortstyle = "rising"
            case "new":
                if self.subreddit == "Home" {
                    postJson = Just.get("https://oauth.reddit.com/new", params: ["limit": 15], headers: ["Authorization": "bearer " + accessToken!])
                } else {
                    postJson = Just.get("https://oauth.reddit.com/r/" + (self.subreddit ?? "none") + "/new", params: ["limit": 15], headers: ["Authorization": "bearer " + accessToken!])
                }
                
                self.sortstyle = "new"

            default:
                postJson = Just.get("https://oauth.reddit.com/r/" + (self.subreddit ?? "none") + "/best", params: ["limit": 15], headers: ["Authorization": "bearer " + accessToken!])
            }

        
            let decoder =  JSONDecoder()
            if let jsonPosts = try? decoder.decode(Wraps.self, from: postJson.content ?? Data()) {
                print("Got \(sort) Json Data!!")
                self.postsresult = jsonPosts.data.children
                self.afterParam = jsonPosts.data.after
            } else {
                print("Error with getting posts JSON, Maybe check the null value")
                return
            }
            self.finishedposts = self.createCells()
            group.leave()
        }
        
        group.notify(queue: .main) {
            
            //self.tableView.separatorStyle = .singleLine
            self.tableView.reloadData()
        }
        
    }
    
    func initializeData() {
        self.tableView.separatorStyle = .none
        createSpinnerView()
        
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        group.enter()
        dispatchQueue.async{
            self.sortPostData(sort: "best")
            self.finishedposts = self.createCells()
            group.leave()
        }
        
        group.notify(queue: .main) {
            //self.tableView.separatorStyle = .singleLine
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func createCells() -> [PostObject] {
        let cellnumber = self.postsresult.count
        var createdcells = [PostObject]()
        if cellnumber > 0 {
            for i in 1...cellnumber {
                if postsresult.count < 1 {
                    return [PostObject]()
                }
                let singlepost = postsresult[i-1]
                let post = singlepost.data
                
                //checking subtitle condition
                var subtitle: String
                if self.subreddit == "Popular" || self.subreddit == "All" || self.subreddit == "Home" {
                    subtitle = post.subreddit ?? ""
                } else {
                    subtitle = post.author ?? ""
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
                defaults.set(postlikes, forKey: post.id ?? "")
                createdcells.append(PostObject(postTitle: post.title ?? "", postSubtitle: subtitle ?? "", upVotes: post.ups ?? 0, comments: post.num_comments ?? 0, id: post.id ?? "", thumbnailURL: post.preview?.images?[0].source?.url ?? "", likes: postlikes ?? "0", subreddit: post.subreddit ?? ""))
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
            
            var postJson = Just.get("https://oauth.reddit.com/r/" + (self.subreddit ?? "none"), params: ["limit": 25, "after": self.afterParam ?? ""], headers: ["Authorization": "bearer " + accessToken!])
            if self.defaults.bool(forKey: "logStatus") {
                if self.subreddit == "Home" {
                    postJson = Just.get("https://oauth.reddit.com", params: ["limit": 25, "after": self.afterParam ?? ""], headers: ["Authorization": "bearer " + accessToken!])
                }
                if self.subreddit == "Search" {
                    postJson = Just.get("https://oauth.reddit.com/search/?", params: ["q": self.searchstring ?? "", "after": self.afterParam ?? "", "limit": 15], headers: ["Authorization": "bearer " + accessToken!])
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
        return finishedposts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = finishedposts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShadowPosts", for: indexPath) as! ShadowTableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Posts", for: indexPath) as! PostCellTableViewCell
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
            } else if self.subreddit == "Search" {
                vc.currentSub = finishedposts[indexPath.row].subreddit.lowercased()
            } else {
                vc.currentSub = self.subreddit
            }

            vc.currentTitle = finishedposts[indexPath.row].postTitle
            vc.upVotes = finishedposts[indexPath.row].upVotes
            navigationController?.pushViewController(vc, animated: true)
        }
        
//        let vc = RedditCommentsViewController()
//        vc.contentID = finishedposts[indexPath.row].id
//        if self.subreddit == "Home" {
//            vc.currentSub = finishedposts[indexPath.row].subreddit
//        } else {
//            vc.currentSub = self.subreddit
//        }
//
//        vc.currentTitle = finishedposts[indexPath.row].postTitle
//
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    

}

extension PostsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        var list = [String]()
        
        self.tableView.reloadData()
    }
    
    func loadSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Subreddits"
        search.searchBar.barStyle = .default
        
        if let textfield = search.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            textfield.textColor = UIColor.darkGray
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }
        }
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.1527230442, green: 0.3966148496, blue: 0.7221766114, alpha: 1)
        
        navigationItem.searchController = search
        
        definesPresentationContext = true
    }
}
