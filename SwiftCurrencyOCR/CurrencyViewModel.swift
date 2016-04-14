//
//  CurrencyViewModel.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/13/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Parse
import enum Result.NoError

public protocol CurrencyViewModelProtocol {
    var currencyCode: MutableProperty<String> { get }
    var currencyName: MutableProperty<String> { get }
    var flagIconImage: MutableProperty<UIImage?> { get }
    var flagIconFile : MutableProperty<PFFile?> { get }
    func == (left: CurrencyProtocol, right: CurrencyProtocol) -> Bool
}

public class CurrencyViewModel : CurrencyViewModelProtocol {
    private var currency : CurrencyProtocol;
    
    public private(set) var currencyCode: MutableProperty<String>;
    public private(set) var currencyName: MutableProperty<String>;
    public private(set) var flagIconImage: MutableProperty<UIImage?>;
    public private(set) var flagIconFile : MutableProperty<PFFile?>;
    
    init(currency : CurrencyProtocol) {
        self.currency = currency;
        self.currencyCode = self.currency.codeProperty;
        self.currencyName = self.currency.nameProperty;
        self.flagIconImage = MutableProperty<UIImage?>.init(CurrencyViewModel.flagIconWithCode(self.currencyCode.value));
        self.flagIconFile = self.currency.flagIconProperty;
        
        self.setupBindings();
    }
    
    private func setupBindings()
    {
        self.flagIconImage <~ self.flagIconImageSignal();
    }
    
    private func flagIconImageSignal() -> Signal<UIImage?, Result.NoError> {
        let signal = self.currencyCode.signal.map(CurrencyViewModel.flagIconWithCode);
        return signal;
    }
    
    private static func flagIconWithCode(code : String) -> UIImage? {
        let flagIconName = CurrencyViewModel.flagIconNameWithCurrencyCode(code);
        if(flagIconName != nil)
        {
            return UIImage.init(named: flagIconName!);
        }
        else
        {
            return nil;
        }
    }
    
    private static func flagIconNameWithCurrencyCode(code : String) -> String? {
        if(code.characters.count >= 2)
        {
            let index = code.startIndex.advancedBy(2);
            let twoLetterCountryCode = code.substringToIndex(index);
            return twoLetterCountryCode.stringByAppendingString(".png");
        }
        else
        {
            return nil;
        }
    }
    
}

public func == (left: CurrencyViewModelProtocol, right: CurrencyViewModelProtocol) -> Bool {
    return (left.currencyCode.value == right.currencyCode.value) && (left.currencyName.value == right.currencyName.value)
}

public func != (left: CurrencyViewModelProtocol, right: CurrencyViewModelProtocol) -> Bool {
    return !(left == right);
}
