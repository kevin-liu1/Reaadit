//
//  PostsView.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit


class PostsView: UITableViewController {

    
    var postsresult = [Posts]()
    var subreddit: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = subreddit
        let urlString = "https://www.reddit.com/r/" + subreddit!.lowercased() + "/.json?limit=500"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        // Do any additional setup after loading the view.
        
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPosts = try? decoder.decode(Wraps.self, from: json) {
            postsresult = jsonPosts.data.children
            tableView.reloadData()
        } else {
            print("Error with getting json")
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsresult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Posts", for: indexPath) as! PostCellTableViewCell
        let finalcell = setPost(cell: cell, indexPath: indexPath)
        
        return finalcell
    }
    
    //function configure the Post Cell. 
    func setPost(cell: PostCellTableViewCell, indexPath: IndexPath) -> PostCellTableViewCell {
        let singlepost = postsresult[indexPath.row]
        
        let url = URL(string: singlepost.data.thumbnail)
        let defaulturl = URL(string: "https://aliceasmartialarts.com/wp-content/uploads/2017/04/default-image-150x150.jpg")
        let data = try? Data(contentsOf: url ?? defaulturl!)
        
        //setting the individual images
        //let defaultpic = UIImage(named: "icons8-align-center-100.png")
        let defaultdata = try? Data(contentsOf: defaulturl!)
        
        cell.thumbnailImage?.image = UIImage(data: data ?? defaultdata!)
        
        cell.thumbnailImage?.contentMode = .scaleAspectFill
        cell.thumbnailImage.layer.cornerRadius = 10 //curved corners for image
        
        //setting the labels
        if subreddit == "popular" || subreddit == "all" {
            cell.postTitle.text = singlepost.data.title
            cell.postSubtitle.text = singlepost.data.subreddit
            
        } else {
            
            cell.postTitle.text = singlepost.data.title
            cell.postSubtitle.text = singlepost.data.author
            
        }
        
        //setting the upvotes and comments
        let upvote = UIImage(named: "icons8-up-100-2.png") // setting upcote icon
        cell.upVoteIcon?.image = upvote
        cell.upVotes.text = String(singlepost.data.ups)
        
        let comment = UIImage(named: "icons8-topic-100-2.png")
        cell.commentsIcon?.image = comment
        cell.comments.text = String(singlepost.data.num_comments)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = postsresult[indexPath.row].data
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
