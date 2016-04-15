//
//  ConversionServiceTests.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/13/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Quick
import Nimble
import SwiftCurrencyOCR
import ReactiveCocoa
import enum Result.NoError

class ConversionServiceTests: QuickSpec {
    
    override func spec() {
        
        describe("Currency Rates Service") {
            
            let rateService = CurrencyRateServiceMock();
            let mathParserService = MathParserServiceMock();
            let conversionService = ConversionService(rateService: rateService, mathParserService: mathParserService);
            
            it("test conversion service") {
                let baseExpression = 50.0;
                let rate = 1.5;
                let expectedOtherAmount = 75.0;
                
                mathParserService._baseAmount.swap(baseExpression);
                rateService._rate.swap(rate);
                
                expect(conversionService.otherAmount.value).toEventually(equal(expectedOtherAmount));
            }
            
            it("test conversion service with base amount equal to zero") {
                let rate = 1.5;
                let expectedOtherAmount = 0.0;
                
                mathParserService._baseAmount.swap(0.0);
                rateService._rate.swap(rate);
                
                expect(conversionService.otherAmount.value).toEventually(equal(expectedOtherAmount));
            }
            
        }
        
    }
}
