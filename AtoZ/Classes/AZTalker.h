//
//  AZTalker.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <ApplicationServices/ApplicationServices.h>
#import "BaseModel.h"

@interface AZTalker : NSObject <NSSpeechSynthesizerDelegate>

@property (strong, nonatomic) NSSpeechSynthesizer *talker;

-(void) say:(NSString *)thing;
+ (instancetype)sharedInstance;

+(void)say:(NSString*)s;

@end
