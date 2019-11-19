//
//  PictureViewerVCViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-11-14.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import SDWebImage

class PictureViewerVCViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var image: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pullGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeViewer))
        imageView.sd_setImage(with: URL(string: image ?? ""), placeholderImage: UIImage(named: "Ash-Grey"))
        imageView.addGestureRecognizer(pullGesture)
        self.view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.hidesBarsOnTap = true
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnTap = false
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func closeViewer() {
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
