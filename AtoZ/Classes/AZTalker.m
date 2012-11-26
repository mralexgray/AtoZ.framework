
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

- (void) setUp {

	self.talker = [NSSpeechSynthesizer new];
	self.talker.delegate = self;
}

+(NSA*) dicksonisms {
	static NSA* dicks = nil;
	return dicks = dicks ? dicks : @[

	@"When I was 10 years old - I wore this dress; I just keep getting it altered.",
	@"See? I still fit into my 10-year-old clothing.",
	@"Look at that! Oh, is that me on the wall? I drew it myself - with chalk!",
	@"I can't move, but boy, can I ever pose!",
	@"I wish there was a close up on my face.. there it is! <<sighing>> Wow, looking better and better all the time.",
	@"That's a - beret - it's from Europe.",
	@"I really shouldn't be doing this; but I'm going to have an ad for IKEA right now.",
	@"This is a complete IKEA closet.  The bed is underneath my pants.",
	@"If you have a look - you can see that everything fits - into this particle board.   You just paint it white.. pull it out... oh gold and silver! (those are my two signature colors.)"];
}
+(void) randomDicksonism {
	[self say:[[self dicksonisms]randomElement]];
}

+(void)say:(NSString*)thing
{
	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/say" arguments:@[thing]];
}

-(void) say:(NSString *)thing {

	[NSSpeechSynthesizer isAnyApplicationSpeaking] == NO
	? [_talker startSpeakingString:thing]
	: [[NSThread mainThread] performBlock:^{
		[self say:thing];
	} waitUntilDone:YES];// performSelector:@selector(say:) withObject:thing afterDelay:1];

}

@end
