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
    static var sharedInstance : PersistenceServiceProtocol = PersistenceService.init();
    
    private var userPreferencesService: UserPreferencesServiceProtocol
    private var queryCurrencyService: QueryPFCurrencyServiceProtocol
    
    public internal(set) var expression: MutableProperty<String>
    public internal(set) var isArrowPointingLeft: MutableProperty<Bool>
    public internal(set) var leftCurrency: MutableProperty<CurrencyProtocol>
    public internal(set) var rightCurrency: MutableProperty<CurrencyProtocol>
    
    convenience init() {
        self.init(userPreferencesService: UserPreferencesService.sharedInstance, queryCurrencyService: QueryPFCurrencyService());
    }
    
    init(userPreferencesService : UserPreferencesServiceProtocol, queryCurrencyService: QueryPFCurrencyServiceProtocol) {
        self.userPreferencesService = userPreferencesService;
        self.queryCurrencyService = queryCurrencyService;
        self.expression = self.userPreferencesService.expression;
        self.isArrowPointingLeft = MutableProperty<Bool>.init(self.userPreferencesService.isArrowPointingLeft.value);

        self.leftCurrency = MutableProperty<CurrencyProtocol>.init(Currency());
        self.rightCurrency = MutableProperty<CurrencyProtocol>.init(Currency());
        self.userPreferencesService.leftCurrencyCode <~ self.leftCurrency.signal.map(PersistenceService.codeWithCurrency);
        self.userPreferencesService.rightCurrencyCode <~ self.rightCurrency.signal.map(PersistenceService.codeWithCurrency);
        
        self.isArrowPointingLeft = self.userPreferencesService.isArrowPointingLeft;
        
        self.setupBindings();
    }
    
    static func codeWithCurrency(currency : CurrencyProtocol) -> String{
        return currency.codeProperty.value;
    }
    
    func setupBindings()
    {
        self.leftCurrency <~ self.queryCurrencyService.currencySignalProducer(self.userPreferencesService.leftCurrencyCode.value).map{ (currency : CurrencyProtocol?) in
            return PersistenceService.filterCurrency(currency, defaultCurrency: CurrencyService.defaultBaseCurrency());
        }
        self.rightCurrency <~ self.queryCurrencyService.currencySignalProducer(self.userPreferencesService.rightCurrencyCode.value).map{ (currency : CurrencyProtocol?) in
            return PersistenceService.filterCurrency(currency, defaultCurrency: CurrencyService.defaultOtherCurrency());
        }
    }
    
    private static func filterCurrency ( currency : CurrencyProtocol?, defaultCurrency : CurrencyProtocol) -> CurrencyProtocol {
        if( currency == nil ) {
            return defaultCurrency;
        }
        return currency!;
    }
}
