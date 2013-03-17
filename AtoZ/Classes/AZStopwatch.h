//  MMStopwatch.h
//  MBMLibrary
//  Created by Matt Maher on 1/24/12.

//
//[MMStopwatchARC start:@"My Timer"];
//// your work here ...
//[MMStopwatchARC stop:@"My Timer"];
//And you end up with:
//
//MyApp[4090:15203]  -> Stopwatch: [My Timer] runtime: [0.029]
#import <Foundation/Foundation.h>
@interface AZStopwatch : NSObject {
@private
	NSMutableDictionary *items;
}
+ (void) named:(NSString*)name block:(void (^)())block;
+ (void) stopwatch:(NSString*)name timing:(void (^)())block;
+ (void) start:(NSString *)name;
+ (void) stop:(NSString *)name;
+ (void) print:(NSString *)name;
@end
@interface AZStopwatchItem : NSObject
//
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *started, *stopped;

+ (AZStopwatchItem *) named:(NSString *)name;
- (void) stop;
- (NSTI) runtime;
- (double) runtimeMills;
@end

