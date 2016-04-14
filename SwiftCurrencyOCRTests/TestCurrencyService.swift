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

