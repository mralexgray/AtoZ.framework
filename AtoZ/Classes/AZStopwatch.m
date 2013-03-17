//  MMStopwatch.m
//  Created by Matt Maher on 1/24/12.

#import "AZStopwatch.h"

// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -   
#pragma mark - MMStopwatch
#pragma mark -
// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  - 
// =================[ PRIVATE ]==================================
@interface AZStopwatch ()
+ (id) sharedInstance;
- (AZStopwatchItem *) get:(NSString *)name;
- (void) add:(NSString *)name;
- (void) remove:(NSString *)name;
@end
// ==============================================================
@implementation AZStopwatch
+ (void) named:(NSString*)name block:(void (^)())block
{
	[AZStopwatch stopwatch:name timing:block];
}

//+(void)stopwatch:(NSString*)stopwatch aroundBlock:(void (^)())block;
+ (void) stopwatch:(NSString*)name timing:(void (^)())block
{
	[AZStopwatch start:name];
	block();
	[AZStopwatch stop: name];
}

+ (void) start:(NSString *)name {
	[[AZStopwatch sharedInstance] add:name];
}
+ (void) stop:(NSString *)name {
	AZStopwatchItem *item = [[AZStopwatch sharedInstance] get:name];
	[item stop];
	[self print:name];
}
+ (void) print:(NSString *)name {
	AZStopwatchItem *item = [[AZStopwatch sharedInstance] get:name];
	if (item) {
		if (item.stopped) {
			NSLog(@"%@", item);
		}
		
		else {
			NSLog(@"%@ (running)", item);
		}
	}
	
	else {
		NSLog(@"No stopwatch named [%@] found", name);
	}
}
// ----------------------
// INTERNALS
// ----------------------
- (AZStopwatchItem *) get:(NSString *)name {
	// bail
	if ( ! name) {
		return nil;
	}
	return (AZStopwatchItem *)items[name];
}
- (void) remove:(NSString *)name {
	// bail
	if ( ! name) {
		return;
	}
	[items removeObjectForKey:name];
}
- (void) add:(NSString *)name {
	// bail
	if ( ! name) {
		return;
	}
	
	[self remove:name];
	items[name] = [AZStopwatchItem named:name];
}

// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  
#pragma mark - SINGLETON PATTERN
#pragma mark -
// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  
- (id)init {
	self = [super init];
	if (self) {
		items = [[NSMutableDictionary alloc] init];
	}
	return self;
}
static id _sharedSingleton		= nil;
+ (id) sharedInstance {
	
	// return before any locking .. should perform better
	if (_sharedSingleton) 
		return _sharedSingleton;
	
	// THREAD SAFTEY
	@synchronized(self) {
		if (	!	_sharedSingleton) {
			_sharedSingleton		= [[self alloc] init];
		}
	}
	return _sharedSingleton;
}
+ (id) alloc {
	NSAssert(_sharedSingleton == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

@end



// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -   
#pragma mark - MMStopwatchItemARC
#pragma mark -
// +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  +  -  
// =================[ PRIVATE ]==================================
@interface AZStopwatchItem ()
- (NSString *) runtimePretty;
@end
// ==============================================================
@implementation AZStopwatchItem

@synthesize name;
@synthesize started;
@synthesize stopped;
+ (AZStopwatchItem *) named:(NSString *)name {
	AZStopwatchItem *item	= [[AZStopwatchItem alloc] init];
	item.name				= name;
	item.started			= [NSDate date];
	return item;
}
- (void) stop {
	self.stopped			= [NSDate date];
}
- (NSString *) description {
	NSMutableString *outString = [[NSMutableString alloc] init];
	[outString appendFormat:@" -> Stopwatch: [%@] runtime: [%@]", name, [self runtimePretty]];
	return outString;
}
- (double) runtimeMills {
	return [self runtime] * 1000.0;
}
- (NSTimeInterval) runtime {
	// never started
	if ( ! started) {
		return 0.0;
	}
	
	// not yet stopped
	if ( ! stopped) {
		return [started timeIntervalSinceNow] * -1;
	}
	
	// start to stop time
	return [started timeIntervalSinceDate:stopped] * -1;
}
- (NSString *) runtimePretty {
	
	double secsRem		= [self runtime];
	
	// 3600 seconds in an hour
	
	int hours			= (int)(secsRem / 3600);
	secsRem				= secsRem - (hours * 3600);
	int mins			= (int)(secsRem / 60);
	secsRem				= secsRem - (mins * 60);
	
	if (hours > 0) {
		return [NSString stringWithFormat:@"%d:%d:%f", hours, mins, secsRem];
	}
	
	if (mins > 0) {
		return [NSString stringWithFormat:@"%d:%f", mins, secsRem];
	}
	
	return [NSString stringWithFormat:@"%f", secsRem];
}
@end


