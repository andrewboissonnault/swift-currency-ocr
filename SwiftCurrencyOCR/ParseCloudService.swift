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

protocol ParseCloudServiceProtocol {
}

public class BaseParseCloudService : ParseCloudServiceProtocol {
}

public class ParseCloudService: BaseParseCloudService {
    
    private func setupBindings()
    {
        
    }
    
    private static func requestCurrencyData(block : PFIdResultBlock) {
        PFCloud.callFunctionInBackground(kRequestCurrencyRatesAPI, withParameters:nil, cachePolicy:PFCachePolicy.NetworkElseCache, block: block);
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
