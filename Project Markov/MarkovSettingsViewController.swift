//
//  MarkovSettingsViewController.swift
//  Project Markov
//
//  Created by William Robinson on 08/01/2015.
//  Copyright (c) 2015 William Robinson. All rights reserved.
//

import UIKit

protocol MarkovSettingsViewControllerDelegate: class {
    func markovSettingsViewController(controller: MarkovSettingsViewController, didEditTotalWordList editedWord: VariationWord, atIndex index: Int)
}

class MarkovSettingsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: MarkovSettingsViewControllerDelegate?

    var totalWordList = [VariationWord]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - CollectionView delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalWordList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as MarkovCollectionViewCell
        let word = totalWordList[indexPath.row]
        cell.wordLabel.text = word.word
        
        if word.inUse {
            cell.toggleInUse()
            cell.wordLabel.textColor = UIColor.blackColor()
        } else {
            cell.wordLabel.textColor = UIColor.lightGrayColor()
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MarkovCollectionViewCell {
            
            let word = totalWordList[indexPath.row]
            
            cell.toggleInUse()
            
            if cell.inUse {
                word.inUse = true
            } else {
                word.inUse = false
            }
            delegate?.markovSettingsViewController(self, didEditTotalWordList: word, atIndex: indexPath.row)
        }
    }
    
    // MARK: CollectionViewLayout Delegate

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }
}
