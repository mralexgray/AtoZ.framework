//
//  NSBag.h
//  AtoZ
//
//  Created by Alex Gray on 9/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBag : NSObject

+ (instancetype) bagWithArray:(NSA*)a;
+ (instancetype) bag;
+ (instancetype) bagWithObjects:_, ...;

- (void)           add:_;
- (void)    addObjects:_, ...;

- (void)        remove:_;
-  (NSI) occurrencesOf:_;

@prop_RO NSA * objects, * uniqueObjects, * sortedObjects;

@end

