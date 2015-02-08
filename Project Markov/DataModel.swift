//
//  DataModel.swift
//  Project Markov
//
//  Created by William Robinson on 26/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import Foundation
import CloudKit

class DataModel {
    var themes = [Theme]()
    var minimumSentenceLength = 2
    var maximumSentenceLength = 3
    
    let container : CKContainer
    let publicDB : CKDatabase
    let privateDB : CKDatabase
    
    let saveThemeToCloudString = "SaveThemeToCloud"
    let updateThemeInCloudString = "UpdateThemeInCloud"
    let updateMotifInCloudString = "UpdateMotifInCloud"

    let deleteThemeFromCloudString = "DeleteThemeFromCloud"
    let saveMotifToCloudString = "SaveMotifToCloud"
    let saveThemesAndMotifsToCloudString = "SaveThemesAndMotifsToCloud"
    let saveVariationToCloudString = "SaveVariationToCloud"
    
    let performFullCloudFetch = "PerformFullCloudFetch"

    init() {
        
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: saveThemeToCloudString, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: saveMotifToCloudString, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: saveThemesAndMotifsToCloudString, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: updateThemeInCloudString, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: updateMotifInCloudString, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: deleteThemeFromCloudString, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name: saveVariationToCloudString, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedFetchNotification:", name: performFullCloudFetch, object: nil)

        
        loadData()
        registerDefaults()
        handleFirstTime()
        



//                self.fetchThemes {
//                    (themes : NSArray!, error : NSError!) in
//                    if error == nil {
//        
//                        println("\(themes)")
//        
//                        for themeRecord in themes {
//                            
//                            // Pulls down everything, so find a different solution
//        
//                            println("Theme recordId = \(themeRecord.recordID)")
//        
//        
//                        }
//        
//        
//        
//        //                println("Success")
//                    } else {
//                        println("Error fetching notes")
//                    }
//                }

        
//        for theme in themes {
//            
//            self.addTheme(theme) {
//                error in
//                if error != nil {
//                    println("Failure")
//                } else {
//                    println("Success")
//                }
//            }
//        }
    }
    
    func handleFirstTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        
        if firstTime {
            
            let theme1 = Theme(name: "Famous Last Words", recordID: "Famous Last Words")
            
            let motif1 = Motif(content: "What the devil do you mean to sing to me, priest? You are out of tune.")
            let motif2 = Motif(content: "I’m losing it.")
            let motif3 = Motif(content: "At fifty, everyone has the face he deserves.")
            let motif4 = Motif(content: "Nothing, only ‘love one another'.")
            let motif5 = Motif(content: "I love you very much, my dear Beaver.")
            let motif6 = Motif(content: "A party! Let’s have a party.")
            let motif7 = Motif(content: "I don’t want the doctor’s death. I want to have my own freedom.")
            let motif8 = Motif(content: "Tomorrow, at sunrise, I shall no longer be here.")
            let motif9 = Motif(content: "A certain butterfly is already on the wing.")
            let motif10 = Motif(content: "Pardonnez-moi, monsieur.")
            let motif11 = Motif(content: "Swing low, sweet chariot.")
            let motif12 = Motif(content: "I don’t know what I may seem to the world. But as to myself I seem to have been only like a boy playing on the seashore and diverting myself now and then in finding a smoother pebble or a prettier shell than the ordinary, whilst the great ocean of truth lay all undiscovered before me.")
            let motif13 = Motif(content: "Good. A woman who can fart is not dead.")
            let motif14 = Motif(content: "I’ll show you that it won’t shoot.")
            let motif15 = Motif(content: "This dying is boring.")
            let motif16 = Motif(content: "A dying man can do nothing easy.")
            let motif17 = Motif(content: "Bring me a bullet-proof vest.")
            let motif18 = Motif(content: "Capital punishment means those without the capital get the punishment.")
            let motif19 = Motif(content: "You are wonderful.")
            let motif20 = Motif(content: "Goodnight my kitten.")
        
            theme1.motifs.append(motif1)
            theme1.motifs.append(motif2)
            theme1.motifs.append(motif3)
            theme1.motifs.append(motif4)
            theme1.motifs.append(motif5)
            theme1.motifs.append(motif6)
            theme1.motifs.append(motif7)
            theme1.motifs.append(motif8)
            theme1.motifs.append(motif9)
            theme1.motifs.append(motif10)
            theme1.motifs.append(motif11)
            theme1.motifs.append(motif12)
            theme1.motifs.append(motif13)
            theme1.motifs.append(motif14)
            theme1.motifs.append(motif15)
            theme1.motifs.append(motif16)
            theme1.motifs.append(motif17)
            theme1.motifs.append(motif18)
            theme1.motifs.append(motif19)
            theme1.motifs.append(motif20)
        
            themes.append(theme1)
        
            let theme2 = Theme(name: "Movie Quotes", recordID: "Movie Quotes")
            let motif21 = Motif(content: "I coulda had class. I coulda been a contender. I coulda been somebody, instead of a bum, which is what I am, let's face it.")
            let motif22 = Motif(content: "We all go a little mad sometimes.")
            let motif23 = Motif(content: "Open the pod bay doors, please.")
            let motif24 = Motif(content: "So I got that goin' for me, which is nice.")
            let motif25 = Motif(content: "I fart in your general direction. Your mother was a hamster and your father smelt of elderberries.")
            let motif26 = Motif(content: "Excuse me while I whip this out.")
            let motif27 = Motif(content: "No, Mr. Bond. I expect you to die!")
            let motif28 = Motif(content: "And I guess that was your accomplice in the wood chipper.")
            let motif29 = Motif(content: "The greatest trick the devil ever pulled was convincing the world he didn't exist.")
            let motif30 = Motif(content: "Nobody's looking for a puppeteer in today's wintry economic climate.")
            let motif31 = Motif(content: "When the legend becomes fact, print the legend.")
            let motif32 = Motif(content: "When I first saw you, I thought you were handsome. Then, of course, you spoke.")
            let motif33 = Motif(content: "I'm not bad. I'm just drawn that way.")
            let motif34 = Motif(content: "Joey, do you like movies about gladiators?")
            let motif35 = Motif(content: "These go to 11.")
            let motif36 = Motif(content: "Game over, man! Game over!")
            let motif37 = Motif(content: "Nobody puts Baby in a corner.")
            let motif38 = Motif(content: "You can't handle the truth!")
            let motif39 = Motif(content: "I'll have what she's having.")
            let motif40 = Motif(content: "I'm all out of bubble gum.")
            
            theme2.motifs.append(motif21)
            theme2.motifs.append(motif22)
            theme2.motifs.append(motif23)
            theme2.motifs.append(motif24)
            theme2.motifs.append(motif25)
            theme2.motifs.append(motif26)
            theme2.motifs.append(motif27)
            theme2.motifs.append(motif28)
            theme2.motifs.append(motif29)
            theme2.motifs.append(motif30)
            theme2.motifs.append(motif31)
            theme2.motifs.append(motif32)
            theme2.motifs.append(motif33)
            theme2.motifs.append(motif34)
            theme2.motifs.append(motif35)
            theme2.motifs.append(motif36)
            theme2.motifs.append(motif37)
            theme2.motifs.append(motif38)
            theme2.motifs.append(motif39)
            theme2.motifs.append(motif40)
            
            themes.append(theme2)

            let theme3 = Theme(name: "Favourite Lyrics", recordID: "Favourite Lyrics")
            
            let motif41 = Motif(content: "It's better to burn out, than to fade away.")
            let motif42 = Motif(content: "How many ears must one man have before he can hear people cry? Yes, and how many deaths will it take 'til he knows that too many people have died?")
            let motif43 = Motif(content: "All you need is love, love. Love is all you need.")
            let motif44 = Motif(content: "An honest man's pillow is his peace of mind.")
            let motif45 = Motif(content: "Don't ask me what I think of you, I might not give the answer that you want me to.")
            let motif46 = Motif(content: "All lies and jest, still, a man hears what he wants to hear and disregards the rest.")
            let motif47 = Motif(content: "And in the end, the love you take is equal to the love you make.")
            let motif48 = Motif(content: "Even the genius asks questions.")
            let motif49 = Motif(content: "The pain of war cannot exceed the woe of aftermath.")
            let motif50 = Motif(content: "All my lies are always wishes.")
            let motif51 = Motif(content: "I'd rather be a hammer than a nail.")
            let motif52 = Motif(content: "We're just two lost souls swimming in a fish bowl.")
            let motif53 = Motif(content: "Freedom's just another word for nothing left to lose. Nothing ain't nothing, but it's free.")
            let motif54 = Motif(content: "Thinking is the best way to travel.")
            let motif55 = Motif(content: "The words of the prophets are written on the subway walls.")
            let motif56 = Motif(content: "Just because you feel it doesn't mean it's there.")
            let motif57 = Motif(content: "I'm in love with the world through the eyes of a girl, who's still around the morning after. We broke up a month ago, and I grew up - but didn't know I'd be around the morning after.")
            let motif58 = Motif(content: "Freedom, well, that's just some people talking. Your prison is walking through this world all alone.")
            let motif59 = Motif(content: "Get your head out of the mud, baby. Put flowers in the mud, baby.")
            let motif60 = Motif(content: "The swift don't win the race. It goes to the worthy, who can divide the word of truth.")
            
            theme3.motifs.append(motif41)
            theme3.motifs.append(motif42)
            theme3.motifs.append(motif43)
            theme3.motifs.append(motif44)
            theme3.motifs.append(motif45)
            theme3.motifs.append(motif46)
            theme3.motifs.append(motif47)
            theme3.motifs.append(motif48)
            theme3.motifs.append(motif49)
            theme3.motifs.append(motif50)
            theme3.motifs.append(motif51)
            theme3.motifs.append(motif52)
            theme3.motifs.append(motif53)
            theme3.motifs.append(motif54)
            theme3.motifs.append(motif55)
            theme3.motifs.append(motif56)
            theme3.motifs.append(motif57)
            theme3.motifs.append(motif58)
            theme3.motifs.append(motif59)
            theme3.motifs.append(motif60)
            
            themes.append(theme3)
            
            userDefaults.setBool(false, forKey: "FirstTime")
            userDefaults.setInteger(5, forKey: "MinimumSentenceLength")
            userDefaults.setInteger(10, forKey: "MaximumSentenceLength")
            
            
            let dictionary: NSDictionary = ["Themes": themes]
            NSNotificationCenter.defaultCenter().postNotificationName(saveThemesAndMotifsToCloudString, object: dictionary)

        }
    }
    
    func sortThemes() {
        themes.sort({ theme1, theme2 in return
            theme1.name.localizedStandardCompare(theme2.name) == NSComparisonResult.OrderedAscending})
    }
    
    // MARK: - NSUserDefaults
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent("ProjectMarkov.plist")
    }
    
    func registerDefaults() {
        let dictionary = ["FirstTime": true,
        "MinimumSentenceLength": 5,
        "MaximumSentenceLength": 20]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func saveData() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(themes, forKey: "Themes")
        archiver.encodeObject(minimumSentenceLength, forKey: "MinimumSentenceLength")
        archiver.encodeObject(maximumSentenceLength, forKey: "MaximumSentenceLength")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadData() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                themes = unarchiver.decodeObjectForKey("Themes") as [Theme]
                minimumSentenceLength = unarchiver.decodeObjectForKey("MinimumSentenceLength") as Int
                maximumSentenceLength = unarchiver.decodeObjectForKey("MaximumSentenceLength") as Int
                unarchiver.finishDecoding()
            }
        }
    }

    // MARK: - Notifications
    
    @objc func receivedNotification(notification: NSNotification) {
        
        let fetchManager = ServerModel()
        let userInfo = notification.object as NSDictionary

        switch (notification.name) {
            
            // Batch Saving
            
            case saveThemesAndMotifsToCloudString:
                fetchManager.saveThemesAndMotifsToCloud(userInfo.objectForKey("Themes") as [Theme]) {
                    error in
                    if error != nil {
                        println("Failed to save Theme: \(error.localizedDescription)")
                    } else {
                        println("Successfully saved Theme")
                    }
                }
            break;
            
            // Individual Saves
            
            case saveThemeToCloudString:
                fetchManager.saveThemeToCloud(userInfo.objectForKey("Theme") as Theme) {
                    error in
                    if error != nil {
                        println("Failed to save Theme: \(error.localizedDescription)")
                    } else {
                        println("Successfully saved Theme")
                    }
                }
                break;
            
            case saveMotifToCloudString:
                fetchManager.saveMotifToCloud(userInfo.objectForKey("Motif") as Motif, theme: userInfo.objectForKey("Theme") as Theme) {
                    error in
                    if error != nil {
                        println("Failed to save Motif: \(error.localizedDescription)")
                    } else {
                        println("Successfully saved Motif")
                    }
                }
                break;
            
            case saveVariationToCloudString:
                fetchManager.saveVariationToCloud(userInfo.objectForKey("Variation") as Variation, theme: userInfo.objectForKey("Theme") as Theme) {
                    error in
                    if error != nil {
                        println("Failed to save Variation: \(error.localizedDescription)")
                    } else {
                        println("Successfully saved Variation")
                        
                        
                    }
            }
            break;
            
            // Updates
            
            case updateThemeInCloudString:
                fetchManager.updateThemeInCloud(userInfo.objectForKey("Theme") as Theme) {
                    error in
                    if error != nil {
                        println("Failed to update Theme: \(error.localizedDescription)")
                    } else {
                        println("Successfully update Theme")
                    }
            }
            break;
            
            case updateMotifInCloudString:
                fetchManager.updateMotifInCloud(userInfo.objectForKey("Motif") as Motif) {
                    error in
                    if error != nil {
                        println("Failed to update Motif: \(error.localizedDescription)")
                    } else {
                        println("Successfully update Motif")
                    }
                }
            break;
            
            // Deleting
            
            case deleteThemeFromCloudString:
                fetchManager.deleteThemeFromCloud(userInfo.objectForKey("Theme") as Theme) {
                    error in
                    if error != nil {
                        println("Failed to delete Theme: \(error.localizedDescription)")
                    } else {
                        println("Successfully deleted Theme")
                    }
                }
            break;
            
            default:
                break;
        }
    }
    
    @objc func receivedFetchNotification(notification: NSNotification) {
        
        let fetchManager = ServerModel()
        
        switch (notification.name) {
            
            case performFullCloudFetch:
                
                var cloudThemes = NSArray()
                var cloudMotifs = NSArray()
                var cloudVariations = NSArray()

                fetchManager.fetchThemesFromCloud {
                    (themes : NSArray!, error : NSError!) in
                    if error == nil {
                        
                        println("Successfully fetched Themes")
                        
                        cloudThemes = themes
                        
                        self.organiseThemesFromCloud(themes)
                    

                        
                        
                        

                        
                        fetchManager.fetchVariationsFromCloud {
                            (variations : NSArray!, error : NSError!) in
                            if error == nil {
                                
                                println("Successfully fetched Variations")

                                cloudVariations = variations
                            } else {
                                println("Failure to fetch Variations: \(error.localizedDescription)")
                            }
                        }
                        
                    } else {
                        println("Failure to fetch Themes: \(error.localizedDescription)")
                    }
                }
                
            break;
            
            default:
            break;
        }
    }
    
    func organiseThemesFromCloud(cloudThemes: NSArray) {
        
        if self.themes.isEmpty {
            
            println("Themes is empty")
            
            for themeRecord in cloudThemes {
                
                let cloudTheme = Theme(name: themeRecord.objectForKey("Name") as String)
                cloudTheme.dateCreated = themeRecord.objectForKey("CreationDate") as? NSDate
                cloudTheme.dateEdited = themeRecord.objectForKey("LastEditedDate") as? NSDate
                cloudTheme.record = themeRecord as CKRecord
                self.themes.append(cloudTheme)

                
            }
            
        } else {
        
            for themeRecord in cloudThemes {
                
                var themeAlreadyExists = false
                
                for theme in self.themes {
                    
                    if themeRecord.recordID == theme.record.recordID {
                        
                        themeAlreadyExists = true
                        println("Theme already exists")
                        break
                    }
                }
                
                if themeAlreadyExists == false {
                    
                    println("Add Theme to Themes")
                    
                    let cloudTheme = Theme(name: themeRecord.objectForKey("Name") as String)
                    cloudTheme.dateCreated = themeRecord.objectForKey("CreationDate") as? NSDate
                    cloudTheme.dateEdited = themeRecord.objectForKey("LastEditedDate") as? NSDate
                    cloudTheme.record = themeRecord as CKRecord
                    self.themes.append(cloudTheme)
                    
                }
            }
        }
        
        for (index, theme) in enumerate(themes) {
            let fetchManager = ServerModel()
            fetchManager.fetchMotifsFromCloud(theme.record.recordID) {
                (motifs : NSArray!, error : NSError!) in
                if error == nil {
                    
                    println("Successfully fetched Motifs")
                    self.organiseMotifsFromCloud(motifs, theme: theme, themeIndex: index)
                } else {
                    println("Failure to fetch Motifs: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func organiseMotifsFromCloud(cloudMotifs: NSArray, theme: Theme, themeIndex: Int) {
        
        // Need to create a dictionary so i can get the motifs tied to specific keys
        
        if theme.motifs.isEmpty {
            
            for motifRecord in cloudMotifs {
                
                println("You've got no motifs")
                
                let cloudMotif = Motif(content: motifRecord.objectForKey("Content") as String)
//                cloudMotif.checked = motifRecord.objectForKey("Checked") as Bool
                cloudMotif.dateCreated = motifRecord.objectForKey("CreationDate") as? NSDate
                cloudMotif.dateEdited = motifRecord.objectForKey("LastEditedDate") as? NSDate
                cloudMotif.record = motifRecord as CKRecord
                theme.motifs.append(cloudMotif)
            }
            
            themes[themeIndex] = theme
            
        } else {
            
            for motifRecord in cloudMotifs {
                
                var motifAlreadyExists = false
                
                for motif in theme.motifs {
                    
                    //let motifRecordReference = motifRecord.objectForKey("ThemeReference") as CKReference
                    let motifRecordReference = motifRecord.recordID
                    let motifReference = motif.record.recordID

                    if motifRecord.recordID == motif.record.recordID {
                        
                        motifAlreadyExists = true
                        println("These motifs, they're the same")
                        break
                    }
                }
                
                if motifAlreadyExists == false {
                    
                    println("Add this motif")
                    
                    let cloudMotif = Motif(content: motifRecord.objectForKey("Content") as String)
                    //cloudMotif.checked = motifRecord.objectForKey("Checked") as Bool
                    cloudMotif.dateCreated = motifRecord.objectForKey("CreationDate") as? NSDate
                    cloudMotif.dateEdited = motifRecord.objectForKey("LastEditedDate") as? NSDate
                    cloudMotif.record = motifRecord as CKRecord
                    theme.motifs.append(cloudMotif)
                    
                }
            }
        }
        
        
        
        
        
        
        
        
//        var cloudMotifRecordIDs = [CKRecordID]()
//        
//        for motifRecord in cloudMotifs {
//            
//            if contains(cloudMotifRecordIDs, motifRecord.recordID) {
//                println("This record id is already there")
//            } else {
//                println("This record id is new")
//                cloudMotifRecordIDs.append(motifRecord.recordID)
//            }
//        }
//        
//        for theme in themes {
//            
////            let query = CKQuery(recordType: <#String!#>, predicate: <#NSPredicate!#>)
//            
//            for motifRecord in cloudMotifs {
//                
//                let cloudMotifReference = motifRecord.objectForKey("ThemeReference") as CKReference
//                println("1 \(cloudMotifReference)")
////                println("2 \(cloudMotifReference.recordID)")
//
//                
//                
////                println("Reference is \(cloudMotifReference) and theme reference is \(theme.record.recordID)")
//                
//                if cloudMotifReference == theme.record.recordID {
//                    
//                    
//                    println("It's still the same")
//                    
//                    let cloudMotif = Motif(content: motifRecord.objectForKey("Content") as String)
//                    cloudMotif.dateCreated = motifRecord.objectForKey("CreationDate") as? NSDate
//                    cloudMotif.dateEdited = motifRecord.objectForKey("LastEditedDate") as? NSDate
//                    cloudMotif.record = motifRecord as CKRecord
//                    
//                    
//                    
//                    
//                    
////                    self.themes.append(cloudMotif)
//                    
//                }
//            }
//        }
        
//            cloudMotifDictionary[motifRecord.recordID]?.append(motifRecord as CKRecord)
            
            
//            for key in cloudMotifDictionary.keys {
//                
//                if motifRecord.recordID == key {
//                    
//                    keyAlreadyExists = true
//                    
//                }
//            }
//            
//            if keyAlreadyExists {
//                
//                
//                let themeReference = CKReference(record: motifRecord.record, action: .DeleteSelf)
//                
//                
//                
//            } else {
//                
//            }
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        for theme in themes {
//            
//            if theme.motifs.isEmpty {
//                
//                println("Motifs are empty")
//                
//                for motifRecord in cloudMotifs {
//                    
//                    let cloudMotif = Motif(content: motifRecord.objectForKey("Content") as String)
//                    cloudMotif.checked = motifRecord.objectForKey("Checked") as Bool
//                    cloudMotif.dateCreated = motifRecord.objectForKey("CreationDate") as? NSDate
//                    cloudMotif.dateEdited = motifRecord.objectForKey("LastEditedDate") as? NSDate
//                    cloudMotif.record = motifRecord as CKRecord
//                    theme.motifs.append(cloudMotif)
//
//                }
//            } else {
//                
//                for motifRecord in cloudMotifs {
//                    
//                    var motifAlreadyExists = false
//                    
//                    for motif in theme.motifs {
//                        
//                        if motifRecord.recordID == motif.record.recordID {
//                            
//                            motifAlreadyExists = true
//                            println("Motif already exists")
//                            break
//                        }
//                    }
//                    
//                    if motifAlreadyExists == false {
//                        
//                        println("Add Motif to Theme")
//                        
//                        let cloudMotif = Motif(content: motifRecord.objectForKey("Content") as String)
//                        cloudMotif.checked = motifRecord.objectForKey("Checked") as Bool
//                        cloudMotif.dateCreated = motifRecord.objectForKey("CreationDate") as? NSDate
//                        cloudMotif.dateEdited = motifRecord.objectForKey("LastEditedDate") as? NSDate
//                        cloudMotif.record = motifRecord as CKRecord
//                        theme.motifs.append(cloudMotif)
//                    }
//                    
//                }
//            }
//        }
}