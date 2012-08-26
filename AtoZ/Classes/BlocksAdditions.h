//
//  BlocksAdditions.h
//  PLBlocksPlayground
//
//  Created by Michael Ash on 8/9/09.
//

#import <Cocoa/Cocoa.h>


typedef void (^BasicBlock)(void);

void RunInBackground(BasicBlock block);
void RunOnMainThread(BOOL wait, BasicBlock block);
void RunOnThread(NSThread *thread, BOOL wait, BasicBlock block);
void RunAfterDelay(NSTimeInterval delay, BasicBlock block);
void WithAutoreleasePool(BasicBlock block);


/*
    RunInBackground(^{
        WithAutoreleasePool(^{
            NSLog(@"Current thread: %@  Main thread: %@", [NSThread currentThread], [NSThread mainThread]);
            RunOnMainThread(YES, ^{
                NSLog(@"Current thread: %@  Main thread: %@", [NSThread currentThread], [NSThread mainThread]);
                RunAfterDelay(1, ^{
                    NSLog(@"Delayed log");
                });
            });
        });
    });

    NSLock *lock = [[NSLock alloc] init];
    [lock whileLocked: ^{ NSLog(@"locked"); }];
    [lock release];

	NSString *ooo = @"http://itunes.apple.com/search?term=iTunes&media=software&country=US&limit=4";
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:ooo]];
    [NSURLConnection sendAsynchronousRequest: request completionBlock: ^(NSData *data, NSURLResponse *response, NSError *error){
		self.string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];//    stringWithFormat:@"data: %ld bytes  response: %@  error: %@", (long)[data length], response,  error ];
        NSLog(@"data: %ld bytes  response: %@  error: %@", (long)[data length], response, error);
    }];
*/

void Parallelized(int count, void (^block)(int i));

//	  Parallelized(20, ^(int i){ NSLog(@"Iteration: %d", i); });

@interface NSLock (BlocksAdditions)

- (void)whileLocked: (BasicBlock)block;

@end

@interface NSNotificationCenter (BlocksAdditions)

- (void)addObserverForName: (NSString *)name object: (id)object block: (void (^)(NSNotification *note))block;

@end
/*

[[NSNotificationCenter defaultCenter] addObserverForName: NSApplicationDidBecomeActiveNotification object: nil block: ^(NSNotification *note){ NSLog(@"Did become active"); }];
*/

@interface NSURLConnection (BlocksAdditions)

+ (void)sendAsynchronousRequest: (NSURLRequest *)request completionBlock: (void (^)(NSData *data, NSURLResponse *response, NSError *error))block;

@end

@interface NSArray (CollectionsAdditions)

- (void)do: (void (^)(id obj))block;
- (NSArray *)select: (BOOL (^)(id obj))block;
- (NSArray *)map: (id (^)(id obj))block;

/*
	NSArray *testArray = @[@"1", @"2", @"3"];
	[testArray do: ^(id obj){ NSLog(@"%@", obj); }];
	NSLog(@"%@", [testArray select: ^ BOOL (id obj){ return [obj intValue] > 1; }]);
	NSLog(@"%@", [testArray map: ^(id obj){ return [NSString stringWithFormat: @"<%@>", obj]; }]);

*/
@end
