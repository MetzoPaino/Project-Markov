//
//  ThemeDetailTableViewController.swift
//  Project Markov
//
//  Created by William Robinson on 26/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit

protocol ThemeDetailTableViewControllerDelegate: class {
    func themeDetailTableViewControllerDidCancel(controller: ThemeDetailTableViewController)
    func themeDetailTableViewController(controller: ThemeDetailTableViewController, didFinishAddingTheme theme: Theme)
    func themeDetailTableViewController(controller: ThemeDetailTableViewController, didFinishEditingTheme theme: Theme)
}

class ThemeDetailTableViewController: UIViewController, UITextViewDelegate {

//    @IBOutlet weak var textField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ThemeDetailTableViewControllerDelegate?
    
    var themeToEdit: Theme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
        
        if let theme = themeToEdit {
            title = "Edit Theme"
            textView.text = theme.name
            doneBarButton.enabled = true
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // Mark - Navbar delegate actions
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        delegate?.themeDetailTableViewControllerDidCancel(self)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        if let theme = themeToEdit {
            theme.name = textView.text
            theme.dateEdited = NSDate()
            delegate?.themeDetailTableViewController(self, didFinishEditingTheme: theme)
        } else {
            let theme = Theme(name: textView.text)
            delegate?.themeDetailTableViewController(self, didFinishAddingTheme: theme)
        }
    }
    
    // MARK: - TextView delegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldText: NSString = textView.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: text)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
}
