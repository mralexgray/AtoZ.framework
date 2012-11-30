//
//  NSURL+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 8/4/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSURL+AtoZ.h"
/* data passing categories on NSURLRequest and NSMutableURLRequest.  see the
 header file for more info.  */
//@implementation NSURLRequest (SpecialProtocol)
//- (NSDictionary *)specialVars {
//	NSLog(@"%@ received %@", self, NSStringFromSelector(_cmd));
//	return [NSURLProtocol propertyForKey:[SpecialProtocol specialProtocolVarsKey] inRequest:self];
//}
//@end

//@implementation NSMutableURLRequest (SpecialProtocol)
//- (void)setSpecialVars:(NSDictionary *)specialVars {
//	NSLog(@"%@ received %@", self, NSStringFromSelector(_cmd));
//	NSDictionary *specialVarsCopy = [specialVars copy];
//	[NSURLProtocol setProperty:specialVarsCopy
//						forKey:[SpecialProtocol specialProtocolVarsKey] inRequest:self];
//}
//@end

@implementation NSURL (AtoZ)
//	isImageFile:filePath
//	Uses LaunchServices and UTIs to detect if a given file path is an image file.
- (BOOL)isImageFile
{
    BOOL isImageFile = NO;
    NSString *utiValue;
    [self getResourceValue:&utiValue forKey:NSURLTypeIdentifierKey error:nil];
    return utiValue ? UTTypeConformsTo((__bridge CFStringRef)utiValue, kUTTypeImage): isImageFile;
}

@end

