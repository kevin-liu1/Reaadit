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
    
    @IBOutlet var upVoteIcon: UIImageView!
    @IBOutlet weak var upVotes: UILabel!
    
    @IBOutlet var commentsIcon: UIImageView!
    @IBOutlet weak var comments: UILabel!
    
    func setPost(postObject: PostObject) {
        
        if (self.defaults.object(forKey: "selectedList") as? [String] ?? [String]()).contains(postObject.id) {
            postTitle.textColor = .lightGray
            postSubtitle.textColor = .lightGray
            upVotes.textColor = .lightGray
            comments.textColor = .lightGray
            //backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            postTitle.textColor = .black
            postSubtitle.textColor = .black
            upVotes.textColor = .black
            comments.textColor = .black
        }
        
        
        postTitle.text = postObject.postTitle
        postSubtitle.text = postObject.postSubtitle
        
        upVotes.text = String(postObject.upVotes)
        comments.text = String(postObject.comments)
        
        let link = postObject.thumbnailURL.replacingOccurrences(of: "amp;", with: "")
        thumbnailImage.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: "icons8-align-center-100"))
        
        thumbnailImage?.contentMode = .scaleAspectFill
        thumbnailImage.layer.cornerRadius = 10
        
    }
    
}
