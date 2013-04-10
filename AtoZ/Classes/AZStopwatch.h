/**
  MMStopwatch.h
  MBMLibrary
  Created by Matt Maher on 1/24/12.
*//*
	[MMStopwatchARC start:@"My Timer"];  		your work here ...	[MMStopwatchARC stop:@"My Timer"];
		
		And you end up with:
	
	MyApp[4090:15203]  -> Stopwatch: [My Timer] runtime: [0.029]
*/

#import <Foundation/Foundation.h>

@interface AZStopwatch : NSObject 

//+ (void) timerBlock:((^)(char *file))block;
+ (void) named:	(NSS*)name block: (VoidBlock)block;
+ (void) stopwatch:(NSS*)name timing:(VoidBlock)block;
+ (void) start:	 (NSS*)name;
+ (void) stop:		 (NSS*)name;
+ (void) print:	 (NSS*)name;
@end
@interface AZStopwatchItem : NSObject
@property (nonatomic, strong) NSS *name;
@property (nonatomic, strong) NSDate *started, *stopped;

+ (AZStopwatchItem*) named:(NSS*)name;
- (void) stop;
- (NSTI) runtime;
- (double) runtimeMills;
@end

