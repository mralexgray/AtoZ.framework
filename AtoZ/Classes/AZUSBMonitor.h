//
//  AZUSBMonitor.h
//  AtoZ
//
//  Created by Alex Gray on 9/29/15.
//  Copyright © 2015 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZUSBMonitor : NSObject

_RO _List deviceArray;

+ (void) listen;

@end
