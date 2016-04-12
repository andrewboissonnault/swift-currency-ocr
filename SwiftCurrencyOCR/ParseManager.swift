//
//  Parse.swift
//  SwiftCurrencyOCR
//
//  Created by Andrew Boissonnault on 3/19/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

import Foundation
import Parse

public class ParseManager: NSObject {
    static let kParseApplicationId = "Cj1hlaclLTVPJthSfB6cbgDNCL94TSClTEdDfC8p";
    static let kParseClientKey = "fn8t6NTHaoCZ7UwIqb3cVacdfdlMauftY7S3fUmJ";

    public static func setupParse() {
        Parse.enableLocalDatastore();
        Parse.setApplicationId(kParseApplicationId, clientKey: kParseClientKey);
        PFCurrency.registerSubclass();
        PFCurrencyRates.registerSubclass();
    }
}
