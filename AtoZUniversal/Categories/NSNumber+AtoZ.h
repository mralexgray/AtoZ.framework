//  NSNumber+AtoZ.h
//  Created by Alex Gray on 7/7/12. Copyright (c) 2012 mrgray.com, inc. All rights reserved.

@interface NSNumber (AtoZ)

+ (NSN*) randomFloatBetween:(CGF)min :(CGF)max;

@prop_RO NSS* hexString;


- (void) do:(void(^)(int ctr))block;
+ (INST) numberWithBytes:(const void*)bytes objCType:(const char*)type;

+  (NSR) rectBy:(NSA*)sizes;

- (INST)      plus:(NSN*)toAdd;
- (INST)     minus:(NSN*)toSub;
- (INST)     plusF:(CGF)toAdd;
- (INST)    minusF:(CGF)toSub;
- (INST)     plusI:(NSI)toAdd;
- (INST)    minusI:(NSI)toSub;

- (INST) dividedBy:(CGF)f;
+ (INST) integerWithHexString:(NSS*)hexString;

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

@prop_RO NSS* prettyBytes;

+ (INST) zero;
+ (INST) one;
+ (INST) two;

@prop_RO NSN * increment, * abs, *negate, * transpose;

- (NSA*) times:(id (^)(void))block;
- (NSA*) ntimes:(id (^)(int index))block;

@prop_RO NSA* toArray;
@prop_RO NSS* sVal;

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
