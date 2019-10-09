//
//  ContentViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-05.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import Just
import SafariServices
import AVKit
import AVFoundation

class ContentViewController: UITableViewController, OpenLinkProtocol, playVideoProtocol {
    
    var currentSub: String? //passed by prev VC
    var currentTitle: String?
    var upVotes: Int?
    
    var contentCell: Content?
    var contentCellImage: ContentImage?
    var contentCellLink: ContentLink?
    var contentCellVideo: ContentVideo?
    
    var contentID: String? //passed by previous VC
    var accessToken: String?
    
    var commentListFinal = [CommentType]()
    
    let defaults = UserDefaults.standard
    
    
    var commentList = [CommentKind]()
    var content = [CommentKind]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentSub
        
 
        tableView.dataSource = self
        tableView.delegate = self
        
        let videocell = UINib(nibName: "RichVideoContentCell", bundle: nil)
        let imagecell = UINib(nibName: "ImageContentCell", bundle: nil)
        let linkcell = UINib(nibName: "LinkContentCell", bundle: nil)
        tableView.register(videocell, forCellReuseIdentifier: "RichVideoCell")
        tableView.register(imagecell, forCellReuseIdentifier: "Picture")
        tableView.register(linkcell, forCellReuseIdentifier: "LinkCell")
        
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        
        group.enter()
        dispatchQueue.async{
            //tasks here
            if self.defaults.bool(forKey: "logStatus"){
                self.getJson()
             } else {
                 print("Not Logged In")
             }


            
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.createContent()
            self.createComments()
            self.tableView.reloadData()
        }
        

        print("This is access Token: " + (self.accessToken ?? "none") )
        

    }
    
    func getJson() {
        accessToken = defaults.string(forKey: "accessToken")
        let userJson = Just.get("https://oauth.reddit.com/r/" + (self.currentSub!).lowercased() + "/comments/" + contentID! + "?limit=25", headers:["Authorization": "bearer \(accessToken ?? "")"])
        
        let decoder = JSONDecoder()
        if let comments = try? decoder.decode([PostKind].self, from: userJson.content!) {
            print("decoded comment json")
            print(comments[0].data.children)
            self.commentList = comments[1].data.children
            self.content = comments[0].data.children
            
        } else {
            RefreshLogin().getAccessToken()
            getJson()
            print("Error with getting comment json")
            
        }
    }

    func createContent() {
        let contentthings = self.content[0].data
        if contentthings.is_self! {
            self.contentCell = Content(postTitle: currentTitle ?? "", upVoteCount: self.upVotes ?? 10, time: "10 Minutes", selftext: contentthings.selftext ?? "", thumbnail: contentthings.thumbnail ?? "none")
        } else {
            switch contentthings.post_hint {
            case "image":
                print(contentthings.preview?.images?[0].source?.url ?? "No URL")
                self.contentCellImage = ContentImage(postTitle: contentthings.title ?? "No title", upVotecount: contentthings.ups ?? 0, time: "NA", image: (contentthings.url ?? "No URL"))
            case "link":
                self.contentCellLink = ContentLink(postTitle: contentthings.title ?? "No Link", upVotecount: contentthings.ups ?? 0, time: "NA", link: contentthings.url ?? "no url found")
            case "rich:video":
                self.contentCellVideo = ContentVideo(postTitle: contentthings.title ?? "No Video Title", upVotecount: contentthings.ups ?? 0, time: "NA", link: contentthings.thumbnail ?? "none", videolink: contentthings.url ?? "none")
            case "hosted:video":
                self.contentCellVideo = ContentVideo(postTitle: contentthings.title!, upVotecount: contentthings.ups!, time: "NA", link: contentthings.thumbnail!, videolink: contentthings.secure_media?.reddit_video?.fallback_url ?? "None")
            default:
                self.contentCellLink = ContentLink(postTitle: contentthings.title!, upVotecount: contentthings.ups!, time: "NA", link: contentthings.url!)
            }
        }
        self.contentCell = Content(postTitle: currentTitle ?? "", upVoteCount: self.upVotes ?? 10, time: "10 Minutes", selftext: contentthings.selftext ?? "", thumbnail: contentthings.thumbnail ?? "none")

    }
    
    func createComments() {
        for comment in self.commentList {
            let com = comment.data
            let commentcell = CommentType(author: com.author ?? "No Author", upvotes: com.ups ?? -1, time: "10 Minutes", textbody: com.body ?? "Empty Body")
            commentListFinal.append(commentcell)
            
        }
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
            return commentListFinal.count
        default:
            return 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("Arrived at cellforrowat")
        
        if self.content.count > 0 {
            switch indexPath.section {
            case 0:
                if self.content[0].data.is_self ?? false {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as! ContentCellSelf
                    cell.setContent(Content: contentCell!)
                    return cell
                } else {
                    switch self.content[0].data.post_hint {
                    case "image":
                        print("Match Image")
                        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as! ImageContentCell
                        cell.setContent(content: contentCellImage!)
                        return cell
                    case "link":
                        print("match Link")
                        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkContentCell
                        cell.setContent(contentLink: contentCellLink!)
                        cell.delegate = self
                        return cell
                    case "rich:video":
                        print("Match Video")
                        let cell = tableView.dequeueReusableCell(withIdentifier: "RichVideoCell", for: indexPath) as! RichVideoContentCell
                        cell.setContent(contentVideo: contentCellVideo!)
                        cell.delegate = self
                        return cell
                    case "hosted:video":
                        print("Match Video")
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "RichVideoCell", for: indexPath) as! RichVideoContentCell
                        cell.setContent(contentVideo: contentCellVideo!)
                        cell.delegate = self
                        return cell
                    default:
                        print("didn't match any case")
                        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkContentCell
                        cell.setContent(contentLink: contentCellLink!)
                        cell.delegate = self
                        return cell
                    }
                    
                }

            case 1:
                //comments
                let cell = tableView.dequeueReusableCell(withIdentifier: "Comments", for: indexPath) as! CommentCell
                let comment = commentListFinal[indexPath.row]
                cell.setCommentCell(comment: comment)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as! ContentCellSelf
                return cell
            }
        }
        
        //loading screen.
        let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as! ContentCellSelf
        cell.postTitleLabel.text = ""
        cell.bodyTextLabel?.text = ""
        return cell
        
    }
    
    func openLinkinBrowser(url: String) {
        let contentthings = self.content[0].data
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        let vc = SFSafariViewController(url: URL(string: contentthings.url!)!, configuration: config)
        self.present(vc, animated: true)
    }
    
    func playVideoOnClick(url: String) {
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        
        //let player = AVPlayer(url: URL(string: )!)
        let vc = AVPlayerViewController()
        vc.player = player
        print(url)
        self.present(vc, animated: true, completion: {
            player.play()
            }
        )
    }
    


}
