//
//  TweetCell.swift
//  Twitter-iOS
//
//  Created by Md Miah on 2/22/16.
//  Copyright © 2016 Naim. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    var tweet: Tweet! {
        didSet {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //Image.layer.cornerRadius = 3
        //Image.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
