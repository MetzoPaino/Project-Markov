//
//  TutorialPageViewController.swift
//  Project Markov
//
//  Created by William Robinson on 02/01/2015.
//  Copyright (c) 2015 William Robinson. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet var doneSkipButton: UIBarButtonItem!
    
    var index = 0
    var identifiers: NSArray = ["TutorialPage1", "TutorialPage2", "TutorialPage3"]
    
    // MARK: - View Configuration
    
    override func viewDidLoad() {
        
        self.dataSource = self
        self.delegate = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        let startingViewController = self.viewControllerAtIndex(self.index)
        let viewControllers: NSArray = [startingViewController]
        self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    
    }
    
    // MARK: - IBActions
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - PageViewController Delegate
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let identifier = viewController.restorationIdentifier {
            index = identifiers.indexOfObject(identifier)
            
            if index == 0 {
                return nil
            }
            index--
            return self.viewControllerAtIndex(index)

        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let identifier = viewController.restorationIdentifier {
            index = self.identifiers.indexOfObject(identifier)
            //increment the index to get the viewController after the current index
            index++
            if index == self.identifiers.count {
                return nil
            }

            return self.viewControllerAtIndex(self.index)
        } else {
            return nil
        }
    }

    
    func viewControllerAtIndex(index: Int) -> UIViewController! {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //first view controller = firstViewControllers navigation controller
        if index == 0 {
            
            let vc = storyboard.instantiateViewControllerWithIdentifier(identifiers[index] as String) as UIViewController
            return vc as UIViewController
            
        } else if index == 1 {
            
            let vc = storyboard.instantiateViewControllerWithIdentifier(identifiers[index] as String) as UIViewController
            return vc as UIViewController
            
        } else if index == 2 {
            
            let vc = storyboard.instantiateViewControllerWithIdentifier(identifiers[index] as String) as UIViewController
            return vc as UIViewController
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return self.identifiers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return 0
    }

}
