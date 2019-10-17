//
//  ActionsCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-16.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

class ActionsCell: UITableViewCell {
    let defaults = UserDefaults.standard
    
    @IBAction func upVote(_sender: AnyObject) {
        print("up vote button clicked")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if !(self.defaults.object(forKey: "upVoteList") as? [String] ?? [String]()).contains(contentID!) {
            print("add upvote")
            print("ContentId is " + contentID!)
            var tempset = defaults.object(forKey: "upVoteList") as? [String] ?? [String]()
            tempset.append(contentID ?? "")
            self.defaults.set(Array(Set(tempset)), forKey: "upVoteList")
            Network().Vote(id: (contentID ?? "None"), direction: 1)
            upVoteSettings.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            print("Remove vote")
            var tempset = defaults.object(forKey: "upVoteList") as? [String] ?? [String]()
            if let a = tempset.firstIndex(of: contentID!) {
                tempset.remove(at: a)
            }
            upVoteSettings.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.defaults.set(Array(Set(tempset)), forKey: "upVoteList")
            Network().Vote(id: self.contentID!, direction: 0)
        }


    }
    
    @IBAction func downVote(_sender: AnyObject) {
        Network().Vote(id: "t3_" + (contentID ?? "None"), direction: -1)
        downVoteSettings.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
    }
    
    @IBAction func comment(_sender: AnyObject) {
        
    }
    
    @IBAction func share(_sender: AnyObject) {
        
    }
    

    @IBOutlet var upVoteSettings: UIButton!
    
    @IBOutlet var downVoteSettings: UIButton!
    
    var contentID: String?
    func setContent(ID: String) {
        contentID = "t3_" + (ID)

        upVoteSettings.layer.cornerRadius = 5
        downVoteSettings.layer.cornerRadius = 5
        if (self.defaults.object(forKey: "upVoteList") as? [String] ?? [String]()).contains("t3_" + ID) {
            upVoteSettings.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else {
            upVoteSettings.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    
}
