//
//  ThemesViewController.swift
//  Project Markov
//
//  Created by William Robinson on 31/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit
import CloudKit

class ThemesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, ThemeDetailTableViewControllerDelegate, SettingsViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toolBar: UIToolbar!
    
    var motifsViewController: MotifsViewController? = nil
    var dataModel: DataModel!
    
    var notes : NSArray! = []
    
    // MARK: View Configuration

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.motifsViewController = controllers[controllers.count-1].topViewController as? MotifsViewController
        }
        
//        dataModel.fetchThemes {
//            (themes : NSArray!, error : NSError!) in
//            if error == nil {
//                
//                println("\(themes)")
//                
//                for themeRecord in themes {
//                
//                    println("Theme recordId = \(themeRecord.recordID)")
//                    
//                    
//                }
//                
//                
//                
////                println("Success")
//            } else {
////                println("Error fetching notes")
//            }
//        }
        
//        dataModel.fetchMotifs {
//            (motifs : NSArray!, error : NSError!) in
//            if error == nil {
//                
//                println("\(motifs)")
//                
//
//                
//                
//                println("Success")
//            } else {
//                println("Error fetching notes")
//            }
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func iCloudSync(sender: AnyObject) {
        
        self.tableView.reloadData()
        
//        dataModel.saveThemesToCloud(dataModel.themes) {
//            error in
//            if error != nil {
//                println("Failure")
//            } else {
//                println("Success")
//            }
//        }
        
        
        
        
//        let theme = Theme(name: "Test Theme")
//        dataModel.addTheme(theme) {
//            error in
//            if error != nil {
//                UIAlertView(title: "Error saving theme", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
//            } else {
//                println("Success")
//            }
//        }
        
//        dataModel.fetchMotifs { (notes : NSArray!, error : NSError!) in
//        if error == nil {
//            self.notes = notes
//            dispatch_async(dispatch_get_main_queue()) {
//                println("Something happened: \(error)")
//            }
//        } else {
//            println("Error: \(error)")
//        }
//        }
    }
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTheme" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as MotifsViewController
            controller.theme = sender as? Theme
            controller.minimumSentenceLength = dataModel.minimumSentenceLength
            controller.maximumSentenceLength = dataModel.maximumSentenceLength

        } else if segue.identifier == "AddTheme" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ThemeDetailTableViewController
            controller.delegate = self
            controller.themeToEdit = nil
            
        } else if segue.identifier == "EditTheme" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ThemeDetailTableViewController
            controller.delegate = self
            controller.themeToEdit = sender as? Theme
            
        } else if segue.identifier == "ShowSettings" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as SettingsViewController
            controller.delegate = self
            controller.minimumSentenceLength = dataModel.minimumSentenceLength
            controller.maximumSentenceLength = dataModel.maximumSentenceLength
        }
    }
    
    // MARK: TableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.themes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ThemeCell", forIndexPath: indexPath) as ThemeTableViewCell
            let theme = dataModel.themes[indexPath.row]
            cell.name.text = theme.name
            cell.name.textColor = theme.tint
                
            if theme.motifs.count == 0 {
                cell.motifs.hidden = true
                    
            } else if theme.motifs.count == 1 {
                cell.motifs.hidden = false
                cell.motifs.text = "\(theme.motifs.count) motif"
                    
            } else {
                cell.motifs.hidden = false
                cell.motifs.text = "\(theme.motifs.count) motifs"
                    
            }
                
            if theme.variations.count == 0 {
                cell.variations.hidden = true
                    
            } else if theme.variations.count == 1 {
                cell.variations.hidden = false
                cell.variations.text = "\(theme.variations.count) variation"
                    
            } else {
                cell.variations.hidden = false
                cell.variations.text = "\(theme.variations.count) variations"
                    
            }        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let theme = dataModel.themes[indexPath.row]
        performSegueWithIdentifier("ShowTheme", sender: theme)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    // Allows swipe actions
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.themes.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        if editingStyle == .Delete {
            
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit", handler:{action, indexpath in
            let theme = self.dataModel.themes[indexPath.row]
            self.performSegueWithIdentifier("EditTheme", sender: theme)
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0)
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            
            let dictionary: NSDictionary = ["Theme": self.dataModel.themes[indexPath.row]]
            NSNotificationCenter.defaultCenter().postNotificationName("DeleteThemeFromCloud", object: dictionary)
            
            self.dataModel.themes.removeAtIndex(indexPath.row)
            let indexPaths = [indexPath]
            
            tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        });
        
        return [deleteRowAction, moreRowAction];
    }
    
    // MARK: - ThemeDetailTableViewControllerDelegate
    
    func themeDetailTableViewControllerDidCancel(controller: ThemeDetailTableViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func themeDetailTableViewController(controller: ThemeDetailTableViewController, didFinishAddingTheme theme: Theme) {
        dataModel.themes.append(theme)
        dataModel.sortThemes()
        tableView.reloadData()
        
        let dictionary: NSDictionary = ["Theme": theme]
        NSNotificationCenter.defaultCenter().postNotificationName("SaveThemeToCloud", object: dictionary)

        
//        dataModel.addTheme(theme) {
//            error in
//            if error != nil {
//                UIAlertView(title: "Error saving theme", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
//            } else {
//                println("Success")
//            }
//        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func themeDetailTableViewController(controller: ThemeDetailTableViewController, didFinishEditingTheme theme: Theme) {
        
        dataModel.sortThemes()
        tableView.reloadData()
        
        let dictionary: NSDictionary = ["Theme": theme]
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateThemeInCloud", object: dictionary)
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    // MARK: - SettingsViewController Delegate
    
    func settingsViewController(controller: SettingsViewController, didChangeSentenceLength minLength: Int, maxLength: Int) {
        dataModel.minimumSentenceLength = minLength
        dataModel.maximumSentenceLength = maxLength
    }
}
