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
            
            let mathParserService: MathParserService = MathParserService();
            
            it("testNoOperator") {
                let testString = "1";
                let expectedResult: Double = 1;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testEmptyString") {
                let testString = "";
                let expectedResult: Double = 0;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testOneOperandOneOperator") {
                let testString = "2+";
                let expectedResult: Double = 2;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testAddition") {
                let testString = "3+4";
                let expectedResult: Double = 7;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testSubtraction") {
                let testString = "5−6";
                let expectedResult: Double = -1;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testMultiplication") {
                let testString = "7×8";
                let expectedResult: Double = 56;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testDivision") {
                let testString = "9÷10";
                let expectedResult: Double = 9 / 10
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testTwoOperators") {
                let testString = "11+12+";
                let expectedResult: Double = 23;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testDivisionByZero") {
                let testString = "1÷0";
                let expectedResult: Double = Double.infinity;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testDecimals") {
                let testString = "50.05";
                let expectedResult: Double = 50.05;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testDecimalsWithOperators") {
                let testString = "50+.0089";
                let expectedResult: Double = 50.0089;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testMultiplicationII") {
                let testString = "110x";
                let expectedResult: Double = 110;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testCommas") {
                let testString = "5,000.00";
                let expectedResult: Double = 5000;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
            
            it("testCurrencySign") {
                let testString = "$5";
                let expectedResult: Double = 5;
                
                let result = mathParserService.resultWithExpression(testString);
                expect(result) == expectedResult;
                }
        }
    }
}


