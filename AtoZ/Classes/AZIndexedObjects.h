//
//  AZIndexedObjects.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZIndexedObjects : NSObject

-   (id) objectAtIndex:	(NSUI)idx;
-  (NSI) indexOfObject:	(id)x;
- (void) addObject:		(id)x;
- (void) addObject:		(id)x 					atIndex:(NSI)idx;
- (void) setObject:		(id)value atIndexedSubscript:(NSI)idx;
-   (id) objectAtIndexedSubscript:						  (NSI)idx;

@end
