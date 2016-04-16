//
//  HomeViewController.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/17/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import UIKit
import VENCalculatorInputView_DecimalFix
import ReactiveCocoa
import enum Result.NoError

public class HomeViewController: UIViewController {
    @IBOutlet weak var leftCurrencyTextField: VENCalculatorInputTextField!
    @IBOutlet weak var rightCurrencyTextField: VENCalculatorInputTextField!
    @IBOutlet weak var leftCurrencyView: CurrencyView!
    @IBOutlet weak var rightCurrencyView: CurrencyView!
    @IBOutlet var toggleCurrencyButton: UIButton!
    
    private var viewModel: HomeViewModel?;
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        viewModel = HomeViewModel();
        self.setupBindings()
    }
    
    @IBAction func rightCurrencyButtonPressed(sender: AnyObject) {
    }
    @IBAction func leftCurrencyButtonPressed(sender: AnyObject) {
    }
    
    private func setupBindings() {
        self.toggleSignal().subscribeNext { _ in
            self.viewModel?.toggleArrow();
        }
        
        self.leftCurrencyTextField.rac_text <~ (self.viewModel?.leftCurrencyText)!;
        self.rightCurrencyTextField.rac_text <~ (self.viewModel?.rightCurrencyText)!;
        
        (self.viewModel?.leftCurrencyText)!.signal.observeNext { (text : String) -> () in
            //
        }
        
        (self.viewModel?.rightCurrencyText)!.signal.observeNext { (text : String) -> () in
            //
        }
        
        self.viewModel!.arrowImage ~> self.setArrowImage
        self.viewModel!.isArrowPointingLeft ~> self.setFirstResponder
        
        self.viewModel!.expression <~ self.baseTextSignal();
    }
    
    private func baseTextSignal() -> Signal<String, Result.NoError> {
        let leftSignal = self.leftCurrencyTextField.rac_text.signal;
        let rightSignal = self.rightCurrencyTextField.rac_text.signal;
        let isArrowPointingLeftSignal = (self.viewModel?.isArrowPointingLeft.signal)!;
        isArrowPointingLeftSignal.observeNext { _ -> () in
            //
        }
        let signals = combineLatest(leftSignal, rightSignal, isArrowPointingLeftSignal);
        signals.observeNext { (_, _, _) -> () in
            //
        }
        let signal = signals.map(reduceLeft);
        signal.observeNext { (text : String) -> () in
            //
        }
        return signal;
    }
    
    private func baseTextFieldSignal() -> Signal<UITextField, Result.NoError> {
        return (self.viewModel?.isArrowPointingLeft.signal.map(self.baseTextField))!;
    }
    
    private func baseTextField(isArrowPointingLeft : Bool) -> UITextField {
        return reduceLeft(self.leftCurrencyTextField, right: self.rightCurrencyTextField, isArrowPointingLeft: isArrowPointingLeft);
    }
    
    private func setFirstResponder(isArrowPointingLeft : Bool) {
        self.baseTextField(isArrowPointingLeft).becomeFirstResponder();
    }
    
    private func setArrowImage(image : UIImage) {
        self.toggleCurrencyButton.setImage(image, forState: UIControlState.Normal);
    }
    
    private func toggleSignal() -> RACSignal {
        let pressSignal = self.toggleCurrencyButton.rac_signalForControlEvents(UIControlEvents.TouchDown);
        return pressSignal;
    }
}
