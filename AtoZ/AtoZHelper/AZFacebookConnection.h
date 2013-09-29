//
//  AZFacebookConnection.h
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>

#define ALWAYS_SHOW_UI 0

typedef void(^FBTextBlock)(NSString *text);

@interface AZFacebookConnection : BaseModel

@property (strong, nonatomic) PhFacebook 	*fb;
@property (strong, nonatomic) NSImage 		*pic;
@property (unsafe_unretained) NSView 			*outview;

//- (void) getToken;
- (void) myPosts;

+ (instancetype) initWithQuery:(NSString*)q param:(NSString*)key thenDo:(FBTextBlock)block;

//+ (NSString*) query:(NSString*)q param:(NSString*)key;

@end
