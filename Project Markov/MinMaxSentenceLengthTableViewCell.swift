//
//  MinimumSentenceLengthTableViewCell.swift
//  Project Markov
//
//  Created by William Robinson on 02/01/2015.
//  Copyright (c) 2015 William Robinson. All rights reserved.
//

import UIKit

class MinMaxSentenceLengthTableViewCell: UITableViewCell {

    @IBOutlet var minMaxSentenceLengthLabel: UILabel!
    @IBOutlet var minMaxSentenceLengthValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
