//
//  TextServiceTests.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/14/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Quick
import Nimble
import SwiftCurrencyOCR
import ReactiveCocoa
import enum Result.NoError

class TextServiceTests: QuickSpec {
    
    override func spec() {
        
        describe("Text Service") {
            
            let persistenceService = PersistenceServiceMock();
            let mathParserService = MathParserServiceMock();
            let conversionService = ConversionServiceMock();
            let textService = TextService(persistenceService : persistenceService, conversionService : conversionService, mathParserService : mathParserService);
            
            it("test currency text service") {
                let baseAmount = 55.0;
                let otherAmount = 105.0;
                var leftCurrencyText = "55";
                var rightCurrencyText = "$105.00";
                
                mathParserService._baseAmount.swap(baseAmount);
                conversionService._otherAmount.swap(otherAmount);
                persistenceService.isArrowPointingLeft.swap(false);
                
                expect(textService.leftCurrencyText.value).toEventually(equal(leftCurrencyText));
                expect(textService.rightCurrencyText.value).toEventually(equal(rightCurrencyText));
                
                mathParserService._baseAmount.swap(otherAmount);
                conversionService._otherAmount.swap(baseAmount);
                persistenceService.isArrowPointingLeft.swap(true);
                
                leftCurrencyText = "$55.00";
                rightCurrencyText = "105";
                
                expect(textService.leftCurrencyText.value).toEventually(equal(leftCurrencyText));
                expect(textService.rightCurrencyText.value).toEventually(equal(rightCurrencyText));
            }
            
        }
        
    }
}

