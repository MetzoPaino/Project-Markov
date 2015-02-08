//
//  Variation.swift
//  Project Markov
//
//  Created by William Robinson on 31/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit
import CloudKit

class Variation: NSObject, NSCoding {
   
    var sentenceComponents = [String]()
    var sentenceComponentsIndexes = [Int]()
    var sentence = String()
    var totalWordList = [VariationWord]()
    var minimumSentenceLength = Int()
    var maximumSentenceLength = Int()
    var maxiumumSectionLength = Int()
    var dateCreated: NSDate?
    var dateEdited: NSDate?
    var record: CKRecord

    init(sentenceComponents: [String]) {
        self.sentenceComponents = sentenceComponents
        self.dateCreated = NSDate()
        self.dateEdited = dateCreated
        self.record = CKRecord(recordType: "Variation")
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        
        sentenceComponents = aDecoder.decodeObjectForKey("SentenceComponents") as [String]
        sentence = aDecoder.decodeObjectForKey("Sentence") as String
        record = aDecoder.decodeObjectForKey("Record") as CKRecord

        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(sentenceComponents, forKey: "SentenceComponents")
        aCoder.encodeObject(sentence, forKey: "Sentence")
        aCoder.encodeObject(record, forKey: "Record")

    }
}
