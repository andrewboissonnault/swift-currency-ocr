//
//  CurrencyViewModelTests.swift
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

class CurrencyViewModelTest: QuickSpec {
    
    override func spec() {
        
        describe("Currency View Model") {
            let kUSDKey = "USD";
            
            it("test currency view model") {
                let testName = "testName";
                let testCode = kUSDKey;
                let testCurrency = Currency.currencyWithCode(testCode);
                testCurrency.nameProperty.swap(testName);
                
                let viewModel = CurrencyViewModel.init(currency: testCurrency);
                
                expect(viewModel.currencyCode.value).toEventually(equal(testCode));
                expect(viewModel.currencyName.value).toEventually(equal(testName));
                expect(viewModel.flagIconImage.value).toEventually(beTruthy());
            }
            
            it("test currency view model with invalid image") {
                let testName = "testName";
                let testCode = "__CodeWithNoImage__";
                let testCurrency = Currency.currencyWithCode(testCode);
                testCurrency.nameProperty.swap(testName);
                
                let viewModel = CurrencyViewModel.init(currency: testCurrency);
                
                expect(viewModel.currencyCode.value).toEventually(equal(testCode));
                expect(viewModel.currencyName.value).toEventually(equal(testName));
                expect(viewModel.flagIconImage.value).toEventually(beNil());
            }
        }
        
    }
}
