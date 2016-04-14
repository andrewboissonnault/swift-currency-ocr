//
//  Mocks.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/31/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

class CurrencyServiceMock : CurrencyService {
    override func currencySignalProducer(code : String?) -> SignalProducer<CurrencyProtocol, NoError> {
        return SignalProducer {
            sink, disposable in
            if code != nil
            {
                let currency = buildCurrency(code!);
                sink.sendNext(currency);
            }
        }
    }
}

func buildCurrency(code: String) -> CurrencyProtocol {
    let baseCurrency: CurrencyProtocol = Currency();
    baseCurrency.codeProperty.swap(code);
    baseCurrency.nameProperty.swap( code + "name" );
    return baseCurrency;
}

class CurrencyRatesServiceMock : CurrencyRatesServiceProtocol {
    var rates: MutableProperty<CurrencyRatesProtocol>;
    
    init(rates: CurrencyRatesProtocol) {
        self.rates = MutableProperty<CurrencyRatesProtocol>.init(rates);
    }
}

class CurrencyRateServiceMock : CurrencyRateServiceProtocol {
    var rate: MutableProperty<Double> = MutableProperty<Double>.init(1.0);
}

class PersistenceServiceMock : PersistenceService {
    init () {
        super.init(userPreferencesService: UserPreferencesService(), currencyService: CurrencyServiceMock());
    }
}

class MathParserServiceMock : MathParserServiceProtocol {
    var baseAmount: MutableProperty<Double> = MutableProperty<Double>.init(1.0);
}