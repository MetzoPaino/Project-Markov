//
//  ColorPickerModel.swift
//  Project Markov
//
//  Created by William Robinson on 22/03/2015.
//  Copyright (c) 2015 William Robinson. All rights reserved.
//

import UIKit

class ColorPickerModel: NSObject {
    
    private let redColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    private let blueColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
    private let yellowColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1.0)
    private let greenColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)

    let availableColors = [UIColor]()
    
    override init() {
        availableColors = [redColor, blueColor, yellowColor, greenColor]
    }
}
