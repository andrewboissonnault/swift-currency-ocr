//
//  Currency.h
//  CurrencyOCR
//
//  Created by Andrew Boissonnault on 1/2/16.
//  Copyright © 2016 Andrew Boissonnault. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFCurrency : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* code;
@property (strong, nonatomic) PFFile* flagIcon;
@property BOOL shouldFetchFlagIcon;

+(PFCurrency*)defaultBaseCurrency;
+(PFCurrency*)defaultOtherCurrency;

+(void)fetchCurrencyWithCodeInBackground:(NSString*)code block:(PFIdResultBlock)block;

@end
