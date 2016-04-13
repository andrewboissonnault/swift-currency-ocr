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
            
            let persistenceService = PersistenceServiceMock();
            let rateService = CurrencyRateServiceMock();
            let mathParserService = MathParserService();
            let conversionService = ConversionService(persistenceService: persistenceService, rateService: rateService, mathParserService: mathParserService);
            
            it("test conversion service") {
                let baseExpression = "50";
                let rate = 1.5;
                let expectedOtherAmount = 75.0;
                
                persistenceService.expression.swap(baseExpression);
                rateService.rate.swap(rate);
                
                expect(conversionService.otherAmount.value).toEventually(equal(expectedOtherAmount));
            }
            
            it("test conversion service with nil expression") {
                let rate = 1.5;
                let expectedOtherAmount = 0.0;
                
                persistenceService.expression.swap(nil);
                rateService.rate.swap(rate);
                
                expect(conversionService.otherAmount.value).toEventually(equal(expectedOtherAmount));
            }
            
        }
        
    }
}
