//
//  AZFacebookConnection.h
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

//#import "AtoZUmbrella.h"
#import <AppKit/AppKit.h>
#import "BaseModel.h"


#define ALWAYS_SHOW_UI 0

typedef void(^FBTextBlock)(NSString *text);

@class PhFacebook; @interface AZFacebookConnection : BaseModel

@property (nonatomic) PhFacebook 	*fb;
@property (nonatomic) NSImage 		*pic;
@property (unsafe_unretained) NSView 			*outview;

//- (void) getToken;
- (void) myPosts;

+ (instancetype) initWithQuery:(NSString*)q param:(NSString*)key thenDo:(FBTextBlock)block;

//+ (NSString*) query:(NSString*)q param:(NSString*)key;

@end
