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
    @IBOutlet var voteButtonStatus: UIButton!
    @IBAction func playVideo(_sender: AnyObject) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if !(self.defaults.object(forKey: "upVoteList") as? [String] ?? [String]()).contains("t3_" + postID!) {
            var tempset = defaults.object(forKey: "upVoteList") as? [String] ?? [String]()
            print("before add", tempset)
            tempset.append("t3_" + postID!)
            
            print(postID)
            print(tempset)
            self.defaults.set(Array(Set(tempset)), forKey: "upVoteList")
            upVotes.setTitle(String((Int(upVotes.titleLabel?.text ?? "0")!) + 1), for: .normal)
            Network().Vote(id: "t3_" + self.postID!, direction: 1)
            voteButtonStatus.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            upVotes.titleLabel?.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            var tempset = defaults.object(forKey: "upVoteList") as? [String] ?? [String]()
            if let a = tempset.firstIndex(of: "t3_" + postID!) {
                tempset.remove(at: a)
            }
            upVotes.setTitle(String((Int(upVotes.titleLabel?.text ?? "0")!) - 1), for: .normal)
            self.defaults.set(Array(Set(tempset)), forKey: "upVoteList")
            Network().Vote(id: "t3_" + self.postID!, direction: 0)
            voteButtonStatus.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            upVotes.titleLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
    }
    
    func setPost(postObject: PostObject) {
        self.postID = postObject.id
        if (self.defaults.object(forKey: "upVoteList") as? [String] ?? [String]()).contains("t3_" + postID!) {
            voteButtonStatus.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            voteButtonStatus.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
        }
        
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
