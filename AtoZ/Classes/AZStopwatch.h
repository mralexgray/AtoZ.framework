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

+ (void) stopwatch:(NSString*)name timing:(void (^)())block;
+ (void) start:(NSString *)name;
+ (void) stop:(NSString *)name;
+ (void) print:(NSString *)name;
@end
@interface AZStopwatchItem : NSObject
//{
//@private
//	NSString *name;
//	NSDate *started;
//	NSDate *stopped;
//}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *started;
@property (nonatomic, strong) NSDate *stopped;
+ (AZStopwatchItem *) itemWithName:(NSString *)name;
- (void) stop;
- (NSTimeInterval) runtime;
- (double) runtimeMills;
@end



