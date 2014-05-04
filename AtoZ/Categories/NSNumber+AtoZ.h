//
//  NSNumber+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (AtoZ)

+ (NSN*) randomFloatBetween:(CGF)min :(CGF)max;

@property (RONLY) NSS* hexString;

+ (NSR) rectBy:(NSA*)sizes;
+ (NSNumber*) numberWithBytes:(const void *) bytes objCType:(const char *)type;
- (NSN*)plus:(NSN*)toAdd;
- (NSN*)minus:(NSN*)toSub;
- (NSN*)plusF:(CGF)toAdd;
- (NSN*)minusF:(CGF)toSub;
- (NSN*)plusI:(NSI)toAdd;
- (NSN*)minusI:(NSI)toSub;

- (NSN*) dividedBy:(CGF)f;
+ (NSN*)integerWithHexString:(NSS*)hexString;

/* CFNumberType {
   kCFNumberSInt8Type = 1,
   kCFNumberSInt16Type = 2,
   kCFNumberSInt32Type = 3,
   kCFNumberSInt64Type = 4,
   kCFNumberFloat32Type = 5,
   kCFNumberFloat64Type = 6,
   kCFNumberCharType = 7,
   kCFNumberShortType = 8,
   kCFNumberIntType = 9,
   kCFNumberLongType = 10,
   kCFNumberLongLongType = 11,
   kCFNumberFloatType = 12,
   kCFNumberDoubleType = 13,
   kCFNumberCFIndexType = 14,
   kCFNumberNSIntegerType = 15,
   kCFNumberCGFloatType = 16,
   kCFNumberMaxType = 16	};
*/
- (CFNumberType) type;

- (NSString*) prettyBytes;
+ (NSNumber*) zero;
+ (NSNumber*) one;
+ (NSNumber*) two;

- (NSNumber*) increment;
- (NSNumber*) abs;
- (NSNumber*) negate;
- (NSNumber*) transpose;

- (NSA*) times:(id (^)(void))block;

@property (RONLY) NSA* toArray;
@property (RONLY) NSS* sVal;

- (NSA*) to:(NSNumber*) to;
- (NSA*) to:(NSNumber*) to by:(NSNumber*) by;

@end

@interface NSNumber (Description)

/*
 *  @brief Returns a string that describes the value of the number. This keeps type information.
 *  @return A string that describes the value of the number.
 */
- (NSS*)typeFormedDescription;

@end


/*!
 *  @brief NSNumber description method extension
 */
@interface NSDecimalNumber (Description)

/*
 *  @brief Returns a string that describes the value of the number. This keeps type information.
 *  @return A string that describes the value of the number.
 */
- (NSS*)typeFormedDescription;

@end
