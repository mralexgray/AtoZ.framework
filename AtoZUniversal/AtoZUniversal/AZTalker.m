
#if !TARGET_OS_IPHONE

#import <AtoZUniversal/AtoZUniversal.h>

@interface AZTalker ()
AZPROP(NSSpeechSynthesizer,talker);
@end

@implementation AZTalker static NSMutableArray* queue = nil; static BOOL finished = NO;

- (void) setUp { _talker = NSSpeechSynthesizer.new; _talker.delegate = self; queue = NSMA.new; }

- (void) say:(NSString *)x {

	NSSpeechSynthesizer.isAnyApplicationSpeaking

  ? [self performSelector:@selector(say:) withObject:x afterDelay:.4]
//  ? [NSThread.mainThread performBlock:^{	[self say:x]; } waitUntilDone:YES]
  : [_talker startSpeakingString:x];

                                                 // performSelector:@selector(say:) withObject:x afterDelay:1];
}

+ (NSSpeechSynthesizer*) talker { return [self.sharedInstance talker]; }

//+ (void) randomDicksonism { SAY(NSString.dicksonisms.randomElement); }


+ (void) sayUntilFinished:(NSString*)x { finished = NO; [self say:x then:^{ finished = YES; }];

  while(!finished) [AZRUNLOOP runMode:NSDefaultRunLoopMode beforeDate:NSDate.date];
}
+ (void) say:(NSString*)x                      { [self.sharedInstance say:x]; }// startSpeakingString:x]; }
+ (void) say:(NSString*)x then:(VBlk)then {

  [self.sharedInstance setDoneTalking:[then copy]];
  [self.sharedInstance say:x]; }

//+ (void) sayFormat:(NSString*)fmt,... {
//
//  va_list argList; va_start(argList, fmt); [self say:[NSString stringWithFormat:fmt arguments:argList]]; va_end(argList);
//}



+ (void) say:(NSString*)x withVolume:(CGF)vol {

  [self.talker setVolume:vol];
  [self.talker startSpeakingString:x];
}

+ (NSU*) tempURL { 	return [NSURL.alloc initFileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:NSUUID.UUID.UUIDString]];
}

+ (void) say:(NSString*)x toData:(void(^)(NSData*d))data {

	NSURL *aURL = [self tempURL];
	[queue addObject:@{@"URL":aURL, @"block":data}];
	[[self.sharedInstance talker] startSpeakingString:x toURL:aURL];
}

+ (void) say:(NSString*)x toURL:(void(^)(NSURL*u))url {

	NSURL *aURL = [self tempURL];
	[queue addObject:@{@"URL":aURL, @"uBlock":url}];
	[[self.sharedInstance talker] startSpeakingString:x toURL:aURL];
}

- (void) speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking {

	if (!queue.count) { !_doneTalking ?: _doneTalking(); return; }  	NSD *d = queue[0];   NSURL*url = d[@"URL"];

 	if ([d objectForKey:@"uBlock"]) {

    if(d[@"uBlock"]) ((void(^)(NSURL*))d[@"uBlock"])(url);
  }
	else {
		NSFileHandle* aHandle = [NSFileHandle fileHandleForReadingFromURL:d[@"URL"] error:nil];
		NSData* fileContents = nil;

		if (aHandle && (fileContents = aHandle.readDataToEndOfFile) && d[@"block"])   //	NSLog(@"reading:%@ data:%@",d[@"URL"], fileContents);
        ((void(^)(NSData*))d[@"block"])(fileContents);

	}
	[queue removeObjectAtIndex:0];
}

@end


//NSSpeechSynthesizer *talker;
//- (id)init
//{
//	self = [super init];
//	if (self) {
//
//	}
//	return self;
//}
//	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/say" arguments:@[x]];

#endif

