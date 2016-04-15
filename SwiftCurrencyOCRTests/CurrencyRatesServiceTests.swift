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

class CurrencyRateServiceTest: QuickSpec {
    
    override func spec() {
        
        describe("Currency Rates Service") {
            let kUSDKey = "USD";
            let kTHBKey = "THB";
            let kEURKey = "EUR";
            let kGBPKey = "GBP";
            
            let thbRate = 36.03;
            let eurRate = 0.92;
            let gbpRate = 0.67;
            
            let usdCurrency = Currency.currencyWithCode(kUSDKey);
            let thbCurrency = Currency.currencyWithCode(kTHBKey);
            let eurCurrency = Currency.currencyWithCode(kEURKey);
            let gbpCurrency = Currency.currencyWithCode(kGBPKey);
            
            func buildTestRates () -> CurrencyRatesProtocol {
                let rates = CurrencyRates();
                rates.referenceCurrencyCode = kUSDKey;
                let dictionary = NSMutableDictionary.init(capacity: 4);
                dictionary.setObject(thbRate, forKey: kTHBKey);
                dictionary.setObject(eurRate, forKey: kEURKey);
                dictionary.setObject(gbpRate, forKey: kGBPKey);
                rates.rates = dictionary;
                return rates;
            }
            
            let testRates = buildTestRates();
            
            let currencyService = CurrencyServiceMock();
            let ratesService = CurrencyRatesServiceMock();
            let rateService = CurrencyRateService(ratesService : ratesService, currencyService: currencyService);
            
            it("test USD to THB") {
                let expectedRate = thbRate;
                currencyService._baseCurrency.swap(usdCurrency);
                currencyService._otherCurrency.swap(thbCurrency);
                ratesService._rates.swap(testRates);
                
                expect(rateService.rate.value).toEventually(equal(expectedRate));
            }
            
            it("test USD to EUR") {
                let expectedRate = eurRate;
                currencyService._baseCurrency.swap(usdCurrency);
                currencyService._otherCurrency.swap(eurCurrency);
                ratesService._rates.swap(testRates);
                
                expect(rateService.rate.value).toEventually(equal(expectedRate));
            }
            
            it("test EUR to USD") {
                let expectedRate = 1 / eurRate;
                currencyService._baseCurrency.swap(eurCurrency);
                currencyService._otherCurrency.swap(usdCurrency);
                ratesService._rates.swap(testRates);
                
                expect(rateService.rate.value).toEventually(equal(expectedRate));
            }
            
            it("test GBP to THB") {
                let expectedRate = (1 / gbpRate) *  thbRate;
                currencyService._baseCurrency.swap(gbpCurrency);
                currencyService._otherCurrency.swap(thbCurrency);
                ratesService._rates.swap(testRates);
                
                expect(rateService.rate.value).toEventually(equal(expectedRate));
            }
        }
        
    }
}
