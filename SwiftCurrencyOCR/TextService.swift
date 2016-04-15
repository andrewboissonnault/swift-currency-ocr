//
//  TextService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/14/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Parse
import enum Result.NoError

protocol TextServiceProtocol {
    var leftCurrencyText: AnyProperty<String> { get }
    var rightCurrencyText: AnyProperty<String> { get }
}

public class BaseTextService: TextServiceProtocol {
    var leftCurrencyText: AnyProperty<String> {
        return AnyProperty(_leftCurrencyText);
    }
    internal var _leftCurrencyText = MutableProperty<String>.init("");
    var rightCurrencyText: AnyProperty<String> {
        return AnyProperty(_rightCurrencyText);
    }
    internal var _rightCurrencyText = MutableProperty<String>.init("");
}

public class TextService: BaseTextService {
    private var persistenceService : PersistenceServiceProtocol;
    private var conversionService : ConversionServiceProtocol;
    private var mathParserService : MathParserServiceProtocol;
    
    let decimalFormatter : NSNumberFormatter;
    let currencyFormatter : NSNumberFormatter;
    
    convenience override init() {
        self.init(persistenceService : PersistenceService(), conversionService : ConversionService(), mathParserService : MathParserService());
    }
    
    init(persistenceService : PersistenceServiceProtocol, conversionService : ConversionServiceProtocol, mathParserService : MathParserServiceProtocol) {
        self.persistenceService = persistenceService
        self.conversionService = conversionService;
        self.mathParserService = mathParserService;
        
        self.decimalFormatter = NSNumberFormatter();
        self.decimalFormatter.numberStyle = .DecimalStyle;
        self.decimalFormatter.groupingSeparator = "";
        
        self.currencyFormatter = NSNumberFormatter();
        self.currencyFormatter.numberStyle = .CurrencyStyle;
        
        super.init();
        
        self.setupBindings();
    }
    
    private func setupBindings() {
        self._leftCurrencyText <~ self.leftCurrencyTextSignal();
        self._rightCurrencyText <~ self.rightCurrencyTextSignal();
    }
    
    private func leftCurrencyTextSignal() -> Signal<String, Result.NoError> {
        let signal = self.combinedTextSignal().map(self.reduceLeftStrings);
        return signal;
    }
    
    private func rightCurrencyTextSignal() -> Signal<String, Result.NoError> {
        let signal = self.combinedTextSignal().map(self.reduceRightStrings);
        return signal;
    }
    
    private func combinedTextSignal() -> Signal<(String, String, Bool), Result.NoError> {
        let signal = combineLatest(self.baseTextSignal(), self.otherTextSignal(), self.persistenceService.isArrowPointingLeft.signal);
        return signal;
    }
    
    private func baseTextSignal() -> Signal<String, Result.NoError> {
        return self.mathParserService.baseAmount.signal.map { (baseAmount : Double) in
            return self.decimalFormatter.stringFromNumber(baseAmount)!;
        }
    }
    
    private func otherTextSignal() -> Signal<String, Result.NoError> {
        return self.conversionService.otherAmount.signal.map { (otherAmount : Double) in
            return self.currencyFormatter.stringFromNumber(otherAmount)!;
        }
    }
    
    private func reduceLeftStrings(left : String, right : String, isArrowPointingLeft : Bool) -> String {
        return reduceLeft(left as AnyObject, right: right as AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! String;
    }
    
    private func reduceRightStrings(left : String, right : String, isArrowPointingLeft : Bool) -> String {
        return reduceRight(left as AnyObject, right: right as AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! String;
    }
}

