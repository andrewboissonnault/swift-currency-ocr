//
//  MathParserService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/22/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

protocol MathParserServiceProtocol {
    var baseAmount: AnyProperty<Double> { get }
}

public class BaseMathParserService : MathParserServiceProtocol {
    var baseAmount: AnyProperty<Double> {
        return AnyProperty(_baseAmount);
    }
    internal private(set) var _baseAmount = MutableProperty<Double>.init(1.0);
}

public class MathParserService : BaseMathParserService {
    private let kAdditionOperator = "+";
    private let kSubtractionOperator = "−";
    private let kMultiplicationOperator = "×";
    private let kDivisionOperator = "÷";
    
    private var persistenceService: PersistenceServiceProtocol
    
    convenience override init() {
        self.init(persistenceService: PersistenceService());
    }
    
    init(persistenceService : PersistenceServiceProtocol) {
        self.persistenceService = persistenceService;
        super.init();
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self._baseAmount <~ self.baseAmountSignal();
    }
    
    private func baseAmountSignal() -> Signal<Double, Result.NoError> {
        self.persistenceService.expression.signal.observeNext { (text : String) -> () in
            //
        }
        let signal = self.persistenceService.expression.signal.map(self.resultWithExpression);
        return signal;
    }
    
    private func resultWithExpression(expression : String?) -> Double {
        if(expression == nil) {
            return 0;
        }
        else
        {
            return self.parseUnwrappedExpression(expression!);
        }
    }
    
    private func parseUnwrappedExpression(expression : String) -> Double {
        let strippedExpression = self.removeSeparatorsFromExpression(expression);
        let operands = self.parseOperands(strippedExpression);
        let theOperator = self.parseOperator(strippedExpression);
        let result = self.calculateResult(operands, theOperator: theOperator);
        return result;
    }
    
    private func removeSeparatorsFromExpression(expression : String) -> String {
        let strippedExpression = expression.stringByReplacingOccurrencesOfString(self.groupingSeparator(), withString: "");
        return strippedExpression;
    }
    
    private func parseOperands(expression : String) -> Array<Double> {
        let splitText = expression.componentsSeparatedByCharactersInSet(self.operandCharacterSet().invertedSet);
        let filteredText = self.filterEmptyStrings(splitText);
        let operands = self.mapStringsToDouble(filteredText);
        return operands;
    }
    
    private func parseOperator(expression : String) -> String? {
        let splitText = expression.componentsSeparatedByCharactersInSet(self.operatorCharacterSet().invertedSet);
        let operators = self.filterEmptyStrings(splitText);
        return operators.first;
    }
    
    private func calculateResult(operands : Array<Double>, theOperator : String?) -> Double {
        if(operands.count == 0) {
            return 0;
        }
        if(operands.count == 1) {
            return operands.first!;
        }
        let operandOne = operands.first!;
        let operandTwo = operands[1];
        
        if(theOperator == kAdditionOperator)
        {
            return operandOne + operandTwo;
        }
        else if(theOperator == kSubtractionOperator)
        {
            return operandOne - operandTwo;
        }
        else if(theOperator == kMultiplicationOperator)
        {
            return operandOne * operandTwo;
        }
        else if(theOperator == kDivisionOperator)
        {
            return operandOne / operandTwo;
        }
        else {
            return operandOne;
        }
    }
    
    private func mapStringsToDouble(strings : Array<String>) -> Array<Double> {
        return strings.map { (string: String) -> Double in
            return Double.init(string)!;
        };
    }
    
    private func filterEmptyStrings(strings : Array<String>) -> Array<String> {
        return strings.filter{ (string: String) -> Bool in
            let strippedText = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
            return strippedText != "";
        };
    }
    
    private func operandCharacterSet() -> NSCharacterSet {
        let operandSet = NSCharacterSet.decimalDigitCharacterSet().mutableCopy();
        operandSet.formUnionWithCharacterSet(self.seperatorCharacterSet());
        return operandSet as! NSCharacterSet;
    }
    
    private func operatorCharacterSet() -> NSCharacterSet {
        return NSCharacterSet.init(charactersInString: "+−×÷");
    }
    
    private func seperatorCharacterSet() -> NSCharacterSet {
        return NSCharacterSet.init(charactersInString: self.groupingSeparator() + self.decimalSeparator());
    }
    
    private func groupingSeparator() -> String {
        let currenctLocale = NSLocale.currentLocale();
        let separator = currenctLocale.objectForKey(NSLocaleGroupingSeparator) as! String;
        return separator;
    }
    
    private func decimalSeparator() -> String {
        let currenctLocale = NSLocale.currentLocale();
        let separator = currenctLocale.objectForKey(NSLocaleDecimalSeparator) as! String;
        return separator;
    }
}