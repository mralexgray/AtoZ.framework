//
//  AZImageToDataTransformer.m
//  AtoZ
//
//  Created by Alex Gray on 10/15/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZImageToDataTransformer.h"

@implementation AZImageToDataTransformer

+ (BOOL)allowsReverseTransformation

{

	return YES;

}

+ (Class)transformedValueClass

{

	return [NSData class];

}

- (id)transformedValue:(id)value

{

	NSBitmapImageRep *rep = [[value representations] objectAtIndex: 0];

	NSData *data = [rep representationUsingType: NSPNGFileType

									 properties: nil];

	return data;

}

- (id)reverseTransformedValue:(id)value

{

	NSImage *uiImage = [[NSImage alloc] initWithData:value];
	
	return uiImage;
	
}

@end