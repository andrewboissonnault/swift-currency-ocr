//
//  UserPreferencesService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/21/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation

public protocol UserPreferencesServiceProtocol {
    var baseCurrencyCode: String? { get set }
    var otherCurrencyCode: String? { get set }
    var expression: String? { get set }
    var isArrowPointingLeft: Bool { get set }
}

public class UserPreferencesService: UserPreferencesServiceProtocol {
    private let baseCurrencyCodeKey = "baseCurrencyCode"
    private let otherCurrencyCodeKey = "otherCurrencyCode"
    private let expressionKey = "expression"
    private let isArrowPointingLeftKey = "isArrowPointingLeft"
    
    private var defaults: NSUserDefaults;
    
    init(defaults: NSUserDefaults)
    {
        self.defaults = defaults;
    }
    
    convenience init()
    {
        self.init(defaults: NSUserDefaults.init());
    }
    
    public var baseCurrencyCode: String? {
        get {
            return self.defaults.stringForKey(baseCurrencyCodeKey);
        }
        set(currencyCode) {
            self.setObjectSafely(currencyCode, forKey: baseCurrencyCodeKey);
        }
    }
    
    public var otherCurrencyCode: String? {
        get {
            return self.defaults.stringForKey(otherCurrencyCodeKey);
        }
        set(currencyCode) {
            self.setObjectSafely(currencyCode, forKey: otherCurrencyCodeKey);
        }
    }
    
    public var expression: String? {
        get {
            return self.defaults.stringForKey(expressionKey);
        }
        set(expression) {
            self.setObjectSafely(expression, forKey: expressionKey);
        }
    }
    
    public var isArrowPointingLeft: Bool {
        get {
            return self.defaults.boolForKey(isArrowPointingLeftKey);
        }
        set(isArrowPointingLeft) {
            self.setObjectSafely(isArrowPointingLeft, forKey: isArrowPointingLeftKey);
        }
    }
    
    public func setObjectSafely(obj : AnyObject?, forKey: String) {
        if(obj == nil)
        {
            self.defaults.removeObjectForKey(forKey);
        }
        else
        {
            self.defaults.setObject(obj, forKey: forKey);
        }
    }
}