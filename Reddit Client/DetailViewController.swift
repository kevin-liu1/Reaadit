//
//  DetailViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-01.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var detailItem: Post?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        guard let detailItem = detailItem else { return }
        let postsite = "https://www.reddit.com" + detailItem.permalink
        let url = URL(string: postsite)!
        webView.load(URLRequest(url: url))
        
        /*
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        <h3>\(detailItem.title)</h3>
        <p>\(detailItem.selftext)</p>
        <a href="\(detailItem.url)"> \(detailItem.url) </a>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)

        
        //let url = URL(string: detailItem.url)
        //webView.load(URLRequest(url: url!))
        */
        
        
        
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
