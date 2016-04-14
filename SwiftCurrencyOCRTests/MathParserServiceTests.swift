//
//  MathParserServiceTests.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/23/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Quick
import Nimble
import SwiftCurrencyOCR
import ReactiveCocoa
import enum Result.NoError

class MathParserServiceTests: QuickSpec {
    
    override func spec() {
        describe("MathParser Service") {
            
            let persistenceService = PersistenceServiceMock();
            let mathParserService: MathParserService = MathParserService.init(persistenceService: persistenceService);
            
            it("testNoOperator") {
                let testString = "1";
                let expectedResult = 1.0;
            
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testEmptyString") {
                let testString = "";
                let expectedResult: Double = 0;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testOneOperandOneOperator") {
                let testString = "2+";
                let expectedResult: Double = 2;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testAddition") {
                let testString = "3+4";
                let expectedResult: Double = 7;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testSubtraction") {
                let testString = "5−6";
                let expectedResult: Double = -1;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testMultiplication") {
                let testString = "7×8";
                let expectedResult: Double = 56;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testDivision") {
                let testString = "9÷10";
                let expectedResult: Double = 9 / 10
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testTwoOperators") {
                let testString = "11+12+";
                let expectedResult: Double = 23;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testDivisionByZero") {
                let testString = "1÷0";
                let expectedResult: Double = Double.infinity;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testDecimals") {
                let testString = "50.05";
                let expectedResult: Double = 50.05;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testDecimalsWithOperators") {
                let testString = "50+.0089";
                let expectedResult: Double = 50.0089;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testMultiplicationII") {
                let testString = "110x";
                let expectedResult: Double = 110;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testCommas") {
                let testString = "5,000.00";
                let expectedResult: Double = 5000;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testCurrencySign") {
                let testString = "$5";
                let expectedResult: Double = 5;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
                }
            
            it("testNilString") {
                let testString : String? = nil;
                let expectedResult = 0.0;
                
                persistenceService.expression.swap(testString);
                
                expect(mathParserService.baseAmount.value).toEventually(equal(expectedResult));
            }
        }
    }
}


