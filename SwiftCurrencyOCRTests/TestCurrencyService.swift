//
//  TestCurrencyService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/20/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Quick
import Nimble
import SwiftCurrencyOCR

class CurrencyServiceSpec: QuickSpec {
    override func spec() {
        let persistenceService = PersistenceServiceMock();
        let currencyService = CurrencyService(persistenceService : persistenceService);
        
        it("test currency service") {
            let leftCurrency : CurrencyProtocol = Currency.currencyWithCode("LEFT");
            let rightCurrency : CurrencyProtocol = Currency.currencyWithCode("RIGHT");
            
            persistenceService.leftCurrency.swap(leftCurrency);
            persistenceService.rightCurrency.swap(rightCurrency);
            persistenceService.isArrowPointingLeft.swap(false);
            
            expect(currencyService.baseCurrency.value.codeProperty.value).toEventually(equal(leftCurrency.codeProperty.value));
            expect(currencyService.otherCurrency.value.codeProperty.value).toEventually(equal(rightCurrency.codeProperty.value));
            
            persistenceService.isArrowPointingLeft.swap(true);
            
            expect(currencyService.baseCurrency.value.codeProperty.value).toEventually(equal(rightCurrency.codeProperty.value));
            expect(currencyService.otherCurrency.value.codeProperty.value).toEventually(equal(leftCurrency.codeProperty.value));
        }

        
        it("default base currency is USD") {
            let defaultCurrency = CurrencyService.defaultBaseCurrency();
            
            expect(defaultCurrency.codeProperty.value).to(equal("USD"))
        }
        
        it("default other currency is EUR") {
            let defaultCurrency = CurrencyService.defaultOtherCurrency();
            
            expect(defaultCurrency.codeProperty.value).to(equal("EUR"))
        }
        
        
    }
}

