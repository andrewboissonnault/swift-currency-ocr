//
//  UserPreferencesServiceTest.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/21/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Quick
import Nimble
import SwiftCurrencyOCR

class UserPreferencesServiceSpec: QuickSpec {
    
    override func spec() {
        describe("User Preferences Service") {
            
            var userPreferencesService : UserPreferencesServiceProtocol = UserPreferencesService.sharedInstance;
            var otherPreferencesService : UserPreferencesServiceProtocol = UserPreferencesService.sharedInstance;
            
            beforeEach {
                userPreferencesService = UserPreferencesService.sharedInstance;
                otherPreferencesService = UserPreferencesService.sharedInstance;
            }
            
            it("setting left currency code lets you retrieve it later") {
                let leftCurrencyCode = "BCC";
                
                userPreferencesService.leftCurrencyCode.value = leftCurrencyCode;
                
                expect(userPreferencesService.leftCurrencyCode.value).toEventually(equal(leftCurrencyCode));
                expect(otherPreferencesService.leftCurrencyCode.value).toEventually(equal(leftCurrencyCode));
                
                otherPreferencesService = UserPreferencesService.init();
                expect(otherPreferencesService.leftCurrencyCode.value).toEventually(equal(leftCurrencyCode));
            }
            
            it("setting right currency code lets you retrieve it later") {
                let rightCurrencyCode = "OCC";
                
                userPreferencesService.rightCurrencyCode.value = rightCurrencyCode;
                
                expect(userPreferencesService.rightCurrencyCode.value).toEventually(equal(rightCurrencyCode));
                expect(otherPreferencesService.rightCurrencyCode.value).toEventually(equal(rightCurrencyCode));
                
                otherPreferencesService = UserPreferencesService.init();
                expect(otherPreferencesService.rightCurrencyCode.value).toEventually(equal(rightCurrencyCode));
            }
            
            it("setting expression lets you retrieve it later") {
                let expression = "15+25";
                
                userPreferencesService.expression.value = expression;
                
                expect(userPreferencesService.expression.value).toEventually(equal(expression));
                expect(otherPreferencesService.expression.value).toEventually(equal(expression));
                
                otherPreferencesService = UserPreferencesService.init();
                expect(otherPreferencesService.expression.value).toEventually(equal(expression));
            }
            
            it("setting isArrowPointingLeft lets you retrieve it later") {
                let isArrowPointingLeft = true;
                
                userPreferencesService.isArrowPointingLeft.value = isArrowPointingLeft;
                
                expect(userPreferencesService.isArrowPointingLeft.value).toEventually(equal(isArrowPointingLeft));
                expect(otherPreferencesService.isArrowPointingLeft.value).toEventually(equal(isArrowPointingLeft));
                
                otherPreferencesService = UserPreferencesService.init();
                expect(otherPreferencesService.isArrowPointingLeft.value).toEventually(equal(isArrowPointingLeft));
            }
        }
        
    }
}

