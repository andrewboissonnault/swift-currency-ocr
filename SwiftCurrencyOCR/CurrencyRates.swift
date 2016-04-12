//
//  CurrencyRates.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/31/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import Parse

let kCurrencyRatesClassName = "CurrencyRates";

public protocol CurrencyRatesProtocol {
    var referenceCurrencyCode: String? { get set }
    var rates: NSDictionary? { get set }
}

public class PFCurrencyRates: PFObject, PFSubclassing, CurrencyRatesProtocol {
    public var rates: NSDictionary?;
    public var referenceCurrencyCode: String? = "";
    
    public class func parseClassName() -> String {
        return kCurrencyRatesClassName;
    }
}

public class CurrencyRates: CurrencyRatesProtocol {
    public var rates: NSDictionary?;
    public var referenceCurrencyCode: String? = "";
}

public func == (left: CurrencyRatesProtocol, right: CurrencyRatesProtocol) -> Bool {
    return (left.referenceCurrencyCode == right.referenceCurrencyCode) && (left.rates == right.rates)
}

public func != (left: CurrencyRatesProtocol, right: CurrencyRatesProtocol) -> Bool {
    return !(left == right);
}
