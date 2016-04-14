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

public class PFCurrency: PFObject, PFSubclassing, CurrencyProtocol, CustomDebugStringConvertible {
    
    private var name: String = ""
    private var code: String = ""
    private var flagIcon: PFFile = PFFile.init(data: NSData.init())!;
    private var shouldFetchFlagIcon: Bool = false
    private var flagImage: UIImage = UIImage.init()
    
    public private(set) var nameProperty: MutableProperty<String>
    public private(set) var codeProperty: MutableProperty<String>
    public private(set) var flagIconProperty: MutableProperty<PFFile?>
    
    override init() {
        self.nameProperty = MutableProperty<String>.init(name);
        self.codeProperty = MutableProperty<String>.init(code);
        self.flagIconProperty = MutableProperty<PFFile?>.init(flagIcon);
        super.init();
        self.setupBindings();
    }
    
    private func setupBindings() {
        self.willFetchCurrencySignal().subscribeNext { (_) -> Void in
            self.fetchInBackgroundWithBlock({ (_ , _) -> Void in
                self.updateExternalProperties();
            })
        }
    }
    
    private func updateExternalProperties() {
        self.nameProperty.swap(self.name);
        self.codeProperty.swap(self.code);
        self.flagIconProperty.swap(self.flagIcon);
    }
    
    public class func parseClassName() -> String {
        return kCurrencyClassName;
    }
    
    public override var description : String {
        return self.debugDescription;
    }
    
    public override var debugDescription : String {
        return String.init(format: "%@ ( %@ )", self.code, self.name);
    }
    
    private func willFetchCurrencySignal() -> RACSignal {
        let isDataAvailableSignal = RACObserve(self, keyPath: "dataAvailable");
        let shouldFetchFlagIconSignal = RACObserve(self, keyPath: "shouldFetchFlagIcon");
        let combinedSignal = RACSignal.combineLatest([isDataAvailableSignal, shouldFetchFlagIconSignal]);
        let shouldFetchSignal = combinedSignal.map {
            let tuple = $0 as! RACTuple
            let isDataAvailable = tuple.first as! Bool
            let shouldFetchFlagIcon = tuple.second as! Bool
            
            return isDataAvailable && shouldFetchFlagIcon;
        }
        let willFetchSignal = shouldFetchSignal.filter { (shouldFetch : AnyObject!) -> Bool in
            return shouldFetch.boolValue;
        }
        return willFetchSignal;
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
