//
//  ConversionService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/12/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

protocol ConversionServiceProtocol {
    var otherAmount: AnyProperty<Double> { get }
}

public class BaseConversionService : ConversionServiceProtocol {
    var otherAmount: AnyProperty<Double> {
        return AnyProperty(_otherAmount);
    }
    internal var _otherAmount = MutableProperty<Double>.init(1.0);
}

public class ConversionService: BaseConversionService {
    private var rateService: CurrencyRateServiceProtocol
    private var mathParserService : MathParserServiceProtocol
    
    convenience override init() {
        self.init(rateService: CurrencyRateService(), mathParserService : MathParserService());
    }
    
    init(rateService : CurrencyRateServiceProtocol, mathParserService : MathParserServiceProtocol) {
        self.rateService = rateService;
        self.mathParserService = mathParserService;
        super.init();
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self._otherAmount <~ self.otherAmountSignal();
    }
    
    private func otherAmountSignal() -> Signal<Double, Result.NoError> {
        let combinedSignal = combineLatest(self.rateService.rate.signal, self.mathParserService.baseAmount.signal);
        let signal = combinedSignal.map { (rate : Double, amount : Double) -> (Double) in
            return ConversionService.calculateAmount(rate, amount: amount);
        }
        return signal;
    }
    
    private static func calculateAmount(rate : Double, amount : Double) -> Double {
        return amount * rate;
    }
    
}