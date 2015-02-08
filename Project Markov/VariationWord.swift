//
//  MarkovWordTracker.swift
//  Project Markov
//
//  Created by William Robinson on 09/01/2015.
//  Copyright (c) 2015 William Robinson. All rights reserved.
//

import UIKit

class VariationWord: NSObject {
    var word = ""
    var checked = false
    var inUse = false
    var totalWordIndex: Int?
    var inUseIndex = [Int]()
    
    init(word: String) {
        self.word = word
        super.init()
    }
}

