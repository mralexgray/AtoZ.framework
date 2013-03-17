//
//  NSTask+OneLineTasksWithOutput.h
//  OpenFileKiller
//
//  Created by Matt Gallagher on 4/05/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Cocoa/Cocoa.h>
#import <SecurityFoundation/SFAuthorization.h>

@interface NSTask (OneLineTasksWithOutput)

+ (NSString *)stringByLaunchingPath:(NSString *)processPath
	withArguments:(NSArray *)arguments
	error:(NSError **)error;
+ (NSString *)stringByLaunchingPath:(NSString *)processPath
	withArguments:(NSArray *)arguments
	authorization:(SFAuthorization *)authorization
	error:(NSError **)error;


- (void)launchTaskAndRunSynchronous;
@end

#define kNSTaskLaunchFailed -1
#define kNSTaskProcessOutputError -2



@interface NSTask (CXAdditions)

// For the three methods below:
//	Argument index 0 is an absolute path to the executable.
//	Each file/data/string output is allocated and returned to the caller unless the caller passes NULL.
//	input may be NULL, an NSString object, or an NSData object.

// Return a task (not yet launched) and optionally allocate stdout/stdin/stderr streams for communication with it
+ (NSTask *) taskWithArguments:(NSArray *)arguments
								 input:(NSFileHandle **)outWriteHandle
								output:(NSFileHandle **)outReadHandle
								 error:(NSFileHandle **)outErrorHandle;

// Atomically execute the task and return output as data
+ (int) executeTaskWithArguments:(NSArray *)args
									input:(id)inputDataOrString
							 outputData:(NSData **)outputData
							errorString:(NSString **)errorString;

// Atomically execute the task and return output as string
+ (int) executeTaskWithArguments:(NSArray *)args
									input:(id)inputDataOrString
						  outputString:(NSString **)outputString
							errorString:(NSString **)errorString;

@end
