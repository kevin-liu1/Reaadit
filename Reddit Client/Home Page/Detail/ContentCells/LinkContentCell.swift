//
//  LinkContentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import SafariServices
import SDWebImage


protocol OpenLinkProtocol {
    func openLinkinBrowser(url: String)
}

class LinkContentCell: UITableViewCell {
    var delegate: OpenLinkProtocol!
    
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var buttonLabel: UIButton!
    
    @IBOutlet var upvoteLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var linkImage: UIImageView!
    
    var url: String?
    
    func setContent(contentLink: ContentLink) {
        authorLabel.text = contentLink.author
        
        self.titleLabel.text = contentLink.postTitle
        //buttonLabel.titleLabel?.text = contentLink.link
        buttonLabel.setTitle(contentLink.link, for: .normal)
        upvoteLabel.text = String(contentLink.upVotecount)
        timeLabel.text = contentLink.time
        
        //print(contentLink.link)
        self.url = contentLink.link
        
        buttonLabel.layer.cornerRadius = 5
        //print(contentLink.thumbnail)
        let link = contentLink.thumbnail.replacingOccurrences(of: "amp;", with: "")
        linkImage.sd_setImage(with: URL(string: link), placeholderImage: UIImage(named: "icons8-list-view-80"))
        
        linkImage.layer.cornerRadius = 7
        
    }
    
    @IBAction func openLinkInBrowser(_sender: AnyObject) {
        self.delegate.openLinkinBrowser(url: self.url ?? "")
    }
    

    
}
