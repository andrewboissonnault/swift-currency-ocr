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
    var baseCurrency: MutableProperty<CurrencyProtocol> { get }
    var otherCurrency: MutableProperty<CurrencyProtocol> { get }
}

public class CurrencyService: CurrencyServiceProtocol {
    public private(set) var baseCurrency: MutableProperty<CurrencyProtocol>
    public private(set) var otherCurrency: MutableProperty<CurrencyProtocol>
    
    private var persistenceService : PersistenceServiceProtocol;
    
    convenience init() {
        self.init(persistenceService : PersistenceService());
    }
    
    init(persistenceService : PersistenceServiceProtocol) {
        self.persistenceService = persistenceService;
        
        self.baseCurrency = MutableProperty<CurrencyProtocol>.init(Currency());
        self.otherCurrency = MutableProperty<CurrencyProtocol>.init(Currency());
        
        self.setupBindings();
    }
    
    private func setupBindings() {
        self.baseCurrency <~ self.baseCurrencySignal();
        self.otherCurrency <~ self.otherCurrencySignal();
    }
    
    private func baseCurrencySignal() -> Signal<CurrencyProtocol, Result.NoError> {
        let signal = self.combinedCurrencySignal().map(self.reduceLeftCurrencies);
        return signal;
    }
    
    private func otherCurrencySignal() -> Signal<CurrencyProtocol, Result.NoError> {
        let signal = self.combinedCurrencySignal().map(self.reduceRightCurrencies);
        return signal;
    }
    
    private func combinedCurrencySignal() -> Signal<(CurrencyProtocol, CurrencyProtocol, Bool), Result.NoError> {
        let signal = combineLatest(self.persistenceService.leftCurrency.signal, self.persistenceService.rightCurrency.signal, self.persistenceService.isArrowPointingLeft.signal);
        return signal;
    }
    
    private func reduceLeftCurrencies(left : CurrencyProtocol, right : CurrencyProtocol, isArrowPointingLeft : Bool) -> CurrencyProtocol {
        return reduceLeft(left as! AnyObject, right: right as! AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! CurrencyProtocol;
    }
    
    private func reduceRightCurrencies(left : CurrencyProtocol, right : CurrencyProtocol, isArrowPointingLeft : Bool) -> CurrencyProtocol {
        return reduceRight(left as! AnyObject, right: right as! AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! CurrencyProtocol;
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
