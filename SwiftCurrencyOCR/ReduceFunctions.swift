//
//  ReduceFunctions.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/14/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation

public func reduceLeft<Object>(left : Object, right : Object, isArrowPointingLeft : Bool) -> Object {
    if(isArrowPointingLeft) {
        return right;
    }
    else
    {
        return left;
    }
}

public func reduceRight<Object>(left : Object, right : Object, isArrowPointingLeft : Bool) -> Object {
    if(isArrowPointingLeft) {
        return left;
    }
    else
    {
        return right;
    }
}
