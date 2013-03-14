//
//  AZFacebookConnection.h
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>

#define ALWAYS_SHOW_UI 0

@interface AZFacebookConnection : BaseModel

@property (strong, nonatomic) PhFacebook *fb;
@property (strong, nonatomic) NSImage *pic;


@end
