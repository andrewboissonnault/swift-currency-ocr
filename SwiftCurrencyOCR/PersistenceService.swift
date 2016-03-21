//
//  PersistenceService.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/21/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

public protocol PersistenceServiceProtocol {
  //  var baseCurrencySignal: String { get }
   // var otherCurrencySignal: String { get }
    var expression: MutableProperty<String> { get }
    var isArrowPointingLeft: MutableProperty<Bool> { get }
}

public protocol PersistenceServiceInputProtocol {
    var baseCurrencySignal: Signal<String, Result.NoError> { get }
    var otherCurrencySignal: String { get }
    var expressionSignal: String { get }
    var isArrowPointingLeftSignal: Bool { get }
}

public class PersistenceService: PersistenceServiceProtocol {
    var userPreferencesService: UserPreferencesServiceProtocol
    
    public private(set) var expression: MutableProperty<String>
    public private(set) var isArrowPointingLeft: MutableProperty<Bool>
    
    
    convenience init() {
        self.init(userPreferencesService: UserPreferencesService());
    }
    
    init(userPreferencesService : UserPreferencesServiceProtocol) {
        self.userPreferencesService = userPreferencesService;
        self.expression = MutableProperty<String>.init(self.userPreferencesService.expression);
        self.isArrowPointingLeft = MutableProperty<Bool>.init(self.userPreferencesService.isArrowPointingLeft);
        
        self.expression.signal.observeNext { (value : String) -> () in
            self.userPreferencesService.expression = value;
        }
        self.isArrowPointingLeft.signal.observeNext { (value : Bool) -> () in
            self.userPreferencesService.isArrowPointingLeft = value;
        }
    }
}
