//
//  SentenceLengthViewController.swift
//  Project Markov
//
//  Created by William Robinson on 18/01/2015.
//  Copyright (c) 2015 William Robinson. All rights reserved.
//

import UIKit

protocol SentenceLengthViewControllerDelegate: class {
    func sentenceViewController(controller: SentenceLengthViewController, didSelectMinLength minLength: Int)
    func sentenceViewController(controller: SentenceLengthViewController, didSelectMaxLength maxLength: Int)
}

class SentenceLengthViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    var isMaxLength = false
    var minimumSentenceLength = 0
    var maximumSentenceLength = 0
    
    // MARK: Outlets

    @IBOutlet var pickerView: UIPickerView!
    
    weak var delegate: SentenceLengthViewControllerDelegate?
    
    // MARK: View Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isMaxLength {
            self.title = "Maximum Sentence Length"
            self.pickerView.selectRow(minimumSentenceLength + 9, inComponent: 0, animated: false)
        } else {
            self.title = "Minimum Sentence Length"
            self.pickerView.selectRow(minimumSentenceLength - 1, inComponent: 0, animated: false)
        }
    }

    //MARK: - UIPickerView Delegate2

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }

    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(row + 1)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isMaxLength {
            delegate?.sentenceViewController(self, didSelectMaxLength: row + 1)
        } else {
            delegate?.sentenceViewController(self, didSelectMinLength: row + 1)
        }
    }
}
