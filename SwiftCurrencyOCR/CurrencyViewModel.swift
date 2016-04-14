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
        return UIImage.init(named: flagIconName);
    }
    
    private static func flagIconNameWithCurrencyCode(code : String) -> String {
        let index = code.startIndex.advancedBy(2);
        let twoLetterCountryCode = code.substringToIndex(index);
        return twoLetterCountryCode.stringByAppendingString(".png");
    }
    
}
