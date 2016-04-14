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
            
            var mathParserService = MathParserServiceMock();
            var persistenceService = PersistenceServiceMock();
            var conversionService = ConversionServiceMock();
            var input = HomeViewModelInputMock();
            var currencyService = CurrencyServiceMock();
            
            var homeViewModel = HomeViewModel(input: input, persistenceService: persistenceService, conversionService: conversionService, mathParserService: mathParserService, currencyService: CurrencyServiceMock());
            
            beforeEach() {
                mathParserService = MathParserServiceMock();
                persistenceService = PersistenceServiceMock();
                conversionService = ConversionServiceMock();
                input = HomeViewModelInputMock();
                currencyService = CurrencyServiceMock();
                
                homeViewModel = HomeViewModel(input: input, persistenceService: persistenceService, conversionService: conversionService, mathParserService: mathParserService, currencyService: currencyService);
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
            
            it("test left currency text") {
                let baseAmount = 55.0;
                let otherAmount = 105.0;
                var leftCurrencyText = "55";
                var rightCurrencyText = "$105.00";
                
                mathParserService.baseAmount.swap(baseAmount);
                conversionService.otherAmount.swap(otherAmount);
                persistenceService.isArrowPointingLeft.swap(false);
                
                expect(homeViewModel.leftCurrencyText.value).toEventually(equal(leftCurrencyText));
                expect(homeViewModel.rightCurrencyText.value).toEventually(equal(rightCurrencyText));
                
                persistenceService.isArrowPointingLeft.swap(true);
                
                leftCurrencyText = "$55.00";
                rightCurrencyText = "105";
                
                expect(homeViewModel.leftCurrencyText.value).toEventually(equal(leftCurrencyText));
                expect(homeViewModel.rightCurrencyText.value).toEventually(equal(rightCurrencyText));
            }
        }
        
    }
}
