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


class ContentViewController: UITableViewController, OpenLinkProtocol, playVideoProtocol, linkHandlingProtocol {

    
    
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
    var commentList3List = [CommentList3]()
    var content = [CommentKind]()
    
    var CommentTreeList = [CommentTree]()
    
    override func loadView() {
        super.loadView()
        createSpinnerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = currentSub
        
        //createSpinnerView()
        tableView.dataSource = self
        tableView.delegate = self
        
        let videocell = UINib(nibName: "RichVideoContentCell", bundle: nil)
        let imagecell = UINib(nibName: "ImageContentCell", bundle: nil)
        let linkcell = UINib(nibName: "LinkContentCell", bundle: nil)
        let youtubeCell = UINib(nibName: "PlayYoutubeCell", bundle: nil)
        tableView.register(videocell, forCellReuseIdentifier: "RichVideoCell")
        tableView.register(imagecell, forCellReuseIdentifier: "Picture")
        tableView.register(linkcell, forCellReuseIdentifier: "LinkCell")
        tableView.register(youtubeCell, forCellReuseIdentifier: "YoutubeCell")
        
        
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        let group = DispatchGroup()
        
        group.enter()
        dispatchQueue.async{
            //tasks here
            if self.defaults.bool(forKey: "logStatus"){
                self.getJson()
             } else {
                print("Not Logged In")
                self.getJsonLoggedOut()
             }


            
            group.leave()
        }
        
        group.notify(queue: .main) {
//            for comment in self.commentList {
//                let initialCommentTree = CommentTree(author: comment.data.author ?? "", upVotes: comment.data.ups ?? 0, time: "10", textbody: comment.data.body ?? "No body")
//                self.createCommentTree(commentTree: initialCommentTree, comment: comment.data)
//            }
            
            self.createContent()
            self.createComments()
            self.tableView.reloadData()
        }
        

        print("This is access Token: " + (self.accessToken ?? "none") )
        

    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    

    
//    func createCommentTree(commentTree: CommentTree, comment: ContentorComment) {
//        if (comment.replies?.count) != nil {
//            for kind in comment.replies! {
//                for kind1 in kind.data.children! {
//                    commentTree.replies?.append(CommentTree(author: kind1.data.author ?? "none", upVotes: kind1.data.ups ?? 0, time: "10", textbody: kind1.data.body ?? "no body"))
//                    createCommentTree(commentTree: commentTree, comment: kind1.data)
//                }
//            }
//        }
//    }
    
    
    func getJson() {
        accessToken = defaults.string(forKey: "accessToken")
        let userJson = Just.get("https://oauth.reddit.com/r/" + (self.currentSub!).lowercased() + "/comments/" + contentID! + "?limit=25", headers:["Authorization": "bearer \(accessToken ?? "")"])
        
        let decoder = JSONDecoder()
        if let contents = try? decoder.decode([PostKind].self, from: userJson.content!) {
            print("decoded comment json")
            //print(contents[0].data.children)
            self.commentList = contents[1].data.children!
            self.content = contents[0].data.children!
            
        } else {
            print("Error with getting comment json")
            
        }
        
    }
    
    func getJsonLoggedOut() {
        accessToken = defaults.string(forKey: "accessToken")
        let userJson = Just.get("https://www.reddit.com/r/" + (self.currentSub!).lowercased() + "/comments/" + contentID! + "/limit=25.json")
        
        let decoder = JSONDecoder()
        if let contents = try? decoder.decode([PostKind].self, from: userJson.content!) {
            print("decoded comment json")
            
            self.commentList = contents[1].data.children!
            self.content = contents[0].data.children!
            
        } else {
            print("Error with getting comment json")
            
        }
        
    }

    
    func createContent() {
        let contentthings = self.content[0].data
        if contentthings.is_self! {
            self.contentCell = Content(author: contentthings.author ?? "", postTitle: currentTitle ?? "", upVoteCount: self.upVotes ?? 10, time: "10 Minutes", selftext: contentthings.selftext ?? "", thumbnail: contentthings.thumbnail ?? "none")
        } else {
            switch contentthings.post_hint {
            case "image":
                print(contentthings.preview?.images?[0].source?.url ?? "No URL")
                self.contentCellImage = ContentImage(author: contentthings.author ?? "", postTitle: contentthings.title ?? "No title", upVotecount: contentthings.ups ?? 0, time: "NA", image: (contentthings.url ?? "No URL"))
            case "link":
                self.contentCellLink = ContentLink(author: contentthings.author ?? "", postTitle: contentthings.title ?? "No Link", upVotecount: contentthings.ups ?? 0, time: "NA", link: contentthings.url ?? "no url found", thumbnail: contentthings.preview?.images?[0].source?.url ?? "")
            case "rich:video":
                self.contentCellVideo = ContentVideo(author: contentthings.author ?? "", postTitle: contentthings.title ?? "No Video Title", upVotecount: contentthings.ups ?? 0, time: "NA", link: contentthings.preview?.images?[0].source?.url ?? "", videolink: contentthings.url ?? "none")
            case "hosted:video":
                self.contentCellVideo = ContentVideo(author: contentthings.author ?? "", postTitle: contentthings.title!, upVotecount: contentthings.ups!, time: "NA", link: contentthings.preview?.images?[0].source?.url ?? "", videolink: contentthings.secure_media?.reddit_video?.hls_url ?? "None")
            default:
                
//                if contentthings.domain == "youtube.com" || contentthings.domain == "youtu.be.com" {
//                    self.contentCellVideo = ContentVideo(postTitle: contentthings.title ?? "No Video Title", upVotecount: contentthings.ups ?? 0, time: "NA", link: contentthings.thumbnail ?? "none", videolink: contentthings.url ?? "none")
//                }
                self.contentCellLink = ContentLink(author: contentthings.author ?? "", postTitle: contentthings.title!, upVotecount: contentthings.ups!, time: "NA", link: contentthings.url!, thumbnail: contentthings.preview?.images?[0].source?.url ?? "")
            }
        }
        self.contentCell = Content(author: contentthings.author ?? "", postTitle: currentTitle ?? "", upVoteCount: self.upVotes ?? 10, time: "10 Minutes", selftext: contentthings.selftext ?? "", thumbnail: contentthings.thumbnail ?? "none")

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
        if self.content.count > 0 {
            return 2
        } else{
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.content.count > 0 {
            switch section {
            case 0:
                return 1
            case 1:
                return commentListFinal.count
            default:
                return 1
            }
        } else {
            return 0
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
                        print("Match rich Video")
                        
                        let contenttemp = self.content[0].data.secure_media?.type
                        
                        if contenttemp == "youtube.com" {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeCell", for: indexPath) as! PlayYoutubeCell
                            cell.setVideo(contentVideo: contentCellVideo!)
                            return cell
                            
                        } else {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "RichVideoCell", for: indexPath) as! RichVideoContentCell
                            cell.setContent(contentVideo: contentCellVideo!)
                            cell.delegate = self
                            return cell
                        }

                        
                    case "hosted:video":
                        print("Match host Video")
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "RichVideoCell", for: indexPath) as! RichVideoContentCell
                        cell.setContent(contentVideo: contentCellVideo!)
                        cell.delegate = self
                        
                        //let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeCell", for: indexPath) as! PlayYoutubeCell
                        return cell
                    default:
                        print("didn't match any case")
//                        if self.content[0].data.domain == "youtube.com" || self.content[0].data.domain == "youtu.be.com" {
//                            let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeCell", for: indexPath) as! PlayYoutubeCell
//                           cell.setVideo(contentVideo: contentCellVideo!)
//                           return cell
//                        }
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
                cell.delegate = self
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
        cell.upvoteLabel.text = nil
        cell.timeLabel.text = ""
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

//        let player = AVPlayer(url: URL(string: "https://www.redditmedia.com/mediaembed/df6l4g")!)
        let vc = AVPlayerViewController()
        vc.player = player
        
        print(url)
        self.present(vc, animated: true, completion: {
            
            player.play()
            }
        )
        
    }
    
    //doesn't work yet, trying to open links in SafariviewController
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariViewController = SFSafariViewController(url: URL)
        present(safariViewController, animated: true, completion: nil)
        return false
    }

}
