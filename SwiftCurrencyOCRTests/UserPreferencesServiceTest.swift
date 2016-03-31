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
            
            it("setting base currency code lets you retrieve it later") {
                let baseCurrencyCode = "BCC";
                
                userPreferencesService.baseCurrencyCode = baseCurrencyCode;
                
                expect(userPreferencesService.baseCurrencyCode).to(equal(baseCurrencyCode));
            }
            
            it("setting other currency code lets you retrieve it later") {
                let otherCurrencyCode = "OCC";
                
                userPreferencesService.otherCurrencyCode = otherCurrencyCode;
                
                expect(userPreferencesService.otherCurrencyCode).to(equal(otherCurrencyCode));
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

