//
//  AZTalker.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZTalker : NSObject <NSSpeechSynthesizerDelegate>
-(void) say:(NSString *)thing;

@end
