//
//  RichVideoContentCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-07.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage

class RichVideoContentCell: UITableViewCell {
    

    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var upVoteLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var thumbnailImageTemp: UIButton?
    
    var tempImage: UIImageView?
    
    var videoURL: URL?
    
    func setContent(contentVideo: ContentVideo) {
        titleLabel.text = contentVideo.postTitle
        upVoteLabel.text = String(contentVideo.upVotecount)
        timeLabel.text = "NA"
        tempImage?.sd_setImage(with: URL(string: contentVideo.link), placeholderImage: UIImage(named: "icons8-reddit-100"))
        thumbnailImageTemp?.setImage(tempImage?.image?.withRenderingMode(.alwaysOriginal), for: .normal)
        
//        self.thumbnailImageTemp.imageView?.sd_setImage(with: URL(string: contentVideo.link), placeholderImage: UIImage(named: "icons8-reddit-100"))
        
        
    }
    
//    @IBAction func playVideo(_sender: UIButton) {
//        videoURL = URL(string: "String")
//        let player = AVPlayer(url: videoURL!)
//        let vc = AVPlayerViewController()
//        vc.player = player
//        vc.present(vc, animated: true) {
//            vc.player?.play()
//        }
//    }
    
}
