//
//  Theme.swift
//  Project Markov
//
//  Created by William Robinson on 26/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit
import CloudKit

class Theme: NSObject, NSCoding {
    var name = ""
    var motifs = [Motif]()
    var variations = [Variation]()
    var dateCreated: NSDate?
    var dateEdited: NSDate?
    var tint = UIColor()
    
    var record: CKRecord

    init(name: String) {
        self.name = name
        self.dateCreated = NSDate()
        self.dateEdited = dateCreated
        self.record = CKRecord(recordType: "Theme")
        self.tint = UIColor.blackColor()
        super.init()
    }
    
    init(name: String, recordID: String) {
        self.name = name
        self.dateCreated = NSDate()
        self.dateEdited = dateCreated
        self.tint = UIColor.blackColor()

        self.record = CKRecord(recordType: "Theme", recordID: CKRecordID(recordName: recordID))
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as String
        motifs = aDecoder.decodeObjectForKey("Motifs") as [Motif]
        variations = aDecoder.decodeObjectForKey("Variations") as [Variation]
        dateCreated = aDecoder.decodeObjectForKey("DateCreated") as? NSDate
        dateEdited = aDecoder.decodeObjectForKey("DateEdited") as? NSDate
        record = aDecoder.decodeObjectForKey("Record") as CKRecord
        tint = aDecoder.decodeObjectForKey("Tint") as UIColor
        
        
        
        
        
//        let recordName = aDecoder.decodeObjectForKey("recordName") as String
//        let recordID = CKRecordID(recordName: recordName)
//        self.record = CKRecord(recordType: _stdlib_getDemangledTypeName(Theme), recordID: recordID)
//        self.record.setObject(name, forKey: "Name")
//        self.record.setObject(dateCreated, forKey: "")
//        self.record.setObject(dateEdited, forKey: "")
        
        

        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(motifs, forKey: "Motifs")
        aCoder.encodeObject(variations, forKey: "Variations")
        aCoder.encodeObject(dateCreated, forKey: "DateCreated")
        aCoder.encodeObject(dateEdited, forKey: "DateEdited")
        aCoder.encodeObject(record, forKey: "Record")
        aCoder.encodeObject(tint, forKey: "Tint")
    }
}
