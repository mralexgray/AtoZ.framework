
/*! MMStopwatch.h MBMLibrary  Created by Matt Maher on 1/24/12. */

/*
	[MMStopwatchARC start:@"My Timer"];  		your work here ...	[MMStopwatchARC stop:@"My Timer"];
		
		And you end up with:
	
	MyApp[4090:15203]  -> Stopwatch: [My Timer] runtime: [0.029]
*/

#import "AtoZUmbrella.h"

@interface AZStopwatch : NSObject 

+ (void) named:	(NSS*)name block: (VoidBlock)block;
+ (void) stopwatch:(NSS*)name timing:(VoidBlock)block;
+ (void) start:	 (NSS*)name;
+ (void) stop:		 (NSS*)name;
+ (void) print:	 (NSS*)name;

+ (NSString*) runtime:(NSString*)name;
@end

@interface AZStopwatchItem : NSObject
@property (nonatomic) NSS *name;
@property (nonatomic) NSDate *started, *stopped;

//+ (void) timeBlocks:(id)blocks,...;

+ (INST) named:(NSS*)name;
- (void) start;
- (void) stop;
- (NSS*) runtimePretty;
- (NSTI) runtime;
- (double) runtimeMills;
@end

@interface  NSObject (Stopwatch)
- (void) startTiming;
- (void) stopTiming;

@prop_RO AZStopwatchItem * stopWatch;
@prop_RO             NSS * elapsed;
@end

//+ (void) timerBlock:((^)(char *file))block;
#define AZSTOPWATCH(...) [AZStopwatch named:$UTF8(__PRETTY_FUNCTION__) block:^{ ({ __VA_ARGS__; }); }]
