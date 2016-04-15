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
    var rate: AnyProperty<Double> { get }
}

public class BaseCurrencyRateService : CurrencyRateServiceProtocol {
    var rate: AnyProperty<Double> {
        return AnyProperty(_rate);
    }
    internal private(set) var _rate = MutableProperty<Double>.init(1.0);
}

public class CurrencyRateService: BaseCurrencyRateService {
    private var ratesService: CurrencyRatesServiceProtocol
    private var currencyService: CurrencyServiceProtocol
    
    convenience override init() {
        self.init(ratesService: CurrencyRatesService(), currencyService : CurrencyService());
    }
    
    init(ratesService : CurrencyRatesServiceProtocol, currencyService : CurrencyServiceProtocol) {
        self.ratesService = ratesService;
        self.currencyService = currencyService;
        super.init();
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self._rate <~ self.rateSignal();
    }
    
    private func rateSignal() -> Signal<Double, Result.NoError> {
        let combinedSignal = combineLatest(self.currencyService.baseCurrency.signal, self.currencyService.otherCurrency.signal, self.ratesService.rates.signal);
        let signal = combinedSignal.map(CurrencyRateService.calculateRate);
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