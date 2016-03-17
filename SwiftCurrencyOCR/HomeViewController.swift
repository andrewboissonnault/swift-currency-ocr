//
//  HomeViewController.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/17/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import UIKit
import VENCalculatorInputView_DecimalFix

class HomeViewController: UIViewController {
    @IBOutlet weak var leftCurrencyTextField: VENCalculatorInputTextField!
    @IBOutlet weak var rightCurrencyTextField: VENCalculatorInputTextField!
    @IBOutlet var toggleCurrencyButton: UIButton!
    
    
    @IBAction func rightCurrencyButtonPressed(sender: AnyObject) {
    }
    @IBAction func leftCurrencyButtonPressed(sender: AnyObject) {
    }
    
}
