//
//  SDIsNotEmptyValueTransformer.m
//  Docks
//
//  Created by Steven Degutis on 7/17/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "SDIsNotEmptyValueTransformer.h"


@implementation SDIsNotEmptyValueTransformer

+ (Class)transformedValueClass { return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
	return NSBOOL([value count] > 0);
}

@end
