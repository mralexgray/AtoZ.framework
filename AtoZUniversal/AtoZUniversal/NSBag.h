//
//  NSBag.h
//  AtoZ
//
//  Created by Alex Gray on 9/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBag : NSObject

+ (instancetype) bagWithArray:(NSA*)a _
+ (instancetype) bag _
+ (instancetype) bagWithObjects:__, ... _

- _Void_           add:__ _
- _Void_    addObjects:__, ... _

- _Void_        remove:__ _
- _SInt_ occurrencesOf:__ _

_RO _List objects, uniqueObjects, sortedObjects;

@end

