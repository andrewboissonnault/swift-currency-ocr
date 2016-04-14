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
    var toggleArrow: MutableProperty<Bool> { get }
    var expression: MutableProperty<String> { get }
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
    private var currencyService : CurrencyServiceProtocol;
    
    public private(set) var isArrowPointingLeft: MutableProperty<Bool>;
    public private(set) var leftCurrencyText: MutableProperty<String>;
    public private(set) var rightCurrencyText: MutableProperty<String>;
    public private(set) var leftCurrencyViewModel : MutableProperty<CurrencyViewModelProtocol>;
    public private(set) var rightCurrencyViewModel : MutableProperty<CurrencyViewModelProtocol>;
//    public private(set) var baseCurrency : MutableProperty<CurrencyViewModelProtocol>;
//    public private(set) var otherCurrency : MutableProperty<CurrencyViewModelProtocol>;
    public private(set) var baseAmount : MutableProperty<Double>;
//    public private(set) var leftCurrencySelectorViewModel : MutableProperty<CurrencySelectorViewModelProtocol>;
//    public private(set) var rightCurrencySelectorViewModel : MutableProperty<CurrencySelectorViewModelProtocol>;
//    public private(set) var currencyOverviewViewModel : MutableProperty<CurrencyOverviewViewModelProtocol>;
    
    let decimalFormatter : NSNumberFormatter;
    let currencyFormatter : NSNumberFormatter;
    
    convenience init(input : HomeViewModelInputProtocol) {
        self.init(input: input, persistenceService : PersistenceService(), conversionService : ConversionService(), mathParserService : MathParserService(), currencyService : CurrencyService())
    }
    
    init(input : HomeViewModelInputProtocol, persistenceService : PersistenceServiceProtocol, conversionService : ConversionServiceProtocol, mathParserService : MathParserServiceProtocol, currencyService : CurrencyServiceProtocol) {
        self.input = input;
        self.persistenceService = persistenceService;
        self.conversionService = conversionService;
        self.mathParserService = mathParserService;
        self.currencyService = currencyService;
        
        self.decimalFormatter = NSNumberFormatter();
        self.decimalFormatter.numberStyle = .DecimalStyle;
        self.decimalFormatter.groupingSeparator = "";
        
        self.currencyFormatter = NSNumberFormatter();
        self.currencyFormatter.numberStyle = .CurrencyStyle;

        self.isArrowPointingLeft = self.persistenceService.isArrowPointingLeft;
        self.leftCurrencyText = MutableProperty<String>.init("");
        self.rightCurrencyText = MutableProperty<String>.init("");
        self.baseAmount = MutableProperty<Double>.init(0);
        self.leftCurrencyViewModel = MutableProperty<CurrencyViewModelProtocol>.init(CurrencyViewModel(currency: Currency()));
        self.rightCurrencyViewModel = MutableProperty<CurrencyViewModelProtocol>.init(CurrencyViewModel(currency: Currency()));
        
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self.leftCurrencyText <~ self.leftCurrencyTextSignal();
        self.rightCurrencyText <~ self.rightCurrencyTextSignal();
        self.baseAmount <~ self.mathParserService.baseAmount;
        self.leftCurrencyViewModel <~ self.leftCurrencyViewModelSignal();
        self.rightCurrencyViewModel <~ self.rightCurrencyViewModelSignal();
    }
    
    private func leftCurrencyViewModelSignal() -> Signal<CurrencyViewModelProtocol, Result.NoError> {
        let signal = self.leftCurrencySignal().map(HomeViewModel.buildCurrencyViewModel);
        return signal;
    }
    
    private func rightCurrencyViewModelSignal() -> Signal<CurrencyViewModelProtocol, Result.NoError> {
        let signal = self.rightCurrencySignal().map(HomeViewModel.buildCurrencyViewModel);
        return signal;
    }
    
    private static func buildCurrencyViewModel(currency : CurrencyProtocol) -> CurrencyViewModelProtocol {
        return CurrencyViewModel.init(currency: currency);
    }
    
    private func leftCurrencySignal() -> Signal<CurrencyProtocol, Result.NoError> {
        let signal = self.persistenceService.leftCurrency.signal;
        return signal;
    }
    
    private func rightCurrencySignal() -> Signal<CurrencyProtocol, Result.NoError> {
        let signal = self.persistenceService.rightCurrency.signal;
        return signal;
    }
    
    private func leftCurrencyTextSignal() -> Signal<String, Result.NoError> {
        let signal = self.combinedTextSignal().map(self.reduceLeftStrings);
        return signal;
    }
    
    private func rightCurrencyTextSignal() -> Signal<String, Result.NoError> {
        let signal = self.combinedTextSignal().map(self.reduceRightStrings);
        return signal;
    }
    
    private func reduceLeftStrings(left : String, right : String, isArrowPointingLeft : Bool) -> String {
        return reduceLeft(left as AnyObject, right: right as AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! String;
    }
    
    private func reduceRightStrings(left : String, right : String, isArrowPointingLeft : Bool) -> String {
        return reduceRight(left as AnyObject, right: right as AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! String;
    }
    
    private func reduceLeftCurrencies(left : CurrencyProtocol, right : CurrencyProtocol, isArrowPointingLeft : Bool) -> CurrencyProtocol {
        return reduceLeft(left as! AnyObject, right: right as! AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! CurrencyProtocol;
    }
    
    private func reduceRightCurrencies(left : CurrencyProtocol, right : CurrencyProtocol, isArrowPointingLeft : Bool) -> CurrencyProtocol {
        return reduceRight(left as! AnyObject, right: right as! AnyObject, isArrowPointingLeft: isArrowPointingLeft) as! CurrencyProtocol;
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
