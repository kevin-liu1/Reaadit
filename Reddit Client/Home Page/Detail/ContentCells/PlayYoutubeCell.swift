//
//  PlayYoutubeCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-09.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class PlayYoutubeCell: UITableViewCell {

    
    @IBOutlet var playerView: WKYTPlayerView!
    var videoURL: String?
    var splitUrl: String?
    
    
    func setVideo(contentVideo: ContentVideo) {
        videoURL = contentVideo.videolink
        print(videoURL)
        if videoURL?.contains("youtu.be") ?? false {
            splitUrl = videoURL?.components(separatedBy: "youtu.be/")[1]
        } else if videoURL?.contains("share") ?? false {
            let firstsplit = videoURL?.components(separatedBy: "?v=")
            let secondsplit = firstsplit?[1].components(separatedBy: "&amp") ?? [""]
            splitUrl = secondsplit[0]
        } else {
            splitUrl = videoURL?.components(separatedBy: "?v=")[1]
        }
        
        
        
        playerView.load(withVideoId: splitUrl ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //playerView.loadVideo(byURL: "https://www.youtube.com/watch?v=h8lgYMB10g4", startSeconds: 0.0, suggestedQuality: .HD1080)
//        playerView.load(withVideoId: "h8lgYMB10g4")
    }

}
