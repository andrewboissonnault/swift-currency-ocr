//
//  PersistenceService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/21/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

public protocol PersistenceServiceProtocol {
    var baseCurrency: MutableProperty<CurrencyProtocol> { get }
    var otherCurrency: MutableProperty<CurrencyProtocol> { get }
    var expression: MutableProperty<String?> { get }
    var isArrowPointingLeft: MutableProperty<Bool> { get }
}

public class PersistenceService: PersistenceServiceProtocol {
    var userPreferencesService: UserPreferencesServiceProtocol
    var currencyService: CurrencyServiceProtocol
    
    public internal(set) var expression: MutableProperty<String?>
    public internal(set) var isArrowPointingLeft: MutableProperty<Bool>
    public internal(set) var baseCurrency: MutableProperty<CurrencyProtocol>
    public internal(set) var otherCurrency: MutableProperty<CurrencyProtocol>
    
    convenience init() {
        self.init(userPreferencesService: UserPreferencesService(), currencyService: CurrencyService());
    }
    
    init(userPreferencesService : UserPreferencesServiceProtocol, currencyService: CurrencyServiceProtocol) {
        self.userPreferencesService = userPreferencesService;
        self.currencyService = currencyService;
        self.expression = MutableProperty<String?>.init(self.userPreferencesService.expression);
        self.isArrowPointingLeft = MutableProperty<Bool>.init(self.userPreferencesService.isArrowPointingLeft);
        self.baseCurrency = MutableProperty<CurrencyProtocol>.init(CurrencyService.defaultBaseCurrency());
        self.otherCurrency = MutableProperty<CurrencyProtocol>.init(CurrencyService.defaultOtherCurrency());
        
        self.setupBindings();
    }
    
    func setupBindings()
    {
        self.baseCurrency <~ self.currencyService.currencySignalProducer(self.userPreferencesService.baseCurrencyCode);
        self.otherCurrency <~ self.currencyService.currencySignalProducer(self.userPreferencesService.otherCurrencyCode);
        
        self.expression.signal.observeNext { (value : String?) -> () in
            self.userPreferencesService.expression = value;
        }
        self.isArrowPointingLeft.signal.observeNext { (value : Bool) -> () in
            self.userPreferencesService.isArrowPointingLeft = value;
        }
        self.baseCurrency.signal.observeNext{ (next : CurrencyProtocol) -> () in
            self.userPreferencesService.baseCurrencyCode = next.code;
        }
        self.otherCurrency.signal.observeNext{ (next : CurrencyProtocol) -> () in
            self.userPreferencesService.otherCurrencyCode = next.code;
        }
    }
}
