//
//  ServiceController.h
//  AtoZPrefs
//
//  Created by Josh Butts on 3/28/13.
//  Copyright (c) 2013 Josh Butts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface ServiceController : NSObject

@property Service *service;
@property NSString *launchAgentPath;

+ (void) createServicesDirectory;
-  (id) initWithService:(Service *) theService;
@property (nonatomic) BOOL running, startAtLogin;

@end
