//
//  UserPreferencesService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/21/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

public protocol UserPreferencesServiceProtocol {
    var leftCurrencyCode: MutableProperty<String> { get }
    var rightCurrencyCode: MutableProperty<String> { get }
    var expression: MutableProperty<String> { get }
    var isArrowPointingLeft: MutableProperty<Bool> { get }
}

public class BaseUserPreferencesService : UserPreferencesServiceProtocol {
    public var leftCurrencyCode: MutableProperty<String> = MutableProperty.init("");
    public var rightCurrencyCode: MutableProperty<String> = MutableProperty.init("");
    public var expression: MutableProperty<String> = MutableProperty.init("");
    public var isArrowPointingLeft: MutableProperty<Bool> = MutableProperty.init(false);
    
}

public class UserPreferencesService: BaseUserPreferencesService {
    static var sharedInstance : UserPreferencesServiceProtocol = UserPreferencesService.init();
    
    private let leftCurrencyCodeKey = "leftCurrencyCode"
    private let rightCurrencyCodeKey = "rightCurrencyCode"
    private let expressionKey = "expression"
    private let isArrowPointingLeftKey = "isArrowPointingLeft"
    
    private var defaults: NSUserDefaults;
    
    init(defaults: NSUserDefaults)
    {
        self.defaults = defaults;
        super.init();
        
        self.leftCurrencyCode.value = safeStringForKey(leftCurrencyCodeKey);
        self.rightCurrencyCode.value = safeStringForKey(rightCurrencyCodeKey);
        self.expression.value = safeStringForKey(expressionKey);
        self.isArrowPointingLeft.value = safeBoolForKey(isArrowPointingLeftKey);
        
        self.leftCurrencyCode.producer.startWithNext { (next : String) in
            self.setObjectSafely(next, forKey: self.leftCurrencyCodeKey);
        }
        
        self.rightCurrencyCode.producer.startWithNext { (next : String) in
            self.setObjectSafely(next, forKey: self.rightCurrencyCodeKey);
        }
        
        self.expression.producer.startWithNext { (next : String) in
            self.setObjectSafely(next, forKey: self.expressionKey);
        }
        self.isArrowPointingLeft.producer.startWithNext { (next : Bool) in
            self.setObjectSafely(next, forKey: self.isArrowPointingLeftKey);
        }
    }
    
    convenience override init()
    {
        self.init(defaults: NSUserDefaults.init());
    }
    
    private func safeStringForKey(key : String) -> String {
        return self.safeString(self.defaults.objectForKey(key) as? String);
    }
    
    public func safeString(string : String?) -> String {
        if(string == nil) {
            return "";
        }
        return string!;
    }
    
    private func safeBoolForKey(key : String) -> Bool {
        return self.safeBool(self.defaults.objectForKey(key) as? Bool);
    }
    
    public func safeBool(bool : Bool?) -> Bool {
        if(bool == nil) {
            return false;
        }
        return bool!;
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