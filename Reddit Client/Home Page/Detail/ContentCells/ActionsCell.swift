//
//  ActionsCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-16.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

protocol shareProtocol{
    func sharePostOnClick()
}

class ActionsCell: UITableViewCell {
    let defaults = UserDefaults.standard
    var delegate: shareProtocol!
    
    @IBAction func upVote(_sender: AnyObject) {
        
        print("up vote button clicked")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if defaults.string(forKey: contentID!) == "nil" {
            defaults.set("true", forKey: contentID!)
            Network().Vote(id: (realID ?? "None"), direction: 1)
            upVoteSettings.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else if defaults.string(forKey: contentID!) == "true" {
            defaults.set("nil", forKey: contentID!)
            upVoteSettings.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            Network().Vote(id: realID ?? "None", direction: 0)
        } else if defaults.string(forKey: contentID!) == "false" {
            upVoteSettings.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            defaults.set("true", forKey: contentID!)
            Network().Vote(id: realID ?? "None", direction: 1)
            downVoteSettings.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            downVoteSettings.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func downVote(_sender: AnyObject) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if defaults.string(forKey: contentID!) == "nil" {
            defaults.set("false", forKey: contentID!)
            downVoteSettings.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            downVoteSettings.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            Network().Vote(id: (realID ?? "None"), direction: -1)
        } else if defaults.string(forKey: contentID!) == "false" {
            defaults.set("nil", forKey: contentID!)
            downVoteSettings.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            downVoteSettings.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            Network().Vote(id: realID ?? "None", direction: 0)
        } else if defaults.string(forKey: contentID!) == "true" {
            Network().Vote(id: realID ?? "none", direction: -1)
            defaults.set("false", forKey: contentID!)
            downVoteSettings.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            downVoteSettings.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            upVoteSettings.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func comment(_sender: AnyObject) {
        
    }
    
    @IBAction func share(_sender: AnyObject) {
        print("up vote button clicked")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        self.delegate.sharePostOnClick()
    }
    

    @IBOutlet var upVoteSettings: UIButton!
    
    @IBOutlet var downVoteSettings: UIButton!
    
    var contentID: String?
    var realID: String?
    func setContent(ID: String) {
        contentID = ID
        realID = "t3_" + ID

        upVoteSettings.layer.cornerRadius = 5
        downVoteSettings.layer.cornerRadius = 5
        if defaults.string(forKey: contentID!) == "true" {
            upVoteSettings.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        } else if defaults.string(forKey: contentID!) == "false" {
            downVoteSettings.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            downVoteSettings.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        } else if defaults.string(forKey: contentID!) == "nil" {
            upVoteSettings.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            upVoteSettings.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            downVoteSettings.tintColor = #colorLiteral(red: 0.4309871329, green: 0.5246428922, blue: 0.796692011, alpha: 1)
            downVoteSettings.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
