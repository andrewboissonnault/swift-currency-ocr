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
            var input = HomeViewModelInputMock();
            var currencyService = CurrencyServiceMock();
            
            var homeViewModel = HomeViewModel(input: input, persistenceService: persistenceService, currencyService: currencyService, textService: textService);
            
            beforeEach() {
                persistenceService = PersistenceServiceMock();
                input = HomeViewModelInputMock();
                currencyService = CurrencyServiceMock();
                textService = TextServiceMock();
                
                homeViewModel = HomeViewModel(input: input, persistenceService: persistenceService, currencyService: currencyService, textService: textService);
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
            
    }
        
    }
}
