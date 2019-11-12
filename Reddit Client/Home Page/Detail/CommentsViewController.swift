//
//  CommentsViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-22.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyComments
import Just
import AVKit

class FoldableRedditCommentsViewController: RedditCommentsViewController, CommentsViewDelegate {

    func commentCellExpanded(atIndex index: Int) {
        updateCellFoldState(false, atIndex: index)
    }

    func commentCellFolded(atIndex index: Int) {
        updateCellFoldState(true, atIndex: index)
    }

    private func updateCellFoldState(_ folded: Bool, atIndex index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! RedditCommentCell
        cell.animateIsFolded(fold: folded)
        (self.currentlyDisplayed[index] as! RichComment).isFolded = folded
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    override func viewDidLoad() {
        self.fullyExpanded = true
        super.viewDidLoad()
        self.delegate = self

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCom: AbstractComment = currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row

        // Enable cell folding for comments without replies
        if selectedCom.replies.count == 0 {
            if (selectedCom as! RichComment).isFolded {
                commentCellExpanded(atIndex: selectedIndex)
            } else {
                commentCellFolded(atIndex: selectedIndex)
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }


}

class RedditCommentsViewController: CommentsViewController {
    var contentID: String?
    var currentSub: String?
    var upVotes: Int?
    var currentTitle: String?
    
    private let commentCellId = "redditComentCellId"
    var allComments: [RichComment] = [] // All the comments (nested, not in a linear format)
    
    var commentList = [CommentKind]()
    var content = [CommentKind]()
    var contentCell: Content?
    var contentCellImage: ContentImage?
    var contentCellLink: ContentLink?
    var contentCellVideo: ContentVideo?
    
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videocell = UINib(nibName: "RichVideoContentCell", bundle: nil)
        let imagecell = UINib(nibName: "ImageContentCell", bundle: nil)
        let linkcell = UINib(nibName: "LinkContentCell", bundle: nil)
        let youtubeCell = UINib(nibName: "PlayYoutubeCell", bundle: nil)
        let actionscell = UINib(nibName: "ActionsCell", bundle: nil)
        tableView.register(videocell, forCellReuseIdentifier: "RichVideoCell")
        tableView.register(imagecell, forCellReuseIdentifier: "Picture")
        tableView.register(linkcell, forCellReuseIdentifier: "LinkCell")
        tableView.register(youtubeCell, forCellReuseIdentifier: "YoutubeCell")
        tableView.register(actionscell, forCellReuseIdentifier: "Actions")
        
        tableView.register(RedditCommentCell.self, forCellReuseIdentifier: commentCellId)

        tableView.backgroundColor = RedditConstants.backgroundColor
        let accessToken = defaults.string(forKey: "accessToken")
        let userJson = Just.get("https://oauth.reddit.com/r/" + (self.currentSub!).lowercased() + "/comments/" + contentID!, params: ["limit": 10, "depth": 10], headers:["Authorization": "bearer \(accessToken ?? "")"])
        
        allComments = GenerateComments.generate(json: userJson.content ?? Data()).comments
        

        currentlyDisplayed = allComments

        self.swipeToHide = true
        self.swipeActionAppearance.swipeActionColor = RedditConstants.flashyColor
    }
    
    override open func commentsView(_ tableView: UITableView, commentCellForModel commentModel: AbstractComment, atIndexPath indexPath: IndexPath) -> CommentCell {
        
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! RedditCommentCell
        let comment = currentlyDisplayed[indexPath.row] as! RichComment
        commentCell.level = comment.level
        commentCell.commentContent = comment.body
        commentCell.posterName = comment.posterName
        commentCell.date = comment.soMuchTimeAgo()
        commentCell.upvotes = comment.upvotes
        commentCell.isFolded = comment.isFolded && !isCellExpanded(indexPath: indexPath)
        return commentCell
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = RedditConstants.flashyColor
        self.navigationController?.navigationBar.tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}
