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