//
//  MotifsTableViewController.swift
//  Project Markov
//
//  Created by William Robinson on 27/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit

protocol MotifsTableViewControllerDelegate: class {
    func motifsTableViewController(controller: MotifsTableViewController, willEditMotif motif: Motif)
    func motifsTableViewController(controller: MotifsTableViewController, allowVariations amountOfCheckedMotifs: Int)
}

class MotifsTableViewController: MotifsViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    weak var delegate: MotifsTableViewControllerDelegate?

    var filteredTheme = [Theme]()
    
    // MARK: - View Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
    }

    // MARK: - TableView Delegate

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theme.motifs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MotifCell", forIndexPath: indexPath) as MotifTableViewCell
        let motif = theme.motifs[indexPath.row]
        cell.contentLabel.text = motif.content
        configureCheckmarkForCell(cell, withMotif: motif)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let cell = tableView.cellForRowAtIndexPath(indexPath) as MotifTableViewCell
        let motif = theme.motifs[indexPath.row]
        motif.toggleChecked()
        configureCheckmarkForCell(cell, withMotif: motif)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        theme.motifs.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        if editingStyle == .Delete {

        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        // Handle edit through delegate to super
        var moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit", handler:{ action, indexpath in
            let motif = self.theme.motifs[indexPath.row]
            self.delegate?.motifsTableViewController(self, willEditMotif: motif)
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        // Handle delete directly
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{ action, indexpath in
            self.theme.motifs.removeAtIndex(indexPath.row)
            let indexPaths = [indexPath]
                tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            });
    
            return [deleteRowAction, moreRowAction];
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withMotif motif: Motif) {
    
        let image = cell.viewWithTag(1000) as UIImageView
    
        if motif.checked {
            image.backgroundColor = UIColor.orangeColor()
        } else {
            image.backgroundColor = UIColor.clearColor()
        }
            
        var amountOfCheckedMotifs = 0
        for motif in theme.motifs {
            if motif.checked {
                amountOfCheckedMotifs++
            }
        }
        self.delegate?.motifsTableViewController(self, allowVariations: amountOfCheckedMotifs)
    }
}
