//
//  ParseCloudService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/16/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

//
//  CurrencyRateService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/9/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError
import Parse

let kRequestCurrencyRatesAPI = "requestCurrencyRates";
let kCurrencyRatesKey = "currencyRates";
let kCurrenciesKey = "currencies";

protocol ParseCloudServiceProtocol {
    var rates : AnyProperty<CurrencyRatesProtocol?> { get };
    var currencies : AnyProperty<Array<PFCurrency>?> { get };
}

public class BaseParseCloudService : ParseCloudServiceProtocol {
    var rates: AnyProperty<CurrencyRatesProtocol?> {
        return AnyProperty(_rates);
    }
    internal private(set) var _rates = MutableProperty<CurrencyRatesProtocol?>.init(nil);
    var currencies: AnyProperty<Array<PFCurrency>?> {
        return AnyProperty(_currencies);
    }
    internal private(set) var _currencies = MutableProperty<Array<PFCurrency>?>.init(nil);
}

public class ParseCloudService: BaseParseCloudService {
    internal private(set) var _results = MutableProperty<(PFCurrencyRates?, Array<PFCurrency>?)>.init((nil, nil));
    
    override init() {
        super.init();
        self.setupBindings();
    }
    
    private func setupBindings()
    {
    //    self._rates <~ self.cachedCurrencyRatesSignalProducer();
    //    self._currencies <~ self.cachedCurrenciesSignalProducer();
        self._results <~ self.requestCurrencyDataSignalProducer();
        self._rates <~ self._results.signal.map({ (rates : PFCurrencyRates?, _) -> PFCurrencyRates? in
            return rates;
        })
        self._currencies <~ self._results.signal.map({ ( _, currencies : Array<PFCurrency>?) -> Array<PFCurrency>? in
            return currencies;
        })
    }
    
    private func cachedCurrencyRatesSignalProducer() -> SignalProducer<PFCurrencyRates?, Result.NoError> {
        return SignalProducer {
            sink, disposable in
            ParseCloudService.requestCachedCurrencyRatesInBackground { (rates : AnyObject?, error : NSError?) -> Void in
                let returnValue = rates as! PFCurrencyRates?;
                sink.sendNext(returnValue);
            }
        }
    }
    
    private func cachedCurrenciesSignalProducer() -> SignalProducer<Array<PFCurrency>?, Result.NoError> {
        return SignalProducer {
            sink, disposable in
            ParseCloudService.requestCachedCurrenciesInBackground { (currencies : Array<PFObject>?, error : NSError?) -> Void in
                let returnValue = currencies as! Array<PFCurrency>?;
                sink.sendNext(returnValue);
            }
        }
    }
    
    private func shouldFetchCurrencyDataSignal() -> Signal<Bool, Result.NoError> {
        return self.rates.signal.map(self.shouldFetchCurrencyData);
    }
    
    private func shouldFetchCurrencyData(rates : CurrencyRatesProtocol?) -> Bool {
        if(rates == nil) {
            return false;
        }
        let createdAt = self.rates.value!.createdAt;
        return (createdAt == nil) || createdAt!.hoursSince() > 1;
    }
    
    private func requestCurrencyDataSignalProducer() -> SignalProducer<(PFCurrencyRates?, Array<PFCurrency>?), Result.NoError> {
        return SignalProducer {
            sink, disposable in
            ParseCloudService.requestCurrencyData { (result : AnyObject?, error : NSError?) -> Void in
                let dictionary = result as! NSDictionary;
                let rates  = ParseCloudService.ratesFromResult(dictionary);
                let currencies = ParseCloudService.currenciesFromResult(dictionary);
                let returnValue : (PFCurrencyRates?, Array<PFCurrency>?) = (rates, currencies);
                sink.sendNext(returnValue);
            }
        }
    }
    
    private static func ratesFromResult(result : NSDictionary) -> PFCurrencyRates?{
        var rates : PFCurrencyRates? = nil;
        if((result.objectForKey(kCurrencyRatesKey)) != nil) {
            let ratesObject = result.objectForKey(kCurrencyRatesKey);
            rates = ratesObject as! PFCurrencyRates?
            rates!.pinInBackground();
        }
        return rates;
    }
    
    private static func currenciesFromResult(result : NSDictionary) -> Array<PFCurrency>? {
        var currencies : Array<PFCurrency>? = nil;
        if((result.objectForKey(kCurrenciesKey)) != nil) {
            currencies = result.objectForKey(kCurrenciesKey) as? Array<PFCurrency>;
            PFObject.pinAllInBackground(currencies);
        }
        return currencies;
    }
    
    private static func requestCurrencyData(block : PFIdResultBlock) {
        PFCloud.callFunctionInBackground(kRequestCurrencyRatesAPI, withParameters:nil, block: block);
    }
    
    private static func requestCachedCurrencyRatesInBackground(block : PFIdResultBlock) {
        let query = PFCurrencyRates.query();
        query?.fromLocalDatastore();
        query?.getFirstObjectInBackgroundWithBlock(block);
    }
    
    private static func requestCachedCurrenciesInBackground(block : PFQueryArrayResultBlock) {
        let query = PFCurrency.query();
        query?.fromLocalDatastore();
        query?.orderByAscending("code");
        query?.findObjectsInBackgroundWithBlock(block);
    }
    
}
