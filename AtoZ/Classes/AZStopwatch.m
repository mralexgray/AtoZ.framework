//  MMStopwatch.m -  Created by Matt Maher on 1/24/12.

#import "AZStopwatch.h"
#import "AtoZ.h"


#pragma mark - MMStopwatch
// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  - 
// =================[ PRIVATE ]==================================
@interface AZStopwatch ()
+ (AZStopwatch*) 		sharedInstance;
- (AZStopwatchItem*) get:(NSS*)name;
- (void) add:   			 (NSS*)name;
- (void) remove:			 (NSS*)name;
@end

@implementation AZStopwatch {	NSMutableDictionary *items; }

+ (void) named:	 (NSS*)name block: (VoidBlock)block	{	[AZStopwatch stopwatch:name timing:block];	}
+ (void) stopwatch:(NSS*)name timing:(VoidBlock)block	{	[AZStopwatch start:name];	block(); [AZStopwatch stop: name]; }
+ (void) start:	 (NSS*)name 								{ [self.sharedInstance add:name]; }
+ (void) stop:		 (NSS*)name 								{ [[self.sharedInstance get:name] stop];	[self print:name]; }
+ (void) print:	 (NSS*)name 								{

	AZStopwatchItem *item = [AZStopwatch.sharedInstance get:name];
	if (item) item.stopped ?	NSLog(@"%@", item) : NSLog(@"%@ (running)", item);
	else	NSLog(@"No stopwatch named [%@] found", name);
}
+ (NSS*) runtime :(NSS*)name {
	AZStopwatchItem *item = [AZStopwatch.sharedInstance get:name];
	return item && item.stopped ?	 $(@"%@", item) : $(@"%@ (running)", item);
	return $(@"No stopwatch named [%@] found", name);
}
// INTERNALS
- (AZStopwatchItem*) get:(NSS*)name {	return  name ? (AZStopwatchItem *)items[name] : nil;	}
- (void) remove:(NSS*)name 	  		{		if ( ! name) return; 	[items removeObjectForKey:name];	}
- (void) add:   (NSS*)name 	 		{ if ( ! name) return; [self remove:name]; items[name] = [AZStopwatchItem named:name]; }
// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -   
#pragma mark - SINGLETON PATTERN
static id _sharedSingleton		= nil;
- (id) init 			 {	if (self != super.init ) return nil;	items = NSMD.new;	return self; }
+ (id) sharedInstance {
	
	// return before any locking .. should perform better
	if (_sharedSingleton) return _sharedSingleton;
	// THREAD SAFTEY
	@synchronized(self) { if (	!	_sharedSingleton) _sharedSingleton		= self.new;	}
	return _sharedSingleton;
}
+ (id) alloc 			 {	NSAssert(_sharedSingleton == nil, @"Attempted to allocate a 2nd instance of a singleton."); return super.alloc; }
@end

#pragma mark - MMStopwatchItemARC
// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -   
// ===============================[ PRIVATE ]==================================

@implementation AZStopwatchItem
@synthesize name, started, stopped;


+ (AZStopwatchItem*) named:(NSS*)name {

	AZStopwatchItem *item	= AZStopwatchItem.new;	item.name = name;	item.started = NSDate.date; return item;
}
-   (void) start        {  self.started = NSDate.date; }
- 	 (void) stop 			{	self.stopped = NSDate.date; }
-   (NSS*) description 	{	

	return $(@"%@ : %@", name, [AZLog colorizeString:$(@"[%@]",[self runtimePretty]) withColor:NSColor.whiteColor]);	}
- (double) runtimeMills {	return [self runtime] * 1000.0; }
-   (NSTI) runtime 		{
			// never started																		/* start to stop time */
	return !started ? 0.0 :	!stopped ? [started timeIntervalSinceNow] * -1 : [started timeIntervalSinceDate:stopped] * -1;
		
}
-   (NSS*) runtimePretty{ return [self.class runtimePrettyForRuntime:[self runtime]]; }
+   (NSS*) runtimePrettyForRuntime:(NSTI)runtime {
	double secsRem	= runtime;
	// 3600 seconds in an hour
	int hours		= (int)	 (secsRem / 3600);
	secsRem			= secsRem - (hours   * 3600);
	int mins			= (int)	 (secsRem /   60);
	secsRem			= secsRem - (mins	  * 60);
	
	return hours > 0 ? $(@"%d:%d:%.2f", hours, mins, secsRem) : mins > 0 ? $(@"%d:%.2f", mins, secsRem) : $(@"%.4f seconds", secsRem);
}

@end

@implementation  NSObject (Stopwatch)
- (void) startTiming { AZStopwatchItem *s; [s=AZStopwatchItem.new start];  [self setAssociatedValue:s forKey:@"watch"];	}

- (double) runningTimer { AZStopwatchItem *s = objc_getAssociatedObject(self, (__bridge const void *)@"watch");

	double run = [[self associatedValueForKey:@"totalDuration" orSetTo:@0]doubleValue];
	return (s && s.started) ? (run + s.runtime) : run;
}
- (void) stopTiming { AZStopwatchItem *s = objc_getAssociatedObject(self, (__bridge const void *)@"watch");
		if (!s) return;  [s stop];
		double run = [[self associatedValueForKey:@"totalDuration" orSetTo:@0]doubleValue];
		run = run == 0 ? s.runtime : run + s.runtime; 	[self setAssociatedValue:@(run) forKey:@"totalDuration"];
}
- (NSS*) elapsed { AZStopwatchItem *i = objc_getAssociatedObject(self, (__bridge const void *)@"watch");
	return i==nil ? nil : [AZStopwatchItem runtimePrettyForRuntime:self.runningTimer]; }

@end

