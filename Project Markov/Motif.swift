//
//  Motif.swift
//  Project Markov
//
//  Created by William Robinson on 26/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit
import CloudKit

class Motif: NSObject, NSCoding {
    var content = ""
    var checked = false
    var dateCreated: NSDate?
    var dateEdited: NSDate?
    
    var record: CKRecord
    
    init(content: String) {
        self.content = content
        self.dateCreated = NSDate()
        self.dateEdited = dateCreated
        self.record = CKRecord(recordType: "Motif")
        super.init()
    }
    
    init(content: String, themeRecord: CKRecord) {
        self.content = content
        self.dateCreated = NSDate()
        self.dateEdited = dateCreated
        self.record = CKRecord(recordType: "Motif")
        super.init()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    required init(coder aDecoder: NSCoder) {
        
        content = aDecoder.decodeObjectForKey("Content") as String
        checked = aDecoder.decodeBoolForKey("Checked")
        dateCreated = aDecoder.decodeObjectForKey("MotifDateCreated") as? NSDate
        dateEdited = aDecoder.decodeObjectForKey("MotifDateEdited") as? NSDate
        record = aDecoder.decodeObjectForKey("Record") as CKRecord

        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(content, forKey: "Content")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dateCreated, forKey: "MotifDateCreated")
        aCoder.encodeObject(dateEdited, forKey: "MotifDateEdited")
        aCoder.encodeObject(record, forKey: "Record")

    }
}
