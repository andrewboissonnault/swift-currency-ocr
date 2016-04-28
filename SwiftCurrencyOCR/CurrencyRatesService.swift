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
    var rates: AnyProperty<CurrencyRatesProtocol?> { get }
}

public class BaseCurrencyRatesService : CurrencyRatesServiceProtocol {
    var rates: AnyProperty<CurrencyRatesProtocol?> {
        return AnyProperty(_rates);
    }
    internal var _rates = MutableProperty<CurrencyRatesProtocol?>.init(CurrencyRates());
}

public class CurrencyRatesService: BaseCurrencyRatesService {
    
    private var parseCloudService: ParseCloudServiceProtocol
    
    convenience override init() {
        self.init(parseCloudService: ParseCloudService());
    }
    
    init(parseCloudService : ParseCloudServiceProtocol) {
        self.parseCloudService = parseCloudService;
        super.init();
        self._rates.value = self.parseCloudService.rates.value;
        self.setupBindings();
    }
    
    private func setupBindings() {
        self._rates <~ self.parseCloudService.rates.signal;
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