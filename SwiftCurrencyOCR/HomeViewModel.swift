//
//  HomeViewModel.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/13/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

public protocol HomeViewModelProtocol {
    var isArrowPointingLeft: MutableProperty<Bool> { get }
    var leftCurrencyText: MutableProperty<String> { get }
    var rightCurrencyText: MutableProperty<String> { get }
    var leftCurrencyViewModel : MutableProperty<CurrencyViewModelProtocol> { get }
    var rightCurrencyViewModel : MutableProperty<CurrencyViewModelProtocol> { get }
    var baseCurrency : MutableProperty<CurrencyViewModelProtocol> { get }
    var otherCurrency : MutableProperty<CurrencyViewModelProtocol> { get }
    var baseAmount : MutableProperty<Double> { get }
    var leftCurrencySelectorViewModel : MutableProperty<CurrencySelectorViewModelProtocol> { get }
    var rightCurrencySelectorViewModel : MutableProperty<CurrencySelectorViewModelProtocol> { get }
    var currencyOverviewViewModel : MutableProperty<CurrencyOverviewViewModelProtocol> { get }
    
    func toggleArrow();
    func setExpression();
    
}

protocol HomeViewModelInputProtocol {
    var toggleArrowSignal: Signal<Bool, Result.NoError> { get }
    var expressionSignal: Signal<String, Result.NoError> { get }
}

public protocol CurrencySelectorViewModelProtocol {
    
}

public protocol CurrencyOverviewViewModelProtocol {
    
}

public class HomeViewModel {
    private var input : HomeViewModelInputProtocol;
    private var persistenceService : PersistenceServiceProtocol;
    private var conversionService : ConversionServiceProtocol;
    private var mathParserService : MathParserServiceProtocol;
    
    public private(set) var isArrowPointingLeft: MutableProperty<Bool>;
    public private(set) var leftCurrencyText: MutableProperty<String>;
    public private(set) var rightCurrencyText: MutableProperty<String>;
 //   public private(set) var leftCurrencyViewModel : MutableProperty<CurrencyViewModelProtocol>;
//    public private(set) var rightCurrencyViewModel : MutableProperty<CurrencyViewModelProtocol>;
//    public private(set) var baseCurrency : MutableProperty<CurrencyViewModelProtocol>;
//    public private(set) var otherCurrency : MutableProperty<CurrencyViewModelProtocol>;
    public private(set) var baseAmount : MutableProperty<Double>;
//    public private(set) var leftCurrencySelectorViewModel : MutableProperty<CurrencySelectorViewModelProtocol>;
//    public private(set) var rightCurrencySelectorViewModel : MutableProperty<CurrencySelectorViewModelProtocol>;
//    public private(set) var currencyOverviewViewModel : MutableProperty<CurrencyOverviewViewModelProtocol>;
    
    let decimalFormatter : NSNumberFormatter;
    let currencyFormatter : NSNumberFormatter;
    
    convenience init(input : HomeViewModelInputProtocol) {
        self.init(input: input, persistenceService : PersistenceService(), conversionService : ConversionService(), mathParserService : MathParserService())
    }
    
    init(input : HomeViewModelInputProtocol, persistenceService : PersistenceServiceProtocol, conversionService : ConversionServiceProtocol, mathParserService : MathParserServiceProtocol) {
        self.input = input;
        self.persistenceService = persistenceService;
        self.conversionService = conversionService;
        self.mathParserService = mathParserService;
        
        self.decimalFormatter = NSNumberFormatter();
        self.decimalFormatter.numberStyle = .DecimalStyle;
        self.decimalFormatter.groupingSeparator = "";
        
        self.currencyFormatter = NSNumberFormatter();
        self.currencyFormatter.numberStyle = .CurrencyStyle;

        self.isArrowPointingLeft = MutableProperty<Bool>.init(true);
        self.leftCurrencyText = MutableProperty<String>.init("");
        self.rightCurrencyText = MutableProperty<String>.init("");
        self.baseAmount = MutableProperty<Double>.init(0);
   //     self.leftCurrencyViewModel = MutableProperty<CurrencyViewModelProtocol>.init();
   //     self.rightCurrencyViewModel = MutableProperty<CurrencyViewModelProtocol>.init();
        
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self.isArrowPointingLeft <~ self.persistenceService.isArrowPointingLeft.signal;
        self.leftCurrencyText <~ self.leftCurrencyTextSignal();
        self.rightCurrencyText <~ self.rightCurrencyTextSignal();
        self.baseAmount <~ self.mathParserService.baseAmount;
    }
    
//    private func leftCurrencyViewModelSignal() -> Signal<CurrencyViewModel, Result.NoError> {
//        let signal = self.leftCurrencySignal().map { (currency : Currency) -> CurrencyViewModel in
//            return CurrencyViewModel.init(currency: currency);
//        }
//    }
//    
//    private func rightCurrencyViewModelSignal() -> Signal<CurrencyViewModel, Result.NoError> {
//        let signal = self.rightCurrencySignal().map { (currency : Currency) -> CurrencyViewModel in
//            return CurrencyViewModel.init(currency: currency);
//        }
//    }

    
    private func leftCurrencyTextSignal() -> Signal<String, Result.NoError> {
        let signal = self.combinedTextSignal().map(self.reduceLeftStrings);
        return signal;
    }
    
    private func rightCurrencyTextSignal() -> Signal<String, Result.NoError> {
        let signal = self.combinedTextSignal().map(self.reduceRightStrings);
        return signal;
    }
    
    private func reduceLeftStrings(leftString : String, rightString : String, isArrowPointingLeft : Bool) -> String {
        return self.reduceLeftClosure(leftString as AnyObject, rightObject: rightString as AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! String;
    }
    
    private func reduceRightStrings(leftString : String, rightString : String, isArrowPointingLeft : Bool) -> String {
        return self.reduceRightClosure(leftString as AnyObject, rightObject: rightString as AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! String;
    }
    
    private func reduceLeftClosure(leftObject : AnyObject, rightObject : AnyObject, isArrowPointingLeft : Bool) -> AnyObject {
        if(isArrowPointingLeft) {
            return leftObject;
        }
        else
        {
            return rightObject;
        }
    }
    
    private func reduceRightClosure(leftObject : AnyObject, rightObject : AnyObject, isArrowPointingLeft : Bool) -> AnyObject {
        if(isArrowPointingLeft) {
            return rightObject;
        }
        else
        {
            return leftObject;
        }
    }
    
    
    private func combinedTextSignal() -> Signal<(String, String, Bool), Result.NoError> {
        let signal = combineLatest(self.baseTextSignal(), self.otherTextSignal(), self.persistenceService.isArrowPointingLeft.signal);
        return signal;
    }
    
    private func baseTextSignal() -> Signal<String, Result.NoError> {
        return self.baseAmount.signal.map { (baseAmount : Double) in
            return self.decimalFormatter.stringFromNumber(baseAmount)!;
        }
    }
    
    private func otherTextSignal() -> Signal<String, Result.NoError> {
        return self.conversionService.otherAmount.signal.map { (otherAmount : Double) in
            return self.currencyFormatter.stringFromNumber(otherAmount)!;
        }
    }
    
    
    
    
}
