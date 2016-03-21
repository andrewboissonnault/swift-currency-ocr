//
//  Currency.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/17/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import Parse

let kCurrencyClassName = "Currency";
let kCodeKey = "code";

public protocol CurrencyProtocol {
    var name: NSString { get set }
    var code: NSString { get set }
    var flagImage: UIImage { get set }
}

public class PFCurrency: PFObject, PFSubclassing, CurrencyProtocol {
    
    public var name: NSString = ""
    public var code: NSString = ""
    public var flagIcon: PFFile = PFFile.init(data: NSData.init())!;
    public var shouldFetchFlagIcon: Bool = false
    public var flagImage: UIImage = UIImage.init()
    
    public class func parseClassName() -> String {
        return kCurrencyClassName;
    }
    
    public override var description : String {
        return self.debugDescription;
    }
    
    public override var debugDescription : String {
        return String.init(format: "%@ ( %@ )", self.code, self.name);
    }
}

public class Currency: NSObject, CurrencyProtocol {
    
    public var name: NSString = ""
    public var code: NSString = ""
    public var flagImage: UIImage = UIImage.init()
    
    public override var description : String {
        return self.debugDescription;
    }
    
    public override var debugDescription : String {
        return String.init(format: "%@ ( %@ )", self.code, self.name);
    }
}