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

class MotifDetailTableViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    @IBOutlet var doneBarButton: UIBarButtonItem!

    weak var delegate: MotifDetailTableViewControllerDelegate?
    
    var motifToEdit: Motif?
    
    // MARK: - View Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissKeyboardBarButton = UIBarButtonItem(title: "Keyboard", style: .Plain , target: self, action: "dismissKeyboard")
        self.navigationItem.setRightBarButtonItems([doneBarButton, dismissKeyboardBarButton], animated: true)
        
        textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);


        if let motif = motifToEdit {
            title = "Edit Motif"
            textView.text = motif.content
            doneBarButton.enabled = true
        } else {
            
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGrayColor()
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - IBActions
    
    @IBAction func cancel() {
        
        self.textView.resignFirstResponder()

        delegate?.motifDetailTableViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        
        self.textView.resignFirstResponder()

        if let motif = motifToEdit {
            motif.content = textView.text
            delegate?.motifDetailTableViewController(self, didFinishEditingMotif: motif)
            
        } else {
            let motif = Motif(content: textView.text)
            motif.checked = false
            delegate?.motifDetailTableViewController(self, didFinishAddingMotif: motif)
        }
    }
    
    @IBAction func dismissKeyboard() {
        
        if textView.isFirstResponder() {
            textView.resignFirstResponder()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    // MARK: - Text view delegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldText: NSString = textView.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: text)
        doneBarButton.enabled = (newText.length > 0)
        
        if let theme = motifToEdit {
            
        } else {
            
            // Combine the textView text and the replacement text to
            // create the updated text string
            let currentText:NSString = textView.text
            let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
            
            // If updated text view will be empty, add the placeholder
            // and set the cursor to the beginning of the text view
            if countElements(updatedText) == 0 {
                
                textView.text = "Every good idea needs a name"
                textView.textColor = UIColor.lightGrayColor()
                
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
                
                return false
            }
                
                // Else if the text view's placeholder is showing and the
                // length of the replacement string is greater than 0, clear
                // the text view and set its color to black to prepare for
                // the user's entry
            else if textView.textColor == UIColor.lightGrayColor() && countElements(text) > 0 {
                textView.text = nil
                textView.textColor = UIColor.blackColor()
            }
        }
        
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        
        if let theme = motifToEdit {
            
        } else {
            
            if self.view.window != nil {
                if textView.textColor == UIColor.lightGrayColor() {
                    textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
                }
            }
        }

    }

}
