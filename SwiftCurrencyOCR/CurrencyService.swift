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
    var baseCurrency: AnyProperty<CurrencyProtocol> { get }
    var otherCurrency: AnyProperty<CurrencyProtocol> { get }
}

public class BaseCurrencyService: CurrencyServiceProtocol {
    var baseCurrency: AnyProperty<CurrencyProtocol> {
        return AnyProperty(_baseCurrency);
    }
    internal private(set) var _baseCurrency = MutableProperty<CurrencyProtocol>.init(Currency());
    var otherCurrency: AnyProperty<CurrencyProtocol> {
        return AnyProperty(_otherCurrency);
    }
    internal private(set) var _otherCurrency = MutableProperty<CurrencyProtocol>.init(Currency());
}

public class CurrencyService: BaseCurrencyService {
    
    private var persistenceService : PersistenceServiceProtocol;
    
    convenience override init() {
        self.init(persistenceService : PersistenceService());
    }
    
    init(persistenceService : PersistenceServiceProtocol) {
        self.persistenceService = persistenceService;
        super.init();
        self.setupBindings();
    }
    
    private func setupBindings() {
        self._baseCurrency <~ self.baseCurrencySignal();
        self._otherCurrency <~ self.otherCurrencySignal();
    }
    
    private func baseCurrencySignal() -> Signal<CurrencyProtocol, Result.NoError> {
        let signal = self.combinedCurrencySignal().map(reduceLeft);
        return signal;
    }
    
    private func otherCurrencySignal() -> Signal<CurrencyProtocol, Result.NoError> {
        let signal = self.combinedCurrencySignal().map(reduceRight);
        return signal;
    }
    
    private func combinedCurrencySignal() -> Signal<(CurrencyProtocol, CurrencyProtocol, Bool), Result.NoError> {
        let signal = combineLatest(self.persistenceService.leftCurrency.signal, self.persistenceService.rightCurrency.signal, self.persistenceService.isArrowPointingLeft.signal);
        return signal;
    }
    
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
}
