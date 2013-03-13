//
//  NSNumber+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (AtoZ)
- (NSString*) prettyBytes;
+ (NSNumber*) zero;
+ (NSNumber*) one;
+ (NSNumber*) two;

- (NSNumber*) increment;
- (NSNumber*) abs;
- (NSNumber*) negate;
- (NSNumber*) transpose;

- (NSA*) times:(id (^)(void))block;

- (NSA*) to:(NSNumber*) to;
- (NSA*) to:(NSNumber*) to by:(NSNumber*) by;

@end

@interface NSNumber (Description)

/*
 *  @brief Returns a string that describes the value of the number. This keeps type information.
 *  @return A string that describes the value of the number.
 */
- (NSString *)typeFormedDescription;

@end


/*!
 *  @brief NSNumber description method extension
 */
@interface NSDecimalNumber (Description)

/*
 *  @brief Returns a string that describes the value of the number. This keeps type information.
 *  @return A string that describes the value of the number.
 */
- (NSString *)typeFormedDescription;

@end
