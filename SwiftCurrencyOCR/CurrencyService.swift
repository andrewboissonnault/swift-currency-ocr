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
import enum Result.NoError

protocol CurrencyServiceProtocol {
    static func defaultBaseCurrency() -> CurrencyProtocol
    static func defaultOtherCurrency() -> CurrencyProtocol
    func currencySignalProducer(code : String?) -> SignalProducer<CurrencyProtocol, NoError>
}

public class CurrencyService: NSObject, CurrencyServiceProtocol {
    
    public static func defaultBaseCurrency() -> CurrencyProtocol {
        let currency = Currency()
        currency.nameProperty.swap("United States Dollar");
        currency.codeProperty.swap("USD");
        return currency;
    }
    
    public static func defaultOtherCurrency() -> CurrencyProtocol {
        let currency = Currency()
        currency.nameProperty.swap("Euro Member Countries");
        currency.codeProperty.swap("EUR");
        return currency;
    }
    
    public func currencySignalProducer(code : String?) -> SignalProducer<CurrencyProtocol, NoError> {
        return SignalProducer {
            sink, disposable in
            if(code != nil)
            {
                let query = PFCurrency.query();
                query?.fromLocalDatastore();
                query?.whereKey(kCodeKey, equalTo:code!);
                query?.getFirstObjectInBackgroundWithBlock({ (object : PFObject?, error : NSError?) -> Void in
                    if error != nil {
                        //sink.sendFailed(error!);
                        // sink.sendNext(nil);
                    }
                    else if let currency = object as? PFCurrency {
                        sink.sendNext(currency);
                    }
                })
            }
        }
    }
}
