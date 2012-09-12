//
//  NSBag.h
//  AtoZ
//
//  Created by Alex Gray on 9/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBag : NSObject {
	NSMutableDictionary *dict;
}
+ (NSBag *) bag;
+ (NSBag *) bagWithObjects: (id) anObject,...;
- (void) add: (id) anObject;
- (void) addObjects:(id)item,...;
- (void) remove: (id) anObject;
- (NSInteger) occurrencesOf: (id) anObject;
- (NSArray *) objects;
@end

