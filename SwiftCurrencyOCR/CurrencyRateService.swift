//
//  CurrencyRateService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/9/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Parse
import enum Result.NoError

protocol CurrencyRateServiceProtocol {
    var rate: MutableProperty<Double> { get }
}

public class CurrencyRateService: CurrencyRateServiceProtocol {
    var persistenceService: PersistenceServiceProtocol
    var ratesService: CurrencyRatesServiceProtocol
    
    public private(set) var rate: MutableProperty<Double>
    
    convenience init() {
        self.init(persistenceService: PersistenceService(), ratesService: CurrencyRatesService());
    }
    
    init(persistenceService : PersistenceServiceProtocol, ratesService : CurrencyRatesServiceProtocol) {
        self.persistenceService = persistenceService;
        self.ratesService = ratesService;
        
     //   let rate = CurrencyRateService.calculateRate(self.persistenceService.baseCurrency.value, otherCurrency: self.persistenceService.otherCurrency.value, rates: self.ratesService.rates.value);
        let rate = 1.0;
        self.rate = MutableProperty<Double>.init(rate);
        
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self.rate <~ self.rateSignal();
    }
    
    private static func calculateRate(baseCurrency : CurrencyProtocol, otherCurrency : CurrencyProtocol, rates : CurrencyRatesProtocol) -> Double {
        if(rates.referenceCurrencyCode == baseCurrency.code) {
            return rates.rate(otherCurrency.code!);
        }
        else if(rates.referenceCurrencyCode == otherCurrency.code) {
            return 1 / rates.rate(baseCurrency.code!);
        }
        else {
            let referenceAmount = rates.rate(otherCurrency.code!);
            return referenceAmount * ( 1 / rates.rate(baseCurrency.code!));
        }
    }
    
    private func rateSignal() -> Signal<Double, Result.NoError> {
        self.persistenceService.baseCurrency.signal.observeNext{ (next : CurrencyProtocol) -> () in
            NSLog("", "");
        }
        self.persistenceService.otherCurrency.signal.observeNext{ (next : CurrencyProtocol) -> () in
            NSLog("", "");
        }
        self.ratesService.rates.signal.observeNext{ (next : CurrencyRatesProtocol) -> () in
            NSLog("", "");
        }
        let combinedSignal = combineLatest(self.persistenceService.baseCurrency.signal, self.persistenceService.otherCurrency.signal, self.ratesService.rates.signal);
        combinedSignal.observeNext{ _,_,_ -> () in
            NSLog("", "");
        }
        let signal = combinedSignal.map { (baseCurrency : CurrencyProtocol, otherCurrency : CurrencyProtocol, rates : CurrencyRatesProtocol) -> (Double) in
            return CurrencyRateService.calculateRate(baseCurrency, otherCurrency: otherCurrency, rates: rates);
        }
        return signal;
    }
    
}