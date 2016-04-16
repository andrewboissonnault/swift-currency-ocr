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
    let initialLeftCurrencyCode = "initialLeftCurrencyCode";
    let initialRightCurrencyCode = "initialRightCurrencyCode";
    
    
    override func spec() {
        describe("Persistence Service") {
            
            let userPreferencesService: UserPreferencesServiceProtocol = UserPreferencesServiceMock();
            let queryCurrencyService: QueryPFCurrencyServiceProtocol = QueryPFCurrencyServiceMock();
            var persistenceService: PersistenceService!;
            
            beforeEach {
                userPreferencesService.expression.value = self.initialExpressionValue;
                userPreferencesService.isArrowPointingLeft.value  = self.initialIsArrowPointingLeftValue
                userPreferencesService.leftCurrencyCode.value  = self.initialLeftCurrencyCode
                userPreferencesService.rightCurrencyCode.value  = self.initialRightCurrencyCode
                persistenceService = PersistenceService.init(userPreferencesService: userPreferencesService, queryCurrencyService: queryCurrencyService);
            }
            
            it("initial values are correct") {
                expect(persistenceService.expression.value) == self.initialExpressionValue;
                expect(persistenceService.isArrowPointingLeft.value) == self.initialIsArrowPointingLeftValue;
                expect(persistenceService.leftCurrency.value.codeProperty.value) == self.initialLeftCurrencyCode;
                expect(persistenceService.rightCurrency.value.codeProperty.value) == self.initialRightCurrencyCode;
            }
            
            it("setting expression value modifies user defaults") {
                let expressionValue = "expression";
                
                persistenceService.expression.swap(expressionValue);
                
                expect(persistenceService.expression.value) == expressionValue;
                expect(userPreferencesService.expression.value ) == expressionValue;
            }
            
            it("setting isArrowPointingLeft value modifies user defaults") {
                let isArrowPointingLeftValue = true;
                
                persistenceService.isArrowPointingLeft.swap(isArrowPointingLeftValue);
                
                expect(persistenceService.isArrowPointingLeft.value) == isArrowPointingLeftValue;
                expect(userPreferencesService.isArrowPointingLeft.value) == isArrowPointingLeftValue;
            }
            
            it("setting leftCurrency value modifies user defaults") {
                let leftCurrency = buildCurrency("leftCurrencyCode")
                
                persistenceService.leftCurrency.swap(leftCurrency);
                
                expect(userPreferencesService.leftCurrencyCode.value) == leftCurrency.codeProperty.value;
            }
            
            it("setting rightCurrency value modifies user defaults") {
                let rightCurrency = buildCurrency("rightCurrencyCode")
                
                persistenceService.rightCurrency.swap(rightCurrency);
                
                expect(userPreferencesService.rightCurrencyCode.value) == rightCurrency.codeProperty.value;
            }
        }
        
    }
}


