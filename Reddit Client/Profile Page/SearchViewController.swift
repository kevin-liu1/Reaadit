//
//  SearchViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    //@IBOutlet var refreshview: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Username"
        // Do any additional setup after loading the view.
        

        
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pullData), for: .valueChanged)
        //self.refreshview.addSubview(refreshControl)
        
        if  let path        = Bundle.main.path(forResource: "UserData", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let userdata = try? PropertyListDecoder().decode(UserData.self, from: xml)
        {
            print("This is user data from another view:" + userdata.userName)
            self.title = userdata.userName
        } else {
            print("extraction didn't work")
        }
        
        
    }
    
    @objc func pullData(){

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
