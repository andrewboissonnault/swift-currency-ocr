//
//  CurrencyRatesServiceTests.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/31/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Quick
import Nimble
import SwiftCurrencyOCR
import ReactiveCocoa
import enum Result.NoError

let kUSDKey = "USD";
let kTHBKey = "THB";
let kEURKey = "EUR";
let kGBPKey = "GBP";

class CurrencyRateServiceTest: QuickSpec {
    
    let baseCurrency = MutableProperty<CurrencyProtocol>.init(CurrencyService.defaultBaseCurrency());
    
    
    override func spec() {
        
        
        describe("Currency Rates Service") {
            class PersistenceServiceMock : PersistenceService {
                override init(userPreferencesService : UserPreferencesServiceProtocol, currencyService: CurrencyServiceProtocol) {
                    super.init(userPreferencesService: userPreferencesService, currencyService: currencyService);
                    self.baseCurrency = MutableProperty<CurrencyProtocol>.init(CurrencyService.defaultBaseCurrency());
                    self.otherCurrency = MutableProperty<CurrencyProtocol>.init(CurrencyService.defaultOtherCurrency());
                }
            }
            
            class CurrencyRatesServiceMock : CurrencyRatesService {
                var testRates : CurrencyRatesProtocol;
                
                init(testRates: CurrencyRatesProtocol) {
                    self.testRates = testRates;
                    super.init();
                }
                
                override func ratesSignalProducer() -> SignalProducer<CurrencyRatesProtocol?, NoError> {
                    return SignalProducer {
                        sink, disposable in
                        let seconds = 0.01
                        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        
                        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                            sink.sendNext(self.testRates);
                        })
                    }
                }
            }
            
            func buildTestRates () -> CurrencyRatesProtocol {
                let rates = CurrencyRates();
                rates.referenceCurrencyCode = kUSDKey;
                let dictionary = NSMutableDictionary.init(capacity: 4);
                dictionary.setObject(36.03, forKey: kTHBKey);
                dictionary.setObject(0.92, forKey: kEURKey);
                dictionary.setObject(0.67, forKey: kGBPKey);
                rates.rates = dictionary;
                return rates;
            }
            
            let testRates = buildTestRates();
            let userPreferencesService = UserPreferencesService();
            let currencyService = CurrencyServiceMock();
            let persistenceService = PersistenceServiceMock(userPreferencesService: userPreferencesService, currencyService: currencyService);
            let ratesService = CurrencyRatesServiceMock(testRates : testRates);
            let rateService = CurrencyRateService(persistenceService : persistenceService, ratesService : ratesService);
            
            
            it("test initial rate") {
                expect(rateService.rate.value) == 1.0;
            }
            
            it("test initial rate") {
                expect(rateService.rate.value) == 1.0;
            }
        }
        
    }
}
