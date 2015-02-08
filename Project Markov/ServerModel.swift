//
//  ServerModel.swift
//  Project Markov
//
//  Created by William Robinson on 30/01/2015.
//  Copyright (c) 2015 William Robinson. All rights reserved.
//

import Foundation
import CloudKit

class ServerModel {
    
    let container : CKContainer
    let publicDB : CKDatabase
    let privateDB : CKDatabase
    
    var subscriptionID = "subscription_id"
    var subscribed = false
    
    init() {
        
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    // MARK: - Subscribe To Cloud
    
    
    // MARK: - Batch Saving
    
    func saveThemesAndMotifsToCloud(themes: [Theme], completion: (error: NSError!) -> ()) {
        
        if themes.isEmpty {
            return
        }
        
        let saveRecordsOperation = CKModifyRecordsOperation()
        var recordsArray = [CKRecord]()
        
        for theme in themes {
            
            // You need to set the recordID, otherwise CloudKit will make one
            
            let themeRecord = CKRecord(recordType: "Theme", recordID: theme.record.recordID)
            themeRecord.setObject(theme.name, forKey: "Name")
            themeRecord.setObject(theme.dateCreated, forKey: "CreationDate")
            themeRecord.setObject(theme.dateEdited, forKey: "LastEditedDate")
            recordsArray.append(themeRecord)
        }
        
        saveRecordsOperation.recordsToSave = recordsArray
        saveRecordsOperation.savePolicy = .IfServerRecordUnchanged
        saveRecordsOperation.perRecordCompletionBlock = {
            record, error in
            if (error != nil) {
                println("Failed to save \(record.recordType): \(error.localizedDescription)")
                
            } else {
                println("Saved \(record.recordType)")
                
                // When a theme is saved, then save its motifs
                
                let saveMotifRecordsOperation = CKModifyRecordsOperation()
                var motifRecordsArray = [CKRecord]()
                
                for theme in themes {
                    
                    if theme.record.recordID == record.recordID {
                        
                        for motif in theme.motifs {
                            
                            let motifRecord = CKRecord(recordType: "Motif", recordID: motif.record.recordID)
                            motifRecord.setObject(motif.content, forKey: "Content")
                            motifRecord.setObject(motif.checked, forKey: "Checked")
                            motifRecord.setObject(motif.dateCreated, forKey: "CreationDate")
                            motifRecord.setObject(motif.dateEdited, forKey: "LastEditedDate")
                            
                            let themeReference = CKReference(record: theme.record, action: .DeleteSelf)
                            motifRecord.setObject(themeReference, forKey: "ThemeReference")
                            motifRecordsArray.append(motifRecord)
                        }
                    }
                }
                
                saveMotifRecordsOperation.recordsToSave = motifRecordsArray
                saveMotifRecordsOperation.savePolicy = .IfServerRecordUnchanged
                saveMotifRecordsOperation.perRecordCompletionBlock = {
                    record, error in
                    if (error != nil) {
                        println("Failed to save \(record.recordType): \(error.localizedDescription)")
                        
                    } else {
                         println("Saved \(record.recordType)")
                    }
                }
                
                saveMotifRecordsOperation.modifyRecordsCompletionBlock = {
                    
                    savedRecord, deletedRecordIds, error in
                    if (error != nil) {
                        println("Failed to save Themes & Motifs: \(error.localizedDescription)")
                    } else {
                        println("Saved Themes & Motifs")
                    }
                }
                self.privateDB.addOperation(saveMotifRecordsOperation)
            }
        }
        
        saveRecordsOperation.modifyRecordsCompletionBlock = {
            
            savedRecord, deletedRecordIds, error in
            if (error != nil) {
                println("Failed to save Themes & Motifs: \(error.localizedDescription)")
            } else {
                println("Saved Themes & Motifs")
            }
        }
        privateDB.addOperation(saveRecordsOperation)
        
        // if above works, thank person
        // http://stackoverflow.com/questions/24600308/swift-cloudkit-saverecord-error-saving-record
    }
    
    func saveVariationWordsToCloud(variationWords: [VariationWord], variation: Variation, completion: (error: NSError!) -> ()) {
        
        if variationWords.isEmpty {
            return
        }
        
        let saveRecordsOperation = CKModifyRecordsOperation()
        var recordsArray = [CKRecord]()
        
        for variationWord in variationWords {
            
            // You need to set the recordID, otherwise CloudKit will make one
            
            let variationWordRecord = CKRecord(recordType: "VariationWord")
            variationWordRecord.setObject(variationWord.checked, forKey: "Checked")
            variationWordRecord.setObject(variationWord.inUse, forKey: "InUse")
            variationWordRecord.setObject(variationWord.inUseIndex, forKey: "InUseIndex")
            variationWordRecord.setObject(variationWord.word, forKey: "Word")
            variationWordRecord.setObject(variationWord.totalWordIndex, forKey: "TotalWordIndex")
            
            let variationReference = CKReference(record: variation.record, action: .DeleteSelf)
            variationWordRecord.setObject(variationReference, forKey: "VariationReference")

            recordsArray.append(variationWordRecord)
        }
        
        saveRecordsOperation.recordsToSave = recordsArray
        saveRecordsOperation.savePolicy = .IfServerRecordUnchanged
        saveRecordsOperation.perRecordCompletionBlock = {
            record, error in
            if (error != nil) {
                println("Failed to save VariationWord: \(error.localizedDescription)")
                
            } else {
                let word = record.objectForKey("Word") as String
                println("Successfully saved VariationWord \(word)")
            }
        }
        
        saveRecordsOperation.modifyRecordsCompletionBlock = {
            
            savedRecord, deletedRecordIds, error in
            if (error != nil) {
                println("Failed to save VariationWords: \(error.localizedDescription)")
            } else {
                println("Successfully saved VariationWords")
            }
        }
        privateDB.addOperation(saveRecordsOperation)
        
        // if above works, thank person
        // http://stackoverflow.com/questions/24600308/swift-cloudkit-saverecord-error-saving-record
    }
    
    // MARK: - Individual Saving
    
    func saveThemeToCloud(theme: Theme!, completion: (error: NSError!) -> ()) {
        if theme == nil {
            return
        }
        let themeRecord = CKRecord(recordType: "Theme", recordID: theme.record.recordID)
        themeRecord.setObject(theme.name, forKey: "Name")
        themeRecord.setObject(theme.dateCreated, forKey: "CreationDate")
        themeRecord.setObject(theme.dateEdited, forKey: "LastEditedDate")
        
        privateDB.saveRecord(themeRecord) {
            record, error in
            dispatch_async(dispatch_get_main_queue()) {
                completion(error: error)
            }
        }
    }
    
    func saveMotifToCloud(motif: Motif!, theme: Theme!, completion: (error: NSError!) -> ()) {
        
        if motif == nil {
            return
        }
        let motifRecord = CKRecord(recordType: "Motif", recordID: motif.record.recordID)
        motifRecord.setObject(motif.content, forKey: "Content")
        motifRecord.setObject(motif.checked, forKey: "Checked")
        motifRecord.setObject(motif.dateCreated, forKey: "CreationDate")
        motifRecord.setObject(motif.dateEdited, forKey: "LastEditedDate")
        
        let themeReference = CKReference(record: theme.record, action: .DeleteSelf)
        motifRecord.setObject(themeReference, forKey: "ThemeReference")
        
        privateDB.saveRecord(motifRecord) {
            record, error in
            dispatch_async(dispatch_get_main_queue()) {
                completion(error: error)
            }
        }
    }
    
    func saveVariationToCloud(variation: Variation!, theme: Theme!, completion: (error: NSError!) -> ()) {
        
        if variation == nil {
            return
        }
        let variationRecord = CKRecord(recordType: "Variation", recordID: variation.record.recordID)
        variationRecord.setObject(variation.sentence, forKey: "Sentence")
        variationRecord.setObject(variation.sentenceComponents, forKey: "SentenceComponents")
        variationRecord.setObject(variation.sentenceComponentsIndexes, forKey: "SentenceComponentsIndexes")
        variationRecord.setObject(variation.minimumSentenceLength, forKey: "MinimumSentenceLength")
        variationRecord.setObject(variation.maximumSentenceLength, forKey: "MaximumSentenceLength")
        variationRecord.setObject(variation.maxiumumSectionLength, forKey: "MaximumSectionLength")

        variationRecord.setObject(variation.dateCreated, forKey: "CreationDate")
        variationRecord.setObject(variation.dateEdited, forKey: "LastEditedDate")
        
        let themeReference = CKReference(record: theme.record, action: .DeleteSelf)
        variationRecord.setObject(themeReference, forKey: "ThemeReference")
        
        privateDB.saveRecord(variationRecord) {
            record, error in
            
            if error != nil {
                
            } else {
                
                self.saveVariationWordsToCloud(variation.totalWordList, variation: variation) {
                    error in
                    if error != nil {
                        println("Failed to save VariationWords: \(error.localizedDescription)")
                    } else {
                        println("Successfully saved VariationWords")
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(error: error)
            }
        }
    }
    
    // MARK: - Batch Fetching
    
    func fetchThemesFromCloud(completion: (themes : NSArray!, error : NSError!) -> ()) {
        let query = CKQuery(recordType: "Theme", predicate: NSPredicate(value: true))
        privateDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            completion(themes: results, error: error)
        }
    }
    
    func fetchMotifsFromCloud(themeRecord: CKRecordID!, completion: (motifs : NSArray!, error : NSError!) -> ()) {
        
        let predicate = NSPredicate(format: "ThemeReference == %@", themeRecord)
//        let query = CKQuery(recordType: "Photo", predicate: predicate)
        
        
        
        let query = CKQuery(recordType: "Motif", predicate: predicate)
        privateDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            completion(motifs: results, error: error)
        }
    }
    
    func fetchVariationsFromCloud(completion: (motifs : NSArray!, error : NSError!) -> ()) {
        let query = CKQuery(recordType: "Variation", predicate: NSPredicate(value: true))
        privateDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            completion(motifs: results, error: error)
        }
    }
    
    // MARK: - Individual Updating
    
    func updateThemeInCloud(theme: Theme!, completion: (error: NSError!) -> ()) {
        
        if theme == nil {
            return
        }
        
        let updateRecordsOperation = CKModifyRecordsOperation()
        
        let themeRecord = CKRecord(recordType: "Theme", recordID: theme.record.recordID)
        themeRecord.setObject(theme.name, forKey: "Name")
        themeRecord.setObject(theme.dateCreated, forKey: "CreationDate")
        themeRecord.setObject(theme.dateEdited, forKey: "LastEditedDate")
        
        updateRecordsOperation.recordsToSave = [themeRecord]
        updateRecordsOperation.savePolicy = .ChangedKeys
        updateRecordsOperation.perRecordCompletionBlock = {
            record, error in
            if (error != nil) {
                println("Failed to update Theme 1: \(error.localizedDescription)")
                
            } else {
                println("Successfully updated Theme 1")
            }
        }
        
        updateRecordsOperation.modifyRecordsCompletionBlock = {
            
            savedRecord, deletedRecordIds, error in
            if (error != nil) {
                println("Failed to update Theme 2: \(error.localizedDescription)")
            } else {
                println("Successfully updated Theme 2")
            }
        }
        privateDB.addOperation(updateRecordsOperation)
    }
    
    func updateMotifInCloud(motif: Motif!, completion: (error: NSError!) -> ()) {
        
        if motif == nil {
            return
        }
        
        let updateRecordsOperation = CKModifyRecordsOperation()
        
        let motifRecord = CKRecord(recordType: "Theme", recordID: motif.record.recordID)
        motifRecord.setObject(motif.content, forKey: "Content")
        motifRecord.setObject(motif.checked, forKey: "Checked")
        motifRecord.setObject(motif.dateCreated, forKey: "CreationDate")
        motifRecord.setObject(motif.dateEdited, forKey: "LastEditedDate")
        
        updateRecordsOperation.recordsToSave = [motifRecord]
        updateRecordsOperation.savePolicy = .ChangedKeys
        updateRecordsOperation.perRecordCompletionBlock = {
            record, error in
            if (error != nil) {
                println("Failed to update Motif 1: \(error.localizedDescription)")
                
            } else {
                println("Successfully updated Motif 1")
            }
        }
        
        updateRecordsOperation.modifyRecordsCompletionBlock = {
            
            savedRecord, deletedRecordIds, error in
            if (error != nil) {
                println("Failed to update Motif 2: \(error.localizedDescription)")
            } else {
                println("Successfully updated Motif 2")
            }
        }
        privateDB.addOperation(updateRecordsOperation)
    }
    
    // MARK: - Individual Deleting
    
    func deleteThemeFromCloud(theme: Theme!, completion: (error: NSError!) -> ()) {
        
        if theme == nil {
            return
        }
        
        let deleteRecordsOperation = CKModifyRecordsOperation()
        
        let themeRecord = CKRecord(recordType: "Theme", recordID: theme.record.recordID)
        
        deleteRecordsOperation.recordIDsToDelete = [themeRecord.recordID]
        deleteRecordsOperation.savePolicy = .ChangedKeys
        deleteRecordsOperation.perRecordCompletionBlock = {
            record, error in
            if (error != nil) {
                println("Failed to delete Theme 1: \(error.localizedDescription)")
                
            } else {
                println("Successfully deleted Theme 1")
            }
        }
        
        deleteRecordsOperation.modifyRecordsCompletionBlock = {
            
            savedRecord, deletedRecordIds, error in
            if (error != nil) {
                println("Failed to delete Theme 2: \(error.localizedDescription)")
            } else {
                println("Successfully deleted Theme 2")
            }
        }
        privateDB.addOperation(deleteRecordsOperation)
    }
    
    func deleteMotifFromCloud(motif: Motif!, completion: (error: NSError!) -> ()) {
        
        if motif == nil {
            return
        }
        
        let deleteRecordsOperation = CKModifyRecordsOperation()
        
        let motifRecord = CKRecord(recordType: "Motif", recordID: motif.record.recordID)
        
        deleteRecordsOperation.recordIDsToDelete = [motifRecord.recordID]
        deleteRecordsOperation.savePolicy = .ChangedKeys
        deleteRecordsOperation.perRecordCompletionBlock = {
            record, error in
            if (error != nil) {
                println("Failed to delete Motif 1: \(error.localizedDescription)")
                
            } else {
                println("Successfully deleted Motif 1")
            }
        }
        
        deleteRecordsOperation.modifyRecordsCompletionBlock = {
            
            savedRecord, deletedRecordIds, error in
            if (error != nil) {
                println("Failed to delete Motif 2: \(error.localizedDescription)")
            } else {
                println("Successfully deleted Motif 2")
            }
        }
        privateDB.addOperation(deleteRecordsOperation)
    }
}