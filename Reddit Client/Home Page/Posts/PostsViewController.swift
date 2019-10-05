//
//  PostsView.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import SDWebImage


class PostsViewController: UITableViewController {

    
    var postsresult = [Posts]()
    var finishedposts = [PostObject]()
    var subreddit: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = subreddit
        let urlString = "https://www.reddit.com/r/" + subreddit!.lowercased() + ".json?limit=500"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        
        self.finishedposts = createCells()
        
        //tableView.register(PostCellTableViewCell.self, forCellReuseIdentifier: "Posts")
        
    }
    
    
    func parse(json: Data){
        let decoder = JSONDecoder()
       
        if let jsonPosts = try? decoder.decode(Wraps.self, from: json) {
            postsresult = jsonPosts.data.children
        } else {
            print("Error with getting json")
            return
        }
    }
    
    func createCells() -> [PostObject] {
        let cellnumber = self.postsresult.count
        var createdcells = [PostObject]()
        
        for i in 1...cellnumber {
            let singlepost = postsresult[i-1]
            let post = singlepost.data
            
            //checking subtitle condition
            var subtitle: String
            if self.subreddit == "Popular" || self.subreddit == "All" {
                subtitle = post.author
            } else {
                subtitle = post.subreddit
            }
            
            createdcells.append(PostObject(postTitle: post.title, postSubtitle: subtitle, upVotes: post.ups, comments: post.num_comments))
        }
        return createdcells
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsresult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = finishedposts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Posts", for: indexPath) as! PostCellTableViewCell
        cell.setPost(postObject: post)
        cell.thumbnailImage.sd_setImage(with: URL(string: postsresult[indexPath.row].data.thumbnail), placeholderImage: UIImage(named: "icons8-align-center-100"))
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetailViewController()
//        vc.detailItem = postsresult[indexPath.row].data
//        navigationController?.pushViewController(vc, animated: true)
//    }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DisplayContent") as? ContentViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    

}
