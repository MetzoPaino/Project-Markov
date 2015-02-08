//
//  ThemeTableViewCell.swift
//  Project Markov
//
//  Created by William Robinson on 26/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var motifs: UILabel!
    @IBOutlet weak var variations: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
