//
//  NSNib+XMLBase64.h
//  AtoZCodeFactory
//
//  Created by Alex Gray on 9/5/13.
//  Copyright (c) 2013 Alex Gray. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>


@interface NSNib (XMLBase64)
+ (NSString*) base64FromXMLPath:(NSString*)p;
+ (NSData*) dataFromXMLPath:(NSString*)p;
+ (NSString*) xmlFromBase64:(NSString*)p;
+ (instancetype) nibFromXMLPath:(NSString*)s owner:(id)owner topObjects:(NSArray**)objs;

@end

void *NewBase64Decode( const char *inputBuffer,	size_t length, size_t *outputLength);
char *NewBase64Encode(	const void *inputBuffer, size_t length, bool separateLines, size_t *outputLength);

@interface NSData (Base64)
+ (NSData*) dataFromInfoKey:(NSString*)k;
+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;
// added by Hiroshi Hashiguchi
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;
@end
