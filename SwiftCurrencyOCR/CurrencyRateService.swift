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
        
        let rate = CurrencyRateService.calculateRate(self.persistenceService.baseCurrency.value, otherCurrency: self.persistenceService.otherCurrency.value, rates: self.ratesService.rates.value);
        self.rate = MutableProperty<Double>.init(rate);
        
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self.rate <~ self.rateSignal();
    }
    
    private static func calculateRate(baseCurrency : CurrencyProtocol, otherCurrency : CurrencyProtocol, rates : CurrencyRatesProtocol?) -> Double {
        return Double.abs(1.5);
    }
    
    private func rateSignal() -> Signal<Double, Result.NoError> {
        let combinedSignal = combineLatest(self.persistenceService.baseCurrency.signal, self.persistenceService.otherCurrency.signal, self.ratesService.rates.signal);
        let signal = combinedSignal.map { (baseCurrency : CurrencyProtocol, otherCurrency : CurrencyProtocol, rates : CurrencyRatesProtocol?) -> (Double) in
            return CurrencyRateService.calculateRate(baseCurrency, otherCurrency: otherCurrency, rates: rates);
        }
        return signal;
    }
}