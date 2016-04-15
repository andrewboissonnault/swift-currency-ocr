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
    var rates: AnyProperty<CurrencyRatesProtocol> { get }
}

public class BaseCurrencyRatesService : CurrencyRatesServiceProtocol {
    var rates: AnyProperty<CurrencyRatesProtocol> {
        return AnyProperty(_rates);
    }
    internal private(set) var _rates = MutableProperty<CurrencyRatesProtocol>.init(CurrencyRates());
}

public class CurrencyRatesService: BaseCurrencyRatesService {
    
    override init() {
        super.init();
        self._rates <~ CurrencyRatesService.ratesSignalProducer();
    }
    
    public static func ratesSignalProducer() -> SignalProducer<CurrencyRatesProtocol, NoError> {
        return SignalProducer {
            sink, disposable in
            let query = PFCurrencyRates.query();
            query?.fromLocalDatastore();
            query?.getFirstObjectInBackgroundWithBlock({ (object : PFObject?, error : NSError?) -> Void in
                if let currencyRates = object as? PFCurrencyRates {
                    sink.sendNext(currencyRates);
                }
            })
        }
    }

    
}