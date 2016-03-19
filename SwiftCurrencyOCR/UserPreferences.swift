//
//  UserPreferences.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/17/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation

class UserPreferences: NSObject {
    
    var baseCurrencyCode: NSString!
    var otherCurrencyCode: NSString!
    var expression: NSString!
    var isArrowPointingLeft: Bool!
    var baseCurrency: Currency!
    var otherCurrency: Currency!
    
}
