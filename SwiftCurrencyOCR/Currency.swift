//
//  Currency.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/17/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import Parse
import ReactiveCocoa
import enum Result.NoError

let kCurrencyClassName = "Currency";
let kCodeKey = "code";

public protocol CurrencyProtocol {
    var nameProperty: MutableProperty<String> { get }
    var codeProperty: MutableProperty<String> { get }
    var flagIconProperty : MutableProperty<PFFile?> { get }
    func == (left: CurrencyProtocol, right: CurrencyProtocol) -> Bool
}

public class PFCurrencyWrapper: CurrencyProtocol {
    private var pfCurrency : PFCurrency;
    
    public private(set) var nameProperty: MutableProperty<String>
    public private(set) var codeProperty: MutableProperty<String>
    public private(set) var flagIconProperty: MutableProperty<PFFile?>
    
    init(pfCurrency : PFCurrency) {
        self.pfCurrency = pfCurrency;
        
        self.nameProperty = MutableProperty<String>.init(self.pfCurrency.name);
        self.codeProperty = MutableProperty<String>.init(self.pfCurrency.code);
        self.flagIconProperty = MutableProperty<PFFile?>.init(self.pfCurrency.flagIcon);
    }
}

public class Currency: CurrencyProtocol, CustomDebugStringConvertible {
    
    public private(set) var nameProperty: MutableProperty<String>
    public private(set) var codeProperty: MutableProperty<String>
    public private(set) var flagIconProperty: MutableProperty<PFFile?>
    
    init() {
        self.nameProperty = MutableProperty<String>.init("");
        self.codeProperty = MutableProperty<String>.init("");
        self.flagIconProperty = MutableProperty<PFFile?>.init(nil);
    }
    
    public static func currencyWithCode(code : String) -> Currency {
        let currency = Currency();
        currency.codeProperty.swap(code);
        return currency;
    }
    
    public var description : String {
        return self.debugDescription;
    }
    
    public var debugDescription : String {
        return String.init(format: "%@ ( %@ )", self.codeProperty.value, self.nameProperty.value);
    }
}

public func == (left: CurrencyProtocol, right: CurrencyProtocol) -> Bool {
    return (left.codeProperty.value == right.codeProperty.value) && (left.nameProperty.value == right.nameProperty.value)
}

public func != (left: CurrencyProtocol, right: CurrencyProtocol) -> Bool {
    return !(left == right);
}
