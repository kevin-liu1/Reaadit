//
//  ProfileCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-11.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileCell: UITableViewCell {
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var displayName: UILabel!
    
    @IBOutlet var postKarma: UILabel!
    
    @IBOutlet var commentKarma: UILabel!
    
    @IBOutlet var profileCardView: UIView!
    
    @IBOutlet var cardView: UIView!
    
    func setUp(profilecell: ProfileHolder) {
        profileImage.image = UIImage(named: "profileicon")
//        profileImage.sd_setImage(with: URL(string: profilecell.icon_img), placeholderImage: UIImage(named: "profileicon"))
        profileImage.layer.cornerRadius = 25
        profileCardView.layer.cornerRadius = 10
        userName.text = profilecell.name
        displayName.text = profilecell.display_name
        postKarma.text = String(profilecell.link_karma)
        commentKarma.text = String(profilecell.comment_karma)
        
        self.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        self.layer.cornerRadius = 10
        
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 4
        
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        //set the values for top,left,bottom,right margins
//                let margins = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
//        contentView.frame = contentView.frame.inset(by: margins)
//    }
    
}
