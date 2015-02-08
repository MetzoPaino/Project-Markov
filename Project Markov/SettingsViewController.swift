//
//  SettingsViewController.swift
//  Project Markov
//
//  Created by William Robinson on 02/01/2015.
//  Copyright (c) 2015 William Robinson. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewController(controller: SettingsViewController, didChangeSentenceLength minLength: Int, maxLength: Int)
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SentenceLengthViewControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    var minimumSentenceLength = 0
    var maximumSentenceLength = 0
    
    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: View Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: IBActions

    @IBAction func back(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowMinSentenceLength" {
            let controller = segue.destinationViewController as SentenceLengthViewController
            controller.delegate = self
            controller.minimumSentenceLength = minimumSentenceLength
            controller.maximumSentenceLength = maximumSentenceLength

        } else if segue.identifier == "ShowMaxSentenceLength" {
            let controller = segue.destinationViewController as SentenceLengthViewController
            controller.delegate = self
            controller.minimumSentenceLength = minimumSentenceLength
            controller.maximumSentenceLength = maximumSentenceLength
            controller.isMaxLength = true
        }
    }
    
    // MARK: - TableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 2
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Defaults"
        } else if section == 1 {
            return "Info"
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MinMaxSentenceLength", forIndexPath: indexPath) as MinMaxSentenceLengthTableViewCell
            
            if indexPath.row == 0 {
                cell.minMaxSentenceLengthLabel.text = "Minimum sentence length:"
                cell.minMaxSentenceLengthValueLabel.text = "\(minimumSentenceLength)"
            } else if indexPath.row == 1 {
                cell.minMaxSentenceLengthLabel.text = "Maximum sentence length:"
                cell.minMaxSentenceLengthValueLabel.text = "\(maximumSentenceLength)"
            }
            
            return cell
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Info", forIndexPath: indexPath) as InfoTableViewCell
            
            if indexPath.row == 0 {
                cell.title.text = "Tutorial"
            } else if indexPath.row == 1 {
                cell.title.text = "iCloud sync"
                cell
            
            return cell
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MinMaxSentenceLength", forIndexPath: indexPath) as MinMaxSentenceLengthTableViewCell
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //http://stackoverflow.com/questions/13845508/is-it-possible-to-perform-a-popover-segue-manually-from-dynamic-uitableview-cel/14514837#14514837
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.performSegueWithIdentifier("ShowMinSentenceLength", sender: nil)
            } else if indexPath.row == 1 {
                self.performSegueWithIdentifier("ShowMaxSentenceLength", sender: nil)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.performSegueWithIdentifier("ShowTutorial", sender: nil)
            } else if indexPath.row == 1 {
                NSNotificationCenter.defaultCenter().postNotificationName("PerformFullCloudFetch", object: nil)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: PopoverPresentation Delegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // MARK: SentenceLength Delegate
    
    func sentenceViewController(controller: SentenceLengthViewController, didSelectMinLength minLength: Int) {
        minimumSentenceLength = minLength
        self.tableView.reloadData()
        delegate?.settingsViewController(self, didChangeSentenceLength: minimumSentenceLength, maxLength: maximumSentenceLength)

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sentenceViewController(controller: SentenceLengthViewController, didSelectMaxLength maxLength: Int) {
        maximumSentenceLength = maxLength
        self.tableView.reloadData()
        delegate?.settingsViewController(self, didChangeSentenceLength: minimumSentenceLength, maxLength: maximumSentenceLength)

        dismissViewControllerAnimated(true, completion: nil)
    }
}
