//
//  MotifTableViewCell.swift
//  Project Markov
//
//  Created by William Robinson on 27/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit

class MotifTableViewCell: UITableViewCell {
    
    @IBOutlet var checkmarkImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
}
