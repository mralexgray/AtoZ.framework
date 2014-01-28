//
//  AZTalker.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <ApplicationServices/ApplicationServices.h>
#import "BaseModel.h"
#import "AtoZ.h"

@interface AZTalker : BaseModel <NSSpeechSynthesizerDelegate>

@property (strong, nonatomic) NSSpeechSynthesizer *talker;

-(void) say:(NSString*)thing;
+(void) say:(NSString*)thing;
+(void) randomDicksonism;
//+(NSData*) sayToData:(NSString*)thing;
+ (void)say:(NSString*)thing toData:(void(^)(NSData*d))data;
+ (void)say:(NSString*)thing toURL:(void(^)(NSURL*u))url;

@end
