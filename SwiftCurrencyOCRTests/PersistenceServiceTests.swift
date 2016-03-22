//
//  PersistenceServiceTests.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/21/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Quick
import Nimble
import SwiftCurrencyOCR
import ReactiveCocoa
import enum Result.NoError

class PersistenceServiceTests: QuickSpec {
    let initialExpressionValue = "initialExpression";
    let initialIsArrowPointingLeftValue = true;
    
    override func spec() {
        describe("Persistence Service") {
            class CurrencyServiceMock : CurrencyService {
                override func currencySignalProducer(code : String?) -> SignalProducer<CurrencyProtocol, NoError> {
                    return SignalProducer {
                        sink, disposable in
                        let currency = Currency();
                        currency.code = code;
                        currency.name = code;
                        sink.sendNext(currency);
                        }
                    }
            }
            
            let userDefaults: NSUserDefaults = NSUserDefaults.init(suiteName: "test")!;
            let userPreferencesService: UserPreferencesService = UserPreferencesService(defaults: userDefaults);
            let currencyService: CurrencyService = CurrencyServiceMock();
            var persistenceService: PersistenceService!;
            
            beforeEach {
                userPreferencesService.expression = self.initialExpressionValue;
                userPreferencesService.isArrowPointingLeft = self.initialIsArrowPointingLeftValue
                persistenceService = PersistenceService.init(userPreferencesService: userPreferencesService, currencyService: currencyService);
            }
            
            afterEach({
                userDefaults .removeSuiteNamed("test");
            })
            
            it("initial values are correct") {
                expect(persistenceService.expression.value) == self.initialExpressionValue;
                expect(persistenceService.isArrowPointingLeft.value) == self.initialIsArrowPointingLeftValue;
            }
            
            it("setting expression value modifies user defaults") {
                let expressionValue = "expression";
                
                persistenceService.expression.swap(expressionValue);
                
                expect(persistenceService.expression.value) == expressionValue;
                expect(userPreferencesService.expression) == expressionValue;
            }
            
            it("setting isArrowPointingLeft value modifies user defaults") {
                let isArrowPointingLeftValue = false;
                
                persistenceService.isArrowPointingLeft.swap(isArrowPointingLeftValue);
                
                expect(persistenceService.isArrowPointingLeft.value) == isArrowPointingLeftValue;
                expect(userPreferencesService.isArrowPointingLeft) == isArrowPointingLeftValue;
            }
            
            it("setting baseCurrency value modifies user defaults") {
                var baseCurrency: CurrencyProtocol = Currency();
                baseCurrency.code = "BCC";
                baseCurrency.name = "Base Currency";
                
                persistenceService.baseCurrency.swap(baseCurrency);
                
           //     expect(persistenceService.baseCurrency.value) == baseCurrency;
                
                expect(userPreferencesService.baseCurrencyCode) == baseCurrency.code;
            }
        }
        
    }
}


