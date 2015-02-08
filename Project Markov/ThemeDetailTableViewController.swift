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

class ThemeDetailTableViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ThemeDetailTableViewControllerDelegate?
    
    var themeToEdit: Theme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.textRectForBounds(CGRectMake(2000, 2000, 2000, 2000))
        self.textField.editingRectForBounds(CGRectMake(500, 2000, 2000, 2000))
        self.textField.placeholderRectForBounds(CGRectMake(500, 2000, 2000, 2000))
        self.textField.borderRectForBounds(CGRectMake(500, 2000, 2000, 2000))
        
        if let theme = themeToEdit {
            title = "Edit Theme"
            textField.text = theme.name
            doneBarButton.enabled = true
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // Mark - Navbar delegate actions
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        delegate?.themeDetailTableViewControllerDidCancel(self)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        if let theme = themeToEdit {
            theme.name = textField.text
            theme.dateEdited = NSDate()
            delegate?.themeDetailTableViewController(self, didFinishEditingTheme: theme)
        } else {
            let theme = Theme(name: textField.text)
            delegate?.themeDetailTableViewController(self, didFinishAddingTheme: theme)
        }
    }
    
    // MARK: - Text field delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.done(self.doneBarButton)
        return true
    }
}
