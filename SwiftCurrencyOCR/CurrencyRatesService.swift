//
//  CurrencyRatesService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/31/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Parse
import enum Result.NoError

protocol CurrencyRatesServiceProtocol {
    var rates: MutableProperty<CurrencyRatesProtocol?> { get }
}

public class CurrencyRatesService: CurrencyRatesServiceProtocol {
    public private(set) var rates: MutableProperty<CurrencyRatesProtocol?>
    
    init() {
        self.rates = MutableProperty<CurrencyRatesProtocol?>.init(nil);
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self.rates <~ self.ratesSignalProducer();
    }
    
    public func ratesSignalProducer() -> SignalProducer<CurrencyRatesProtocol?, NoError> {
        return SignalProducer {
            sink, disposable in
            let query = PFCurrencyRates.query();
            query?.fromLocalDatastore();
            query?.getFirstObjectInBackgroundWithBlock({ (object : PFObject?, error : NSError?) -> Void in
                if error != nil {
                    sink.sendNext(nil);
                }
                else if let currencyRates = object as? PFCurrencyRates {
                    sink.sendNext(currencyRates);
                }
            })
        }
    }

    
}