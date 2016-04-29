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

class QueryPFCurrencyServiceMock : QueryPFCurrencyServiceProtocol {
    func currencySignalProducer(code : String?) -> SignalProducer<CurrencyProtocol?, NoError> {
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

class CurrencyRatesServiceMock : BaseCurrencyRatesService { }

class CurrencyRateServiceMock : BaseCurrencyRateService { }

class CurrencyServiceMock : BaseCurrencyService { }

class TextServiceMock : BaseTextService { }

class UserPreferencesServiceMock : BaseUserPreferencesService { }

class PersistenceServiceMock : PersistenceServiceProtocol {
    var leftCurrency: MutableProperty<CurrencyProtocol> = MutableProperty<CurrencyProtocol>.init(Currency());
    var rightCurrency: MutableProperty<CurrencyProtocol> = MutableProperty<CurrencyProtocol>.init(Currency());
    var expression: MutableProperty<String> = MutableProperty<String>.init("");
    var isArrowPointingLeft: MutableProperty<Bool> = MutableProperty<Bool>.init(false);
}

class MathParserServiceMock : BaseMathParserService { }

class ConversionServiceMock : BaseConversionService { }