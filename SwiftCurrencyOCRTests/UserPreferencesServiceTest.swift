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
            var userPreferencesService: UserPreferencesService!;
            
            beforeEach {
                userPreferencesService = UserPreferencesService.init();
            }
            
            it("setting left currency code lets you retrieve it later") {
                let leftCurrencyCode = "BCC";
                
                userPreferencesService.leftCurrencyCode = leftCurrencyCode;
                
                expect(userPreferencesService.leftCurrencyCode).to(equal(leftCurrencyCode));
            }
            
            it("setting right currency code lets you retrieve it later") {
                let rightCurrencyCode = "OCC";
                
                userPreferencesService.rightCurrencyCode = rightCurrencyCode;
                
                expect(userPreferencesService.rightCurrencyCode).to(equal(rightCurrencyCode));
            }
            
            it("setting expression lets you retrieve it later") {
                let expression = "15+25";
                
                userPreferencesService.expression = expression;
                
                expect(userPreferencesService.expression).to(equal(expression));
            }
            
            it("setting isArrowPointingLeft lets you retrieve it later") {
                let isArrowPointingLeft = true;
                
                userPreferencesService.isArrowPointingLeft = isArrowPointingLeft;
                
                expect(userPreferencesService.isArrowPointingLeft).to(equal(isArrowPointingLeft));
            }
            
            it("setting nil clears preferences") {
                userPreferencesService.expression = "not nil";
                userPreferencesService.expression = nil;
                
                expect(userPreferencesService.expression).to(beNil());
            }
        }
        
    }
}

