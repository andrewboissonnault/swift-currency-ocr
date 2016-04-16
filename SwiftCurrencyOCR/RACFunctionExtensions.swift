//
//  RACFunctionExtensions.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/15/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa

infix operator ~> {
associativity right

// Binds tighter than assignment but looser than everything else
precedence 93
}

public func ~> <A, Property: PropertyType where Property.Value == A>(property : Property, function: (A) -> (Void)) {
    function(property.value);
    property.signal.observeNext(function);
}