//
//  AZIndexedObjects.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

@import AtoZUniversal;

@interface AZIndexedObjects : NSObject

-   objectAtIndex:_UInt_ idx;
- _SInt_ indexOfObject:x;
- _Void_ addObject:x;
- _Void_ addObject:x 					      atIndex:_SInt_ idx;
- _Void_ setObject:value atIndexedSubscript:_SInt_ idx;
-                  objectAtIndexedSubscript:_SInt_ idx;

@end
