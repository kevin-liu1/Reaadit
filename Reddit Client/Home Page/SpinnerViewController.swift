//
//  SpinnerViewController.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-11.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation
import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .medium)

    override func loadView() {
        view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        spinner.color = #colorLiteral(red: 0.3626809125, green: 0.5487725345, blue: 0.796692011, alpha: 1)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
