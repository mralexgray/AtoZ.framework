//
//  AZAXAuthorization.h
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>
extern int system(const char *string);

@interface AZAXAuthorization : NSObject
- (NSString *)BundleName;
- (BOOL)RunCommand:(NSString *)cmd;
- (IBAction)Restart _ r ___
                              
@end
