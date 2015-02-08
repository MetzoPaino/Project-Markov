//
//  MotifDetailTableViewController.swift
//  Project Markov
//
//  Created by William Robinson on 27/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit

protocol MotifDetailTableViewControllerDelegate: class {
    func motifDetailTableViewControllerDidCancel(controller: MotifDetailTableViewController)
    func motifDetailTableViewController(controller: MotifDetailTableViewController, didFinishAddingMotif motif: Motif)
    func motifDetailTableViewController(controller: MotifDetailTableViewController, didFinishEditingMotif motif: Motif)
}

class MotifDetailTableViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    weak var delegate: MotifDetailTableViewControllerDelegate?
    
    var motifToEdit: Motif?
    
    // MARK: - View Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let motif = motifToEdit {
            title = "Edit Motif"
            textView.text = motif.content
            doneBarButton.enabled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - IBActions
    
    @IBAction func cancel() {
        delegate?.motifDetailTableViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let motif = motifToEdit {
            motif.content = textView.text
            delegate?.motifDetailTableViewController(self, didFinishEditingMotif: motif)
            
        } else {
            let motif = Motif(content: textView.text)
            motif.checked = false
            delegate?.motifDetailTableViewController(self, didFinishAddingMotif: motif)
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    // MARK: - Text view delegate
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldText: NSString = textView.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: text)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
}
