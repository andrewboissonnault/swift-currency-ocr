//
//  HomeViewModelTests.swift
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

class HomeViewModelTests: QuickSpec {
    
    override func spec() {
        
        describe("Home View Model") {
            
            var textService = TextServiceMock();
            var persistenceService = PersistenceServiceMock();
            var currencyService = CurrencyServiceMock();
            
            var homeViewModel = HomeViewModel(persistenceService: persistenceService, currencyService: currencyService, textService: textService);
            
            beforeEach() {
                persistenceService = PersistenceServiceMock();
                currencyService = CurrencyServiceMock();
                textService = TextServiceMock();
                
                homeViewModel = HomeViewModel(persistenceService: persistenceService, currencyService: currencyService, textService: textService);
            }
            
            it("test isArrowPointingLeft is true") {
                let isArrowPointingLeft = true;
                
                persistenceService.isArrowPointingLeft.swap(isArrowPointingLeft);
                
                expect(homeViewModel.isArrowPointingLeft.value).toEventually(beTrue());
            }
            
            it("test isArrowPointingLeft is false") {
                let isArrowPointingLeft = false;
                
                persistenceService.isArrowPointingLeft.swap(isArrowPointingLeft);
                
                expect(homeViewModel.isArrowPointingLeft.value).toEventually(beFalse());
            }
            
            it("test currencyText") {
                let leftCurrencyText = "leftCurrencyText";
                let rightCurrencyText = "rightCurrencyText";
                
                textService.leftCurrencyText.swap(leftCurrencyText);
                textService.rightCurrencyText.swap(rightCurrencyText);
                
                expect(homeViewModel.leftCurrencyText.value).toEventually(equal(leftCurrencyText));
                expect(homeViewModel.rightCurrencyText.value).toEventually(equal(rightCurrencyText));
            }
            
            it("test currency view models") {
                let leftCurrency = Currency.currencyWithCode("LEFT");
                let rightCurrency = Currency.currencyWithCode("RIGHT");
                
                let leftCurrencyViewModel = CurrencyViewModel.init(currency: leftCurrency);
                let rightCurrencyViewModel = CurrencyViewModel.init(currency: rightCurrency);
                
                persistenceService.leftCurrency.swap(leftCurrency);
                persistenceService.rightCurrency.swap(rightCurrency);
                
                expect(homeViewModel.leftCurrencyViewModel.value.currencyCode.value).toEventually(equal(leftCurrencyViewModel.currencyCode.value));
                expect(homeViewModel.rightCurrencyViewModel.value.currencyCode.value).toEventually(equal(rightCurrencyViewModel.currencyCode.value));
            }
            
            it("test toggle arrow") {
                persistenceService.isArrowPointingLeft.swap(false);
                
                homeViewModel.toggleArrow();
                
                expect(persistenceService.isArrowPointingLeft.value).toEventually(beTrue());
                expect(homeViewModel.isArrowPointingLeft.value).toEventually(beTrue());
                
                homeViewModel.toggleArrow();
                
                expect(persistenceService.isArrowPointingLeft.value).toEventually(beFalse());
                expect(homeViewModel.isArrowPointingLeft.value).toEventually(beFalse());
            }
            
            it("test expression input") {
                let newExpression = "newExpression";
                
                persistenceService.expression.swap("expression");
                
                homeViewModel.expression.swap(newExpression);
                
                expect(persistenceService.expression.value).toEventually(equal(newExpression));
            }
            
    }
        
    }
}
