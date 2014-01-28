
//  AZTalker.m
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.

#import "AZTalker.h"

@implementation AZTalker

//NSSpeechSynthesizer *talker;
//- (id)init
//{
//	self = [super init];
//	if (self) {
//
//	}
//	return self;
//}
static NSMA* queue = nil;

- (void) setUp {

	self.talker = [NSSpeechSynthesizer new];
	self.talker.delegate = self;
	queue = NSMA.new;
}

+(void) randomDicksonism {
	[self say:NSS.dicksonisms.randomElement];
}

+(void)say:(NSString*)thing
{

	[[self.sharedInstance talker] startSpeakingString:thing];

//	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/say" arguments:@[thing]];
}

-(void) say:(NSString *)thing {

	[NSSpeechSynthesizer isAnyApplicationSpeaking] == NO
	? [_talker startSpeakingString:thing]
	: [[NSThread mainThread] performBlock:^{	[self say:thing];
	} waitUntilDone:YES];// performSelector:@selector(say:) withObject:thing afterDelay:1];

}

+ (NSURL*)tempURL { 	return [NSURL.alloc initFileURLWithPath:AZTEMPFILE(aiff)]; }

+ (void)say:(NSString*)thing toData:(void(^)(NSData*d))data {

	NSURL *aURL = [self tempURL];
	[queue addObject:@{@"URL":aURL, @"block":data}];
	[[self.sharedInstance talker] startSpeakingString:thing toURL:aURL];
}
+ (void)say:(NSString*)thing toURL:(void(^)(NSURL*u))url {

	NSURL *aURL = [self tempURL];
	[queue addObject:@{@"URL":aURL, @"uBlock":url}];
	[[self.sharedInstance talker] startSpeakingString:thing toURL:aURL];
}
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking;
{
	if (!queue.count) return;
	NSDictionary *d = queue[0]; NSURL*url = d[@"URL"];
 	if ([d objectForKey:@"uBlock"]){
		void(^ublock)(NSURL*) = d[@"uBlock"];
		if (ublock) ublock(url);
	}
	else {
		NSFileHandle* aHandle = [NSFileHandle fileHandleForReadingFromURL:d[@"URL"] error:nil];
		NSData* fileContents = nil;

		if (aHandle) fileContents = [aHandle readDataToEndOfFile];
	//	NSLog(@"reading:%@ data:%@",d[@"URL"], fileContents);
		if (fileContents) {
		 void(^dataBlock)(NSData*) = d[@"block"];
		 if (dataBlock) dataBlock(fileContents);
		}
	}
	[queue removeObjectAtIndex:0];
}

@end
