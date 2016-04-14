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
    var otherAmount: MutableProperty<Double> { get }
}

public class ConversionService: ConversionServiceProtocol {
    private var rateService: CurrencyRateServiceProtocol
    private var mathParserService : MathParserServiceProtocol
    
    public private(set) var otherAmount: MutableProperty<Double>
    
    convenience init() {
        self.init(rateService: CurrencyRateService(), mathParserService : MathParserService());
    }
    
    init(rateService : CurrencyRateServiceProtocol, mathParserService : MathParserServiceProtocol) {
        self.rateService = rateService;
        self.mathParserService = mathParserService;
        
        self.otherAmount = MutableProperty<Double>.init(1.0);
        
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self.otherAmount <~ self.otherAmountSignal();
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