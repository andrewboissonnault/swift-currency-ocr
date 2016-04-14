//
//  CurrencyRateService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/9/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

protocol CurrencyRateServiceProtocol {
    var rate: MutableProperty<Double> { get }
}

public class CurrencyRateService: CurrencyRateServiceProtocol {
    private var persistenceService: PersistenceServiceProtocol
    private var ratesService: CurrencyRatesServiceProtocol
    
    public private(set) var rate: MutableProperty<Double>
    
    convenience init() {
        self.init(persistenceService: PersistenceService(), ratesService: CurrencyRatesService());
    }
    
    init(persistenceService : PersistenceServiceProtocol, ratesService : CurrencyRatesServiceProtocol) {
        self.persistenceService = persistenceService;
        self.ratesService = ratesService;

        self.rate = MutableProperty<Double>.init(1.0);
        
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self.rate <~ self.rateSignal();
    }
    
    private func rateSignal() -> Signal<Double, Result.NoError> {
        let combinedSignal = combineLatest(self.persistenceService.baseCurrency.signal, self.persistenceService.otherCurrency.signal, self.ratesService.rates.signal);
        let signal = combinedSignal.map { (baseCurrency : CurrencyProtocol, otherCurrency : CurrencyProtocol, rates : CurrencyRatesProtocol) -> (Double) in
            return CurrencyRateService.calculateRate(baseCurrency, otherCurrency: otherCurrency, rates: rates);
        }
        return signal;
    }
    
    private static func calculateRate(baseCurrency : CurrencyProtocol, otherCurrency : CurrencyProtocol, rates : CurrencyRatesProtocol) -> Double {
        if(rates.referenceCurrencyCode == baseCurrency.codeProperty.value) {
            return rates.rate(otherCurrency.codeProperty.value);
        }
        else if(rates.referenceCurrencyCode == otherCurrency.codeProperty.value) {
            return 1 / rates.rate(baseCurrency.codeProperty.value);
        }
        else {
            let referenceAmount = rates.rate(otherCurrency.codeProperty.value);
            return referenceAmount * ( 1 / rates.rate(baseCurrency.codeProperty.value));
        }
    }
    
}