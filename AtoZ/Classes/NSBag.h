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
+ (instancetype) bagWithObjects:(id) anObject,...;
- (void)  add: 			  (id) anObject;
- (void)  addObjects:	  (id)item,...;
- (void)  remove: 		  (id) anObject;
- (NSI)   occurrencesOf:  (id) anObject;

@property (readonly) NSA * objects;
@property (readonly) NSA * uniqueObjects;
@end

