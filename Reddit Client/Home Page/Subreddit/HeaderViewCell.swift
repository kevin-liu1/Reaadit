//
//  HeaderViewCell.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-11.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import UIKit

class HeaderViewCell: UITableViewCell {

    @IBOutlet var headerLabel: UILabel!
    
    func setHeader(header: Header) {
        headerLabel.text = header.label
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
