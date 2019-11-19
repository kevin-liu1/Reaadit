//
//  ImageContentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-09.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

class ImageContentCell: UITableViewCell {

    
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var contentImage: UIImageView!
    
    @IBOutlet var postTitleLabel: UILabel!
    

    @IBOutlet var upvoteLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!

    var imagename: String?
    
    
    func setContent(content: ContentImage) {
        authorLabel.text = content.author
        self.imagename = content.image
        contentImage.sd_setImage(with: URL(string: imagename ?? ""), placeholderImage: UIImage(named: "Ash-Grey"))
        contentImage.layer.cornerRadius = 7
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        contentImage.isUserInteractionEnabled = true
        contentImage.addGestureRecognizer(tapGesture)
        
        postTitleLabel.text = content.postTitle
        upvoteLabel.text = String(content.upVotecount)
        
        timeLabel.text = Network().soMuchTimeAgo(postedDate: content.timeposted)
        
    }
    
    @objc func tapImage() {
        let clickimagename = Notification.Name("clickImage")
        NotificationCenter.default.post(name: clickimagename, object: imagename ?? "")
    }
}
