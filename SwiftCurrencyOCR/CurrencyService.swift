//
//  CurrencyService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/19/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Parse

protocol CurrencyServiceProtocol {
    static func defaultBaseCurrency() -> Currency
    static func defaultOtherCurrency() -> Currency
  //  var codeSignal : Signal<String> { get set }
  //  func currencySignal() -> Signal<Currency>
}

public class CurrencyService: NSObject, CurrencyServiceProtocol {
//    public var codeSignal : Signal
//    
//    init(codeSignal : Signal) {
//        self.codeSignal = codeSignal;
//    }
//    
//    func currencySignal() -> Signal {
//        return self.codeSignal;
//    }
    
    public static func defaultBaseCurrency() -> Currency {
        let currency = Currency()
        currency.name = "United States Dollar"
        currency.code = "USD";
        currency.flagImage = UIImage.init(named: "us")!;
        return currency;
    }
    
    public static func defaultOtherCurrency() -> Currency {
        let currency = Currency()
        currency.name = "Euro Member Countries"
        currency.code = "EUR";
        currency.flagImage = UIImage.init(named: "eu")!;
        return currency;
    }
    
    public static func fetchCurrencyWithCodeInBackground(code : NSString, block: PFIdResultBlock) {
        let query = PFCurrency.query();
        query?.fromLocalDatastore();
        query?.whereKey(kCodeKey, equalTo:code);
        query?.getFirstObjectInBackgroundWithBlock(block);
    }
    
}