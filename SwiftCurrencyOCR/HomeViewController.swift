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
    
    public var expression: MutableProperty<String> = MutableProperty<String>.init("0");
    
    private var viewModel: HomeViewModel?;
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        viewModel = HomeViewModel();
    }
    
    @IBAction func rightCurrencyButtonPressed(sender: AnyObject) {
    }
    @IBAction func leftCurrencyButtonPressed(sender: AnyObject) {
    }
    
    private func setupBindings() {
        self.conversionButtonImageSignal().observeNext(self.setArrowImage);
    }
    
    private func conversionButtonImageSignal() -> Signal<UIImage, Result.NoError> {
        return self.viewModel!.isArrowPointingLeft.signal.map(HomeViewController.arrowImage);
    }
    
    private static func arrowImage(isArrowPointingLeft : Bool) -> UIImage {
        if(isArrowPointingLeft)
        {
            return UIImage.init(named : "convertIconLeft")!;
        }
        else
        {
            return UIImage.init(named : "convertIconRight")!;
        }
    }
    
    private func setArrowImage(image : UIImage) {
        self.toggleCurrencyButton.setImage(image, forState: UIControlState.Normal);
    }
    
//    private func toggleSignal() -> Signal<AnyObject?, Result.NoError> {
//        let pressSignal = self.toggleCurrencyButton.rac_signalForControlEvents(UIControlEvents.TouchDown);
//        return pressSignal;
//    }
}
