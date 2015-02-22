//
//  MarkovViewController.swift
//  Project Markov
//
//  Created by William Robinson on 28/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit

extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return (string as NSString).boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: self],
            context: nil).size
    }
}

protocol MarkovViewControllerDelegate: class {
    func markovViewControllerDidCancel(controller: MarkovViewController)
    func markovViewController(controller: MarkovViewController, didFinishSavingVariation variation: Variation)
}

class MarkovViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate, MarkovSettingsViewControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var createVariationButton: UIBarButtonItem!
    
    weak var delegate: MarkovViewControllerDelegate?
    
    var panGesture = UIPanGestureRecognizer()
    
    var selectedMotifs = [Motif]()
    var variation = Variation(sentenceComponents: [String()])
    var variationWords = [VariationWord]()
    
    
    
    
    
    var movingCellImage = UIImageView()
    var movingCell = MarkovCollectionViewCell()
    var movingCellOriginalIndexPath = NSIndexPath()
    
    
    
    
    
    
    
    
    let variationGenerator = VariationGenerator()
    var minSentenceLength = 10
    var maxSentenceLength = 50
    var maxSectionLength = 8
    
    
    
    // Holds reference to snapshot of current manipulated cell
    private var snapshot: UIView?
    private var sourceIndexPath: NSIndexPath?
    
    
    // MARK: - View Configuration

    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
//        collectionView.addGestureRecognizer(panGesture)
        
        variation = variationGenerator.createVariation(selectedMotifs, minSentenceLength: minSentenceLength, maxSentenceLength: maxSentenceLength, maxSectionLength: maxSectionLength)
        collectionView.reloadData()
        
        
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    // UIGestureRecognizer
    
    func handlePan(sender: UIPanGestureRecognizer) {
        let locationPoint = sender.locationInView(collectionView)
        if sender.state == UIGestureRecognizerState.Began {
            
            if let indexPath = collectionView.indexPathForItemAtPoint(locationPoint)? {
                println("IndexPath: \(indexPath)")
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                    UIGraphicsBeginImageContext(cell.bounds.size)
                    cell.layer.renderInContext(UIGraphicsGetCurrentContext())
                    let cellImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    movingCellImage = UIImageView(image: cellImage)
                    movingCellImage.center = locationPoint
                    movingCellImage.transform = CGAffineTransformMakeScale(1.1, 1.1)
                    collectionView.addSubview(movingCellImage)
                    cell.alpha = 0
                    movingCellOriginalIndexPath = indexPath

                }
            }
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            movingCellImage.center = locationPoint
            
            if let indexPath = collectionView.indexPathForItemAtPoint(locationPoint)? {
                
                let cell = collectionView.cellForItemAtIndexPath(movingCellOriginalIndexPath)
                collectionView.moveItemAtIndexPath(movingCellOriginalIndexPath, toIndexPath: indexPath)
                cell?.alpha = 0
                
            }
            
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            //
            // CURRENTLY WONT MOVE INDEXES OF SELECTEDWORDS
            //
            
            if let indexPath = collectionView.indexPathForItemAtPoint(locationPoint)? {
                
                let cell = collectionView.cellForItemAtIndexPath(movingCellOriginalIndexPath)
                collectionView.moveItemAtIndexPath(movingCellOriginalIndexPath, toIndexPath: indexPath)
                cell?.alpha = 1
                
                println("Original set of words \(variation.sentenceComponents)\n")
                
                let movedWord = variation.sentenceComponents[movingCellOriginalIndexPath.row]
                println("We moved \(movedWord)\n")
                
                variation.sentenceComponents.removeAtIndex(movingCellOriginalIndexPath.row)
                variation.sentenceComponents.insert(movedWord, atIndex: indexPath.row)
                
                println("New set of words \(variation.sentenceComponents)\n")

                println("Original sentence \(variation.sentence)\n")

                variation.sentence = variationGenerator.createSentence(variation.sentenceComponents)
                
                println("New sentence \(variation.sentence)\n")
                
            }
            
            movingCellImage.removeFromSuperview()
        }
    }

    // MARK: IBActions
    
    @IBAction func cancel() {
        delegate?.markovViewControllerDidCancel(self)
    }
    
    @IBAction func save() {
        
        var checkedWordsStringArray = [String]()
        var checkedWordsIndexArray = [Int]()

        for (index, variationWord) in enumerate(variation.totalWordList) {
            if variationWord.checked {
                checkedWordsStringArray.append(variationWord.word)
                checkedWordsIndexArray.append(index)
            }
        }
        
        if checkedWordsStringArray.isEmpty {
            
            delegate?.markovViewController(self, didFinishSavingVariation: variation)
            
        } else {
            
            var checkedWordsString = String()
            
            for word in checkedWordsStringArray {
                checkedWordsString = (checkedWordsString + word)
                checkedWordsString = (checkedWordsString + " ")
            }
            
            variation.sentence = checkedWordsString
            variation.sentenceComponents = checkedWordsStringArray
            variation.sentenceComponentsIndexes = checkedWordsIndexArray
            delegate?.markovViewController(self, didFinishSavingVariation: variation)
            
        }
    }

    @IBAction func createVariation(sender: AnyObject) {
        
        variation = variationGenerator.createVariation(selectedMotifs, minSentenceLength: minSentenceLength, maxSentenceLength: maxSentenceLength, maxSectionLength: maxSectionLength)
        collectionView.reloadData()

    }
    
    @IBAction func share(sender: AnyObject) {

        let objectsToShare = [variation.sentence]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    private func updateSnapshotView(center: CGPoint, transform: CGAffineTransform, alpha: CGFloat) {
        
        if let snapshot = snapshot {
            snapshot.center = center
            snapshot.transform = transform
            snapshot.alpha = alpha
        }
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        
        let location = recognizer.locationInView(self.collectionView)
        let indexPath = self.collectionView.indexPathForItemAtPoint(location)
        
        switch recognizer.state {
        case .Began:
            if let indexPath = indexPath {
                sourceIndexPath = indexPath
                let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as MarkovCollectionViewCell
                snapshot = cell.snapshot
                // Ensure snapshot is in sync with cell
                updateSnapshotView(cell.center, transform: CGAffineTransformIdentity, alpha: 0.0)
                self.collectionView.addSubview(snapshot!)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.updateSnapshotView(cell.center, transform: CGAffineTransformMakeScale(1.05, 1.05), alpha: 0.95)
                    cell.moving = true
                    
                })
            }
        case .Changed:
            self.snapshot!.center = location
            if let indexPath = indexPath {
                
                println("Original set of words \(variation.sentenceComponents)\n")
                
                let movedWord = variation.sentenceComponents[sourceIndexPath!.row]
                println("We moved \(movedWord)\n")
                
                variation.sentenceComponents.removeAtIndex(sourceIndexPath!.row)
                variation.sentenceComponents.insert(movedWord, atIndex: indexPath.row)
                
                println("New set of words \(variation.sentenceComponents)\n")
                
                println("Original sentence \(variation.sentence)\n")
                
                variation.sentence = variationGenerator.createSentence(variation.sentenceComponents)
                
                println("New sentence \(variation.sentence)\n")
                collectionView!.moveItemAtIndexPath(sourceIndexPath!, toIndexPath: indexPath)
                sourceIndexPath = indexPath
                
            }
        default:
            let cell = self.collectionView.cellForItemAtIndexPath(sourceIndexPath!) as MarkovCollectionViewCell
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.updateSnapshotView(cell.center, transform: CGAffineTransformIdentity, alpha: 1.0)
                cell.moving = false
                }, completion: { (finished: Bool) -> Void in
                    self.snapshot!.removeFromSuperview()
                    self.snapshot = nil
            })

        }
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PresentPopover" {
            
            let navigationController = segue.destinationViewController as UINavigationController
            navigationController.popoverPresentationController?.delegate = self
            
            let controller = navigationController.topViewController as MarkovSettingsViewController
            controller.popoverPresentationController?.delegate = self
            controller.totalWordList = variation.totalWordList
            controller.delegate = self
        }
    }
    
    // MARK: CollectionView delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variation.sentenceComponents.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MarkovCollectionViewCell
        let word = variation.sentenceComponents[indexPath.row]
        cell.wordLabel.text = word
        cell.totalWordListIndex = variation.sentenceComponentsIndexes[indexPath.row]
        
        

        
        for variationWords in variation.totalWordList {
            if variationWords.inUse {
                
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MarkovCollectionViewCell {
            cell.toggleChecked()
            
            if cell.checked {
                
                println("In the total list this index is = \(cell.totalWordListIndex)")
                
                variation.totalWordList[cell.totalWordListIndex!].checked = true
            } else {
                variation.totalWordList[cell.totalWordListIndex!].checked = false
            }
        }
    }
    
     // MARK: CollectionViewLayout Delegate
  
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let word = variation.sentenceComponents[indexPath.item]
        var txtsize = (word as NSString).sizeWithAttributes([NSFontAttributeName : UIFont.systemFontOfSize(24)])

        txtsize.width += 40
        txtsize.height += 40
        
        return txtsize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }
    
    // MARK: PopoverPresentation Delegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // MARK: MarkovSettings Delegate
    
    func markovSettingsViewController(controller: MarkovSettingsViewController, didEditTotalWordList editedWord: VariationWord, atIndex index: Int) {
        
        variation.totalWordList[index] = editedWord
        
        if editedWord.inUse {
            variation.sentence = variation.sentence + editedWord.word
            variation.sentenceComponents.append(editedWord.word)
            variation.sentenceComponentsIndexes.append(index)
        } else {
            
            for componentIndex in variation.sentenceComponentsIndexes {
                
                if componentIndex == index {
//                    variation.sentenceComponents.removeAtIndex(editedWord.inUseIndex!)
//                    variation.sentenceComponentsIndexes.removeAtIndex(editedWord.inUseIndex!)
//                    variation.sentence = variationGenerator.createSentence(variation.sentenceComponents)
                }
            }
        }
        collectionView.reloadData()
    }
}
