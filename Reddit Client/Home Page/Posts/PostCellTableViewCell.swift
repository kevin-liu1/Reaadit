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

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postSubtitle: UILabel!
    @IBOutlet var thumbnailImage: UIImageView!
    
    @IBOutlet var upVoteIcon: UIImageView!
    @IBOutlet weak var upVotes: UILabel!
    
    @IBOutlet var commentsIcon: UIImageView!
    @IBOutlet weak var comments: UILabel!
    
    func setPost(postObject: PostObject) {
        
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
