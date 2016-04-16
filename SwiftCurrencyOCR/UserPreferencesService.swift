//
//  UserPreferencesService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/21/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol UserPreferencesServiceProtocol {
    var leftCurrencyCode: MutableProperty<String?> { get }
    var rightCurrencyCode: MutableProperty<String?> { get }
    var expression: MutableProperty<String?> { get }
    var isArrowPointingLeft: MutableProperty<Bool> { get }
}

public class UserPreferencesService: UserPreferencesServiceProtocol {
    private let leftCurrencyCodeKey = "leftCurrencyCode"
    private let rightCurrencyCodeKey = "rightCurrencyCode"
    private let expressionKey = "expression"
    private let isArrowPointingLeftKey = "isArrowPointingLeft"
    
    private var defaults: NSUserDefaults;
    
    public var leftCurrencyCode: MutableProperty<String?>;
    public var rightCurrencyCode: MutableProperty<String?>;
    public var expression: MutableProperty<String?>;
    public var isArrowPointingLeft: MutableProperty<Bool?>;
    
    init(defaults: NSUserDefaults)
    {
        self.defaults = defaults;
        
        self.leftCurrencyCode = self.defaults.rex_propertyForKey(leftCurrencyCodeKey);
        self.rightCurrencyCode = self.defaults.rex_propertyForKey(rightCurrencyCodeKey);
        self.expression = self.defaults.rex_propertyForKey(expressionKey);
        self.isArrowPointingLeft = self.defaults.rex_propertyForKey(isArrowPointingLeftKey);
    }
    
    convenience init()
    {
        self.init(defaults: NSUserDefaults.init());
    }
    
    public func safeStringForKey(key : String) -> String {
        var string = self.defaults.stringForKey(key);
        if(string == nil) {
            string = "";
        }
        return string!;
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