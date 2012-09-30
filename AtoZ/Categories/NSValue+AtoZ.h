//
//  NSValue+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (AZWindowPosition)
+ (id)valueWithPosition: (AZWindowPosition) pos;
- (AZWindowPosition) positionValue;
@end
