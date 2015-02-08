//
//  MarkovCollectionViewCell.swift
//  Project Markov
//
//  Created by William Robinson on 30/12/2014.
//  Copyright (c) 2014 William Robinson. All rights reserved.
//

import UIKit

class MarkovCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var paperBackground: UIView!
    var checked = false
    var inUse = false
    var totalWordListIndex: Int?
    
    func toggleChecked() {
        checked = !checked
        
        if checked == true {
            self.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0)
        } else {
            self.backgroundColor = UIColor.clearColor()
        }
    }
    
    func toggleInUse() {
        inUse = !inUse
        
        if inUse == true {
            self.wordLabel.textColor = UIColor.blackColor()

        } else {
            self.wordLabel.textColor = UIColor.lightGrayColor()
        }
    }
    
    var moving: Bool = false {
        didSet {
            // If moving 0, otherwise 1
            let alpha: CGFloat = moving ? 0.0 : 1.0
            wordLabel.alpha = alpha
            paperBackground.alpha = alpha
        }
    }
    
    var snapshot: UIView {
        get {
            let snapshot = snapshotViewAfterScreenUpdates(true)
            let layer = snapshot.layer
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
            layer.shadowRadius = 5.0
            layer.shadowOpacity = 0.4
            return snapshot
        }
    }
    
//    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes! {
//        var newLayoutAttributes = layoutAttributes
//        
////        contentView.backgroundColor = UIColor.redColor()
////        wordLabel.sizeToFit()
////        wordLabel.backgroundColor = UIColor.orangeColor()
////        newLayoutAttributes.Frame = new RectangleF (new PointF (0, 0), attr.Size);
////        label.Frame = new RectangleF (new PointF (0, 0), attr.Size);
//        
//        //
//        
//        var bValue = CGFloat(Float(arc4random_uniform(UInt32(101) - 50)) / 1000)
//        var cValue = CGFloat(Float(arc4random_uniform(UInt32(101) - 50)) / 1000)
//        
//        
//
//       var shearTransform = CGAffineTransformMake(1, bValue, cValue, 1, 0, 0)
//        paperBackground.transform = shearTransform
//
//        return newLayoutAttributes
//    }

}
