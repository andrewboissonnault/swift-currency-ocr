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
    var isArrowPointingLeft: AnyProperty<Bool> { get }
    var leftCurrencyText: AnyProperty<String> { get }
    var rightCurrencyText: AnyProperty<String> { get }
    var leftCurrencyViewModel : AnyProperty<CurrencyViewModelProtocol> { get }
    var rightCurrencyViewModel : AnyProperty<CurrencyViewModelProtocol> { get }
    var baseCurrency : AnyProperty<CurrencyViewModelProtocol> { get }
    var otherCurrency : AnyProperty<CurrencyViewModelProtocol> { get }
    var baseAmount : AnyProperty<Double> { get }
    var leftCurrencySelectorViewModel : AnyProperty<CurrencySelectorViewModelProtocol> { get }
    var rightCurrencySelectorViewModel : AnyProperty<CurrencySelectorViewModelProtocol> { get }
    var currencyOverviewViewModel : AnyProperty<CurrencyOverviewViewModelProtocol> { get }
    
    func toggleArrow();
    var expression: MutableProperty<String> { get }
}

public protocol CurrencySelectorViewModelProtocol {
    
}

public protocol CurrencyOverviewViewModelProtocol {
    
}

public class HomeViewModel {
    private var persistenceService : PersistenceServiceProtocol;
    private var textService : TextServiceProtocol;
    private var currencyService : CurrencyServiceProtocol;
    
    public private(set) var isArrowPointingLeft: AnyProperty<Bool>;
    public private(set) var leftCurrencyText: AnyProperty<String>;
    public private(set) var rightCurrencyText: AnyProperty<String>;
    public var leftCurrencyViewModel : AnyProperty<CurrencyViewModelProtocol> {
        return AnyProperty(_leftCurrencyViewModel);
    }
    internal private(set) var _leftCurrencyViewModel : MutableProperty<CurrencyViewModelProtocol>;
    public var rightCurrencyViewModel : AnyProperty<CurrencyViewModelProtocol> {
        return AnyProperty(_rightCurrencyViewModel);
    }
    internal private(set) var _rightCurrencyViewModel : MutableProperty<CurrencyViewModelProtocol>;
//    public private(set) var baseCurrency : MutableProperty<CurrencyViewModelProtocol>;
//    public private(set) var otherCurrency : MutableProperty<CurrencyViewModelProtocol>;
 //   public private(set) var baseAmount : MutableProperty<Double>;
//    public private(set) var leftCurrencySelectorViewModel : MutableProperty<CurrencySelectorViewModelProtocol>;
//    public private(set) var rightCurrencySelectorViewModel : MutableProperty<CurrencySelectorViewModelProtocol>;
//    public private(set) var currencyOverviewViewModel : MutableProperty<CurrencyOverviewViewModelProtocol>;
    
    public private(set) var expression: MutableProperty<String>;
    
    convenience init() {
        self.init(persistenceService : PersistenceService(), currencyService : CurrencyService(), textService : TextService())
    }
    
    init(persistenceService : PersistenceServiceProtocol, currencyService : CurrencyServiceProtocol, textService : TextServiceProtocol) {
        self.persistenceService = persistenceService;
        self.textService = textService;
        self.currencyService = currencyService;

        self.isArrowPointingLeft = AnyProperty(self.persistenceService.isArrowPointingLeft);
        self.leftCurrencyText = self.textService.leftCurrencyText;
        self.rightCurrencyText = self.textService.rightCurrencyText;
        self._leftCurrencyViewModel = MutableProperty<CurrencyViewModelProtocol>.init(CurrencyViewModel(currency: Currency()));
        self._rightCurrencyViewModel = MutableProperty<CurrencyViewModelProtocol>.init(CurrencyViewModel(currency: Currency()));
        self.expression = MutableProperty<String>.init("");
        
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self._leftCurrencyViewModel <~ self.leftCurrencyViewModelSignal();
        self._rightCurrencyViewModel <~ self.rightCurrencyViewModelSignal();
        self.persistenceService.expression <~ self.expression;
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
    
    public func toggleArrow() {
        self.persistenceService.isArrowPointingLeft.swap(!self.persistenceService.isArrowPointingLeft.value);
    }
    
}
