//
//  QueryPFCurrencyService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/14/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import ReactiveCocoa
import Parse
import enum Result.NoError

protocol QueryPFCurrencyServiceProtocol {
    func currencySignalProducer(code : String?) -> SignalProducer<CurrencyProtocol?, NoError>
}

public class QueryPFCurrencyService: QueryPFCurrencyServiceProtocol {

    public func currencySignalProducer(code : String?) -> SignalProducer<CurrencyProtocol?, NoError> {
        return SignalProducer {
            sink, disposable in
            if(code != nil && code != "")
            {
                let query = PFCurrency.query();
                query?.fromLocalDatastore();
                query?.whereKey(kCodeKey, equalTo:code!);
                query?.getFirstObjectInBackgroundWithBlock({ (object : PFObject?, error : NSError?) -> Void in
                    if error != nil {
                        //sink.sendFailed(error!);
                         sink.sendNext(nil);
                    }
                    else if let currency = object as? PFCurrency {
                        sink.sendNext(currency);
                    }
                })
            }
        }
}
}
