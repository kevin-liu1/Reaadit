//
//  PostCellTableViewCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import SDWebImage

class PostCellTableViewCell: UITableViewCell {
    let defaults = UserDefaults.standard
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postSubtitle: UILabel!
    @IBOutlet var thumbnailImage: UIImageView!
    
    @IBOutlet weak var upVotes: UIButton!
    
    @IBOutlet var commentsIcon: UIImageView!
    @IBOutlet weak var comments: UILabel!
    
    var postID: String?
    var direction = 0
    var postlikes: String?
    @IBOutlet var voteButtonStatus: UIButton!
    @IBAction func clickUpVote(_sender: AnyObject) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if self.postlikes == "nil" {
            upVotes.setTitle(String((Int(upVotes.titleLabel?.text ?? "0")!) + 1), for: .normal)
            Network().Vote(id: "t3_" + self.postID!, direction: 1)
            voteButtonStatus.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            upVotes.titleLabel?.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            voteButtonStatus.setImage(UIImage(named: "arrow.up.circle"), for: .normal)
            self.postlikes = "true"
            defaults.set("true", forKey: self.postID!)
        } else if self.postlikes == "true" {
            upVotes.setTitle(String((Int(upVotes.titleLabel?.text ?? "0")!) - 1), for: .normal)
            voteButtonStatus.setImage(UIImage(named: "arrow.up.circle"), for: .normal)
            Network().Vote(id: "t3_" + self.postID!, direction: 0)
            voteButtonStatus.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            self.postlikes = "nil"
            defaults.set("nil",forKey: self.postID!)
        } else {
            upVotes.setTitle(String((Int(upVotes.titleLabel?.text ?? "0")!) + 1), for: .normal)
            Network().Vote(id: "t3_" + self.postID!, direction: 0)
            defaults.set("nil",forKey: self.postID!)
            self.postlikes = "nil"
            voteButtonStatus.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            upVotes.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
//        if !(self.defaults.object(forKey: "upVoteList") as? [String] ?? [String]()).contains("t3_" + postID!) {
//            var tempset = defaults.object(forKey: "upVoteList") as? [String] ?? [String]()
//            print("before add", tempset)
//            tempset.append("t3_" + postID!)
//
//            print(postID)
//            print(tempset)
//            self.defaults.set(Array(Set(tempset)), forKey: "upVoteList")
//            upVotes.setTitle(String((Int(upVotes.titleLabel?.text ?? "0")!) + 1), for: .normal)
//            Network().Vote(id: "t3_" + self.postID!, direction: 1)
//            voteButtonStatus.setImage(UIImage(named: "arrow.up.circle"), for: .normal)
//            voteButtonStatus.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
//            upVotes.titleLabel?.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
//        } else if (self.defaults.object(forKey: "downVoteList") as? [String] ?? [String]()).contains("t3_" + postID!) {
//            var tempset = defaults.object(forKey: "downVoteList") as? [String] ?? [String]()
//            if let a = tempset.firstIndex(of: "t3_" + postID!) {
//                tempset.remove(at: a)
//            }
//            upVotes.setTitle(String((Int(upVotes.titleLabel?.text ?? "0")!) + 1), for: .normal)
//            self.defaults.set(Array(Set(tempset)), forKey: "downVoteList")
//            voteButtonStatus.setImage(UIImage(named: "arrow.up.circle"), for: .normal)
//            Network().Vote(id: "t3_" + self.postID!, direction: 0)
//            voteButtonStatus.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
//
//        } else {
//            var tempset = defaults.object(forKey: "upVoteList") as? [String] ?? [String]()
//            if let a = tempset.firstIndex(of: "t3_" + postID!) {
//                tempset.remove(at: a)
//            }
//            upVotes.setTitle(String((Int(upVotes.titleLabel?.text ?? "0")!) - 1), for: .normal)
//            self.defaults.set(Array(Set(tempset)), forKey: "upVoteList")
//            Network().Vote(id: "t3_" + self.postID!, direction: 0)
//            voteButtonStatus.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
//            upVotes.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        }
        
    }
    
    func setPost(postObject: PostObject) {
        self.postID = postObject.id
        self.postlikes = postObject.likes
        
        if self.postlikes == "true" {
            voteButtonStatus.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            voteButtonStatus.setImage(UIImage(named: "arrow.up.circle"), for: .normal)
        } else if self.postlikes == "false" {
            voteButtonStatus.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            voteButtonStatus.setImage(UIImage(named: "arrow.down.circle"), for: .normal)
        } else {
            voteButtonStatus.setImage(UIImage(named: "arrow.up.circle"), for: .normal)
            voteButtonStatus.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
        }
        
        
        
//        if (self.defaults.object(forKey: "upVoteList") as? [String] ?? [String]()).contains("t3_" + postID!) {
//            voteButtonStatus.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
//            voteButtonStatus.setImage(UIImage(named: "arrow.up.circle"), for: .normal)
//        } else if (self.defaults.object(forKey: "downVoteList") as? [String] ?? [String]()).contains("t3_" + postID!) {
//            voteButtonStatus.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
//            voteButtonStatus.setImage(UIImage(named: "arrow.down.circle"), for: .normal)
//        } else {
//            voteButtonStatus.setImage(UIImage(named: "arrow.up.circle"), for: .normal)
//            voteButtonStatus.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
//        }
        
        if (self.defaults.object(forKey: "selectedList") as? [String] ?? [String]()).contains(postObject.id) {
            postTitle.textColor = .lightGray
            postSubtitle.textColor = .lightGray
            //upVotes.tintColor = .lightGray
            //comments.textColor = .lightGray
            //backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        else {
            postTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            postSubtitle.textColor = .black
            upVotes.tintColor = .black
            comments.textColor = .black
        }
        
        
        
        postTitle.text = postObject.postTitle
        postSubtitle.text = postObject.postSubtitle
        
        upVotes.setTitle(String(postObject.upVotes), for: .normal)
        comments.text = String(postObject.comments)
        
        let link = postObject.thumbnailURL.replacingOccurrences(of: "amp;", with: "")
        thumbnailImage.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: "icons8-align-center-100"))
        
        thumbnailImage?.contentMode = .scaleAspectFill
        thumbnailImage.layer.cornerRadius = 10
        
    }
    
}
