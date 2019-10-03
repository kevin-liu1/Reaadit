//
//  PostCellTableViewCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

class PostCellTableViewCell: UITableViewCell {

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postSubtitle: UILabel!
    @IBOutlet var thumbnailImage: UIImageView!
    
    @IBOutlet var upVoteIcon: UIImageView!
    @IBOutlet weak var upVotes: UILabel!
    
    @IBOutlet var commentsIcon: UIImageView!
    @IBOutlet weak var comments: UILabel!
    
}
