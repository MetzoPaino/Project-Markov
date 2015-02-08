//
//  DetailViewController.swift
//  Project Markov
//
//  Created by William Robinson on 26/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit
import CloudKit

class MotifsViewController: UIViewController, MotifsTableViewControllerDelegate, MotifDetailTableViewControllerDelegate, MarkovViewControllerDelegate {

//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var segmentButton: UISegmentedControl!
    @IBOutlet var containerView: UIView!
    @IBOutlet var createVariationButton: UIBarButtonItem!
    
    var theme: Theme!
    var tabController: UITabBarController!
    var minimumSentenceLength = 0
    var maximumSentenceLength = 0
    
    // MARK: - View Configuration
    
    override func viewDidLoad() {
        title = theme.name
        
//        let themeReference = CKReference(record: theme.record, action: .DeleteSelf)
//        println("Theme recordId = \(theme.record.recordID)")
//        println("Theme ref = \(themeReference)")
        super.viewDidLoad()


    }
    
    // MARK: - IBActions

    @IBAction func switchView(sender: UISegmentedControl) {
        
        if tabController.selectedIndex == 0 {
            tabController.selectedIndex = 1
        } else {
            tabController.selectedIndex = 0
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddMotif" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as MotifDetailTableViewController
            controller.delegate = self
            controller.motifToEdit = nil
        } else if segue.identifier == "EditMotif" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as MotifDetailTableViewController
            controller.delegate = self
            controller.motifToEdit = sender as? Motif
            
        } else if segue.identifier == "TabBar" {
            tabController = segue.destinationViewController as UITabBarController
            tabController.tabBar.hidden = true
            
            if let views = tabController.viewControllers {
                for view in views {
                    if view is MotifsTableViewController {
                        let controller = view as MotifsTableViewController
                        controller.theme = theme as Theme
                        controller.delegate = self
                    
                    } else if view is VariationsTableViewController {
                        let controller = view as VariationsTableViewController
                        controller.theme = theme as Theme
                    }
                }
            }
        } else if segue.identifier == "Markov" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as MarkovViewController
            controller.delegate = self
            controller.minSentenceLength = minimumSentenceLength
            controller.maxSentenceLength = maximumSentenceLength

            var checkedMotifs = [Motif]()
            
            for motif in theme.motifs {
                if motif.checked {
                    checkedMotifs.append(motif)
                    controller.selectedMotifs.append(motif)
                }
            }
        }
    }
    
    // MARK: - MotifsTableViewControllerDelegate
    
    func motifsTableViewController(controller: MotifsTableViewController, willEditMotif motif: Motif) {
        self.performSegueWithIdentifier("EditMotif", sender: motif)
    }
    
    // MARK: - MotifDetailTableViewControllerDelegate
    
    func motifDetailTableViewControllerDidCancel(controller: MotifDetailTableViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func motifDetailTableViewController(controller: MotifDetailTableViewController, didFinishAddingMotif motif: Motif) {
        
        let newRowIndex = theme.motifs.count
        theme.motifs.append(motif)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        if let index = find(theme.motifs, motif) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            if let views = tabController.viewControllers {
                for view in views {
                    if view is MotifsTableViewController {
                        let controller = view as MotifsTableViewController
                        if let cell = controller.tableView.cellForRowAtIndexPath(indexPath) as? MotifTableViewCell {
                            controller.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                        }
                    }
                }
            }
        }
        let dictionary: NSDictionary = ["Motif": motif, "Theme": theme]
        NSNotificationCenter.defaultCenter().postNotificationName("SaveMotifToCloud", object: dictionary)

        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func motifDetailTableViewController(controller: MotifDetailTableViewController, didFinishEditingMotif motif: Motif) {
        if let index = find(theme.motifs, motif) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            if let views = tabController.viewControllers {
                for view in views {
                    if view is MotifsTableViewController {
                        let controller = view as MotifsTableViewController
                        if let cell = controller.tableView.cellForRowAtIndexPath(indexPath) as? MotifTableViewCell {
                            cell.contentLabel.text = motif.content
                            controller.tableView.reloadData()
                        }
                    }
                }
            }
        }
        let dictionary: NSDictionary = ["Motif": motif]
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateMotifInCloud", object: dictionary)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func motifsTableViewController(controller: MotifsTableViewController, allowVariations amountOfCheckedMotifs: Int) {
        if amountOfCheckedMotifs > 0 {
            createVariationButton.enabled = true
        } else {
            createVariationButton.enabled = false
        }
    }
    
    // MARK: - MarkovViewControllerDelegate
    
    func markovViewControllerDidCancel(controller: MarkovViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func markovViewController(controller: MarkovViewController, didFinishSavingVariation variation: Variation) {
        
        let newRowIndex = theme.variations.count
        theme.variations.append(variation)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        if let index = find(theme.variations, variation) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            if let views = tabController.viewControllers {
                for view in views {
                    if view is VariationsTableViewController {
                        let controller = view as VariationsTableViewController
                    }
                }
            }
        }
        let dictionary: NSDictionary = ["Variation": variation, "Theme": theme]
        NSNotificationCenter.defaultCenter().postNotificationName("SaveVariationToCloud", object: dictionary)

        dismissViewControllerAnimated(true, completion: nil)
    }
}

