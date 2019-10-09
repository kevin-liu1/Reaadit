//
//  LinkContentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import SafariServices

import SafariServices

protocol PlayVideoCellProtocol {
    func playVideoButtonDidSelect(url: String)
}

class LinkContentCell: UITableViewCell {
    var delegate: PlayVideoCellProtocol!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var buttonLabel: UIButton!
    
    @IBOutlet var upvoteLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    var url: String?
    
    func setContent(contentLink: ContentLink) {
        self.titleLabel.text = contentLink.postTitle
        //buttonLabel.titleLabel?.text = contentLink.link
        buttonLabel.setTitle(contentLink.link, for: .normal)
        upvoteLabel.text = String(contentLink.upVotecount)
        timeLabel.text = contentLink.time
        
        print(contentLink.link)
        self.url = contentLink.link
        
        
    }
    
    @IBAction func playVideo(_sender: AnyObject) {
        self.delegate.playVideoButtonDidSelect(url: self.url ?? "")
    }
    

    
}
