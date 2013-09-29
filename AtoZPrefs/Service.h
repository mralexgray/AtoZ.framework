//
//  Service.h
//  AtoZPrefs
//
//  Created by Josh Butts on 3/26/13.
//  Copyright (c) 2013 Josh Butts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject

@property (retain)  NSImage * image;
@property (retain) NSString * plist,
									 * identifier,
									 * plistFilename;

- (id) initWithOptions:(NSDictionary*) options;


@end
