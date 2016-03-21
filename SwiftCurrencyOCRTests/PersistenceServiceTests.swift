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

class PersistenceServiceTests: QuickSpec {
    let initialExpressionValue = "initialExpression";
    let initialIsArrowPointingLeftValue = true;
    
    override func spec() {
        describe("Persistence Service") {
            class MockService: UserPreferencesService {
            }
            
            let userPreferencesServiceMock: MockService = MockService();
            var persistenceService: PersistenceService!;
            
            beforeEach {
                userPreferencesServiceMock.expression = self.initialExpressionValue;
                persistenceService = PersistenceService.init(userPreferencesService: userPreferencesServiceMock);
            }
            
            it("initial values are correct") {
                expect(persistenceService.expression.value).to(equal(self.initialExpressionValue));
                expect(persistenceService.isArrowPointingLeft.value).to(equal(self.initialIsArrowPointingLeftValue));
            }
            
            it("setting expression value modifies user defaults") {
                let expressionValue = "expression";
                
                persistenceService.expression.swap(expressionValue);
                
                expect(persistenceService.expression.value).to(equal(expressionValue));
                expect(userPreferencesServiceMock.expression).to(equal(expressionValue));
            }
            
            it("setting isArrowPointingLeft value modifies user defaults") {
                let isArrowPointingLeftValue = false;
                
                persistenceService.isArrowPointingLeft.swap(isArrowPointingLeftValue);
                
                expect(persistenceService.isArrowPointingLeft.value).to(equal(isArrowPointingLeftValue));
                expect(userPreferencesServiceMock.isArrowPointingLeft).to(equal(isArrowPointingLeftValue));
            }
        }
        
    }
}


