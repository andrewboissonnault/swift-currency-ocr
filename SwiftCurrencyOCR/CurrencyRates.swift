//
//  CurrencyRates.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/31/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import Parse

let kCurrencyRatesClassName = "CurrencyData";

public protocol CurrencyRatesProtocol {
    var referenceCurrencyCode: String { get set }
    var rates : NSDictionary { get }
    var createdAt : NSDate? { get }
    func rate(code : String) -> Double;
}

public class PFCurrencyRates: PFObject, PFSubclassing, CurrencyRatesProtocol {
    public var rates: NSDictionary = NSDictionary();
    public var referenceCurrencyCode: String = "";
    
    public class func parseClassName() -> String {
        return kCurrencyRatesClassName;
    }
    
    public func rate(code: String) -> Double {
        return sharedRate(code, rates: self.rates);
    }
}

public class CurrencyRates: CurrencyRatesProtocol {
    public var rates: NSDictionary = NSDictionary();
    public var referenceCurrencyCode: String = "";
    public var createdAt: NSDate?;
    
    public func rate(code: String) -> Double {
        return sharedRate(code, rates : self.rates);
    }
}

public func sharedRate(code: String, rates : NSDictionary) -> Double {
    return rates.objectForKey(code)!.doubleValue!;
}

public func == (left: CurrencyRatesProtocol, right: CurrencyRatesProtocol) -> Bool {
    return (left.referenceCurrencyCode == right.referenceCurrencyCode) && (left.rates == right.rates)
}

public func != (left: CurrencyRatesProtocol, right: CurrencyRatesProtocol) -> Bool {
    return !(left == right);
}
