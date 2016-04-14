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
    var leftCurrency: MutableProperty<CurrencyProtocol> { get }
    var rightCurrency: MutableProperty<CurrencyProtocol> { get }
    var expression: MutableProperty<String> { get }
    var isArrowPointingLeft: MutableProperty<Bool> { get }
}

public class PersistenceService: PersistenceServiceProtocol {
    private var userPreferencesService: UserPreferencesServiceProtocol
    private var queryCurrencyService: QueryPFCurrencyServiceProtocol
    
    public internal(set) var expression: MutableProperty<String>
    public internal(set) var isArrowPointingLeft: MutableProperty<Bool>
    public internal(set) var leftCurrency: MutableProperty<CurrencyProtocol>
    public internal(set) var rightCurrency: MutableProperty<CurrencyProtocol>
    
    convenience init() {
        self.init(userPreferencesService: UserPreferencesService(), queryCurrencyService: QueryPFCurrencyService());
    }
    
    init(userPreferencesService : UserPreferencesServiceProtocol, queryCurrencyService: QueryPFCurrencyServiceProtocol) {
        self.userPreferencesService = userPreferencesService;
        self.queryCurrencyService = queryCurrencyService;
        self.expression = MutableProperty<String>.init(self.userPreferencesService.expression);
        self.isArrowPointingLeft = MutableProperty<Bool>.init(self.userPreferencesService.isArrowPointingLeft);
        self.leftCurrency = MutableProperty<CurrencyProtocol>.init(CurrencyService.defaultBaseCurrency());
        self.rightCurrency = MutableProperty<CurrencyProtocol>.init(CurrencyService.defaultOtherCurrency());
        
        self.setupBindings();
    }
    
    func setupBindings()
    {
        self.leftCurrency <~ self.queryCurrencyService.currencySignalProducer(self.userPreferencesService.leftCurrencyCode);
        self.rightCurrency <~ self.queryCurrencyService.currencySignalProducer(self.userPreferencesService.rightCurrencyCode);
        
        self.expression.signal.observeNext { (value : String) -> () in
            self.userPreferencesService.expression = value;
        }
        self.isArrowPointingLeft.signal.observeNext { (value : Bool) -> () in
            self.userPreferencesService.isArrowPointingLeft = value;
        }
        self.leftCurrency.signal.observeNext{ (next : CurrencyProtocol) -> () in
            self.userPreferencesService.leftCurrencyCode = next.codeProperty.value;
        }
        self.rightCurrency.signal.observeNext{ (next : CurrencyProtocol) -> () in
            self.userPreferencesService.rightCurrencyCode = next.codeProperty.value;
        }
    }
}
