//
//  UIKitExtensions.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 4/15/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import UIKit
import ReactiveCocoa
import enum Result.NoError

struct AssociationKey {
    static var hidden: UInt8 = 1
    static var alpha: UInt8 = 2
    static var text: UInt8 = 3
}

// lazily creates a gettable associated property via the given factory
func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: ()->T) -> T {
    return objc_getAssociatedObject(host, key) as? T ?? {
        let associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        return associatedProperty
        }()
}

func lazyMutableProperty<T>(host: AnyObject, key: UnsafePointer<Void>, setter: T -> (), getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key: key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithNext{
                newValue in
                setter(newValue)
        }
        
        return property
    }
}

extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha  })
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.hidden, setter: { self.hidden = $0 }, getter: { self.hidden  })
    }
}

extension UILabel {
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text ?? "" })
    }
}

extension UITextField {
    public var rac_text: MutableProperty<String> {
        return lazyAssociatedProperty(self, key: &AssociationKey.text) {
            
            self.addTarget(self, action: "changed", forControlEvents: UIControlEvents.EditingChanged)
            
            let property = MutableProperty<String>(self.text ?? "")
            property.producer
                .startWithNext {
                    newValue in
                    self.text = newValue
            }
            return property
        }
    }
    
    func changed() {
        rac_text.value = self.text ?? ""
    }
}

extension NSUserDefaults {
    /// Sends value of key when the value is changed
    func rex_signalForKey<Object>(key: String) -> Signal<Object?, NoError> {
        let (signal, observer) = Signal<Object?, NoError>.pipe()
        
        // send initial value
        let initial: Object? = self.objectForKey(key) as? Object;
        
        observer.sendNext(initial);
        
        // observe other values
        let defaultsDidChange = NSNotificationCenter.defaultCenter().rac_notifications(NSUserDefaultsDidChangeNotification, object: self)
        defaultsDidChange.startWithNext { (_) -> () in
            let value: Object? = self.objectForKey(key) as? Object;
            observer.sendNext(value);
        }
        
        return signal.skipRepeats { a, b in
                if let a = a as? NSObject, b = b as? NSObject where a.isEqual(b) {
                    return true
                } else {
                    return false
                }
        }
    }
    
    func rex_propertyForKey<Object>(key: String) -> MutableProperty<Object?> {
        let property = MutableProperty<Object?>.init(nil);
        property <~ self.rex_signalForKey(key);
        return property;
    }
}