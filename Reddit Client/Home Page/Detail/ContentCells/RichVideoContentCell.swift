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


protocol playVideoProtocol {
    func playVideoOnClick(url: String)
}

class RichVideoContentCell: UITableViewCell {
    var delegate: playVideoProtocol!

    
    
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var upVoteLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var thumbnailImageTemp: UIButton?
    
    
    
    var tempImage: UIImageView?
    
    var videoURL: String?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setContent(contentVideo: ContentVideo) {
        titleLabel.text = contentVideo.postTitle
        upVoteLabel.text = String(contentVideo.upVotecount)
        timeLabel.text = "NA"
        print(contentVideo.link)
//        tempImage?.sd_setImage(with: URL(string: contentVideo.link), placeholderImage: UIImage(named: "icons8-reddit-100"))
//        thumbnailImageTemp?.setImage(tempImage?.image?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        let link = contentVideo.link.replacingOccurrences(of: "amp;", with: "")
        
        thumbnailImageTemp?.sd_setBackgroundImage(with: URL(string: link), for: .normal)
        videoURL = contentVideo.videolink
//        self.thumbnailImageTemp.imageView?.sd_setImage(with: URL(string: contentVideo.link), placeholderImage: UIImage(named: "icons8-reddit-100"))
        
        
    }
    
    
    @IBAction func playVideo(_sender: AnyObject) {
        self.delegate.playVideoOnClick(url: self.videoURL ?? "")

        
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
