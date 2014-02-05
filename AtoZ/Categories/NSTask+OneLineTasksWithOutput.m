//
//  NSTask+OneLineTasksWithOutput.m
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

#import "NSTask+OneLineTasksWithOutput.h"

@interface TaskOutputReader :	NSObject
@property (NATOM, STRNG) 	NSMutableData *standardOutput, *standardError;
@property (NATOM, ASS) 		BOOL taskComplete, outputClosed, errorClosed;
@property (NATOM, STRNG)	NSTask *task;
@end

@implementation TaskOutputReader
@synthesize  task, taskComplete, outputClosed, errorClosed, standardError, standardOutput;
//
// initWithTask:
//
// Sets the object as an observer for notifications from the task or its
// file handles.
//
// Parameters:
//	aTask - the NSTask object to observe.
//
// returns the initialized output reader
//
- (id)initWithTask:(NSTask *)aTask
{
	self = [super init];
	if (self != nil)
	{
		task = aTask;
		standardOutput 	= NSMutableData.data;
		standardError 	= NSMutableData.data;

		NSFileHandle *standardOutputFile = [[aTask standardOutput] fileHandleForReading];
		NSFileHandle *standardErrorFile = [[aTask standardError] fileHandleForReading];
		
		[AZNOTCENTER
			addObserver:self
			selector:@selector(standardOutNotification:)
			name:NSFileHandleDataAvailableNotification
			object:standardOutputFile];
		[AZNOTCENTER
			addObserver:self
			selector:@selector(standardErrorNotification:)
			name:NSFileHandleDataAvailableNotification
			object:standardErrorFile];
		[AZNOTCENTER
			addObserver:self
			selector:@selector(terminatedNotification:)
			name:NSTaskDidTerminateNotification
			object:aTask];
		
		[standardOutputFile waitForDataInBackgroundAndNotify];
		[standardErrorFile waitForDataInBackgroundAndNotify];
	}
	return self;
}

//
// dealloc
//
// Releases instance memory.
//
//- (void)dealloc
//{
//	[[NSNotificationCenter defaultCenter] removeObserver:self];
//	[standardOutput release];
//	[standardError release];
//	[task release];
//	[super dealloc];
//}

//
// standardOutputData
//
// Accessor for the data object
//
// returns the object.
//
- (NSData *)standardOutputData
{
	return standardOutput;
}

//
// standardErrorData
//
// Accessor for the data object
//
// returns the object.
//
- (NSData *)standardErrorData
{
	return standardError;
}

//
// standardOutNotification:
//
// Reads standard out into the standardOutput data object.
//
// Parameters:
//	notification - the notification containing the NSFileHandle to read
//
-(void)standardOutNotification: (NSNotification *) notification
{
	NSFileHandle *standardOutFile = (NSFileHandle *)[notification object];
	
	NSData *availableData = [standardOutFile availableData];
	if ([availableData length] == 0)
	{
		outputClosed = YES;
		return;
	}
	
	[standardOutput appendData:availableData];
	[standardOutFile waitForDataInBackgroundAndNotify];
}
 
//
// standardErrorNotification:
//
// Reads standard error into the standardError data object.
//
// Parameters:
//	notification - the notification containing the NSFileHandle to read
//
-(void)standardErrorNotification: (NSNotification *) notification
{
	NSFileHandle *standardErrorFile = (NSFileHandle *)[notification object];

	NSData *availableData = [standardErrorFile availableData];
	if ([availableData length] == 0)
	{
		errorClosed = YES;
		return;
	}
	
	[standardError appendData:availableData];
	[standardErrorFile waitForDataInBackgroundAndNotify];
}
 
//
// terminatedNotification:
//
// Sets the taskComplete flag when a terminated notification is received.
//
// Parameters:
//	notification - the notification
//
- (void)terminatedNotification: (NSNotification *)notification
{
	taskComplete = YES;
}

//
// launchTaskAndRunSynchronous
//
// Runs the current event loop until the terminated notification is received
//
- (void)launchTaskAndRunSynchronous
{
	[task launch];
	
	BOOL isRunning = YES;
	while (isRunning && (!taskComplete || !outputClosed || !errorClosed))
	{
		isRunning =
			[[NSRunLoop currentRunLoop]
				runMode:NSDefaultRunLoopMode
				beforeDate:[NSDate distantFuture]];
	}
}

//
// launchTaskAndRunSynchronous
//
// Runs the current event loop until the terminated notification is received
//
- (void)launchTaskAndRunAsynchronousForObject:(id)receiver selector:(SEL)selector
{
	[task launch];
	
	BOOL isRunning = YES;
	while (isRunning && (!taskComplete || !outputClosed || !errorClosed))
	{
		isRunning =
			[[NSRunLoop currentRunLoop]
				runMode:NSDefaultRunLoopMode
				beforeDate:[NSDate distantFuture]];
	}
}

@end

@implementation NSTask (OneLineTasksWithOutput)

//
// stringByLaunchingPath:withArguments:error:
//
// Executes a process and returns the standard output as an NSString
//
// Parameters:
//	processPath - the path to the executable
//	arguments - arguments to pass to the executable
//	error - an NSError pointer or nil
//
// Returns the standard out from the process an an NSString (if the NSTask
//	completes successfully), nil otherwise.
// 
// Error handling notes:
//
// If the NSTask throws an exception, it will be automatically caught and
// the "error" object will have the code kNSTaskLaunchFailed and the
// localizedDescription will be the -[NSException reason] from the thrown
// exception. The return value will be nil in this case.
//
// If the NSTask is successfully run but outputs on standard error, the
// localizedDescription of the NSError will be set to the string output to
// standard error (the output on standard out will still be returned as a
// string). The error code will be kNSTaskProcessOutputError in this case.
//
+ (NSS*)stringByLaunchingPath:(NSS*)processPath
	withArguments:(NSA*)arguments
	error:(NSError **)error
{
	NSTask *task = NSTask.new;
	
	[task setLaunchPath:processPath];
	[task setArguments:arguments];
	[task setStandardOutput:[NSPipe pipe]];
	[task setStandardError:[NSPipe pipe]];

	TaskOutputReader *outputReader = [TaskOutputReader.alloc initWithTask:task];

	NSString *outputString = nil;
	NSString *errorString = nil;
	@try
	{
		[outputReader launchTaskAndRunSynchronous];
		
		outputString =
			[NSString.alloc
				initWithData:[outputReader standardOutputData]
				encoding:NSUTF8StringEncoding];
		errorString =
			[NSString.alloc
				initWithData:[outputReader standardErrorData]
				encoding:NSUTF8StringEncoding];
	}
	@catch (NSException *exception)
	{
		*error =
			[NSError
				errorWithDomain:@"com.apple.NSTask.OneLineTasksWithOutput"
				code:kNSTaskLaunchFailed
				userInfo:
					[NSDictionary
						dictionaryWithObject:[exception reason]
						forKey:NSLocalizedDescriptionKey]];
		return nil;
	}
	@finally
	{
    ;;
	}
	
	if (error)
	{
		if ([errorString length] > 0)
		{
			*error =
				[NSError
					errorWithDomain:@"com.apple.NSTask.OneLineTasksWithOutput"
					code:kNSTaskProcessOutputError
					userInfo:
						[NSDictionary
							dictionaryWithObject:errorString
							forKey:@"standardError"]];
		}
		else
		{
			*error = nil;
		}
	}
	return outputString;
}

//
// stringByLaunchingPath:withArguments:error:
//
// Executes a process with specified authorization and returns the standard
// output as an NSString.
//
// Parameters:
//	processPath - the path to the executable
//	arguments - arguments to pass to the executable
//	  authorization - an SFAuthorization object specifying the privileges
//	error - an NSError pointer or nil
//
// Returns the standard out from the process an an NSString (if the
//  AuthorizationExecuteWithPrivileges completes successfully), nil otherwise.
// 
// Error handling notes:
//
// If any error is returned from AuthorizationExecuteWithPrivileges, the error
// object will have its code set to the OSErr that it returns an nil will be
// returned from the method.
//
+ (NSS*)stringByLaunchingPath:(NSS*)processPath
	withArguments:(NSA*)arguments
	authorization:(SFAuthorization *)authorization
	error:(NSError **)error
{
	//
	// Create a nil terminated C array of pointers to UTF8Strings for use as the
	// argv array.
	//
	const char **argv = (const char **)malloc(sizeof(char *) * [arguments count] + 1);
	NSInteger argvIndex = 0;
	for (NSString *string in arguments)
	{
		argv[argvIndex] = [string UTF8String];
		argvIndex++;
	}
	argv[argvIndex] = nil;

	//
	// Perform the process invocation
	//
	FILE *processOutput;
	OSErr processError =
		AuthorizationExecuteWithPrivileges(
			[authorization authorizationRef],
			[processPath UTF8String],
			kAuthorizationFlagDefaults,
			(char *const *)argv,
			&processOutput);
	free(argv);
	
	//
	// Handle errors
	//
	if (processError != errAuthorizationSuccess)
	{
		if (error)
		{
			*error =
				[NSError
					errorWithDomain:@"com.apple.NSTask.OneLineTasksWithOutput"
					code:processError
					userInfo:nil];
		}
		return nil;
	}
	if (error)
	{
		*error = nil;
	}

	//
	// Read the output from the FILE pipe up to EOF (or other error).
	//
#define READ_BUFFER_SIZE 64
	char readBuffer[READ_BUFFER_SIZE];
	NSMutableString *processOutputString = [NSMutableString string];
	size_t charsRead;
	while ((charsRead = fread(readBuffer, 1, READ_BUFFER_SIZE, processOutput)) != 0)
	{
		NSString *bufferString =
			[NSString.alloc 				initWithBytes:readBuffer
				length:charsRead
				encoding:NSUTF8StringEncoding];
		[processOutputString appendString:bufferString];
	}
	fclose(processOutput);
	
	return processOutputString;
}

@end

@interface NSFileHandle (CXAdditions)
- (NSData *) reallyReadDataToEndOfFile;
@end

@implementation NSFileHandle (CXAdditions)

// This method exists mainly for ease of debugging.  readDataToEndOfFile should actually do the job.
- (NSData *) reallyReadDataToEndOfFile
{
	NSMutableData *	outData = NSMutableData.new;
	NSData *		currentData;

	currentData = [self availableData];
	while( currentData != nil && [currentData length] > 0 )
	{
		[outData appendData:currentData];
		currentData = [self availableData];
	}

	return outData;
}
@end

@implementation NSTask (CXAdditions)

// helper method called in its own thread and writes data to a file descriptor
+ (void)writeDataToFileHandleAndClose:(id)someArguments
{
//	NSAutoreleasePool*	pool	= [NSAutoreleasePool new];
	@autoreleasepool {
		NSFileHandle *		fh		= [someArguments objectForKey:@"fileHandle"];
		NSData *			data	= [someArguments objectForKey:@"data"];

		if( fh != nil && data != nil )
		{
			[fh writeData:data];
			[fh closeFile];
		}
	}
//	[pool release];
}

// Return a task (not yet launched) and optionally allocate stdout/stdin/stderr streams for communication with it
+ (NSTask *) taskWithArguments:(NSA*)args
								 input:(NSFileHandle **)outWriteHandle
								output:(NSFileHandle **)outReadHandle
								 error:(NSFileHandle **)outErrorHandle
{
	NSTask *task = NSTask.new;

	[task setLaunchPath:[args objectAtIndex:0]];
	[task setArguments:[args subarrayWithRange:NSMakeRange(1, [args count] - 1)]];

	if( outReadHandle != NULL )
	{
		NSPipe *		readPipe	= [NSPipe pipe];
		NSFileHandle *	readHandle	= [readPipe fileHandleForReading];

		[task setStandardOutput:readPipe];
		*outReadHandle = readHandle;
	}

	if( outWriteHandle != NULL )
	{
		NSPipe *		writePipe	= [NSPipe pipe];
		NSFileHandle *	writeHandle	= [writePipe fileHandleForWriting];

		[task setStandardInput:writePipe];
		*outWriteHandle = writeHandle;
	}

	if( outErrorHandle != NULL )
	{
		NSPipe *		errorPipe	= [NSPipe pipe];
		NSFileHandle *	errorHandle	= [errorPipe fileHandleForReading];

		[task setStandardError:errorPipe];
		*outErrorHandle = errorHandle;
	}

	return task;
}

// Atomically execute the task and return output as data
+ (int) executeTaskWithArguments:(NSA*)args
									input:(id)inputDataOrString
							 outputData:(NSData **)outputData
							errorString:(NSString **)errorString;
{

	NSFileHandle *		outputFile	= nil;
	NSFileHandle *		inputFile	= nil;
	NSFileHandle *		errorFile	= nil;
	NSTask *			task;

	task = [NSTask taskWithArguments:args
										input:(inputDataOrString == nil) ? NULL : &inputFile
									  output:(outputData == NULL) ? NULL : &outputFile
										error:(errorString == NULL) ? NULL : &errorFile];

	if( inputDataOrString != nil )
	{
		// Convert string to UTF8 data
		if( [inputDataOrString isKindOfClass:NSString.class] )
		{
			inputDataOrString = [inputDataOrString dataUsingEncoding:NSUTF8StringEncoding];
		}

		NSDictionary* arguments = [NSDictionary dictionaryWithObjectsAndKeys:
											inputFile,			@"fileHandle",
											inputDataOrString,	@"data",
											nil];
		[NSThread detachNewThreadSelector:@selector(writeDataToFileHandleAndClose:) toTarget:self withObject:arguments];
	}
	[task launch];

	// output data
	if( outputData != NULL )
	{
		*outputData = [outputFile reallyReadDataToEndOfFile];
	}

	// convert error data to string
	if( errorString != NULL )
	{
		NSData * errorData = [errorFile reallyReadDataToEndOfFile];

		*errorString = [NSString.alloc initWithData:errorData
														  encoding:NSUTF8StringEncoding];
	}

	[task waitUntilExit];
	return [task terminationStatus];
}

+ (int) executeTaskWithArguments:(NSA*)args
									input:(id)inputDataOrString
						  outputString:(NSString **)outputString
							errorString:(NSString **)errorString;
{
	NSData *	outputData;
	int			terminationStatus;

	terminationStatus = [self executeTaskWithArguments:args
																input:inputDataOrString
														 outputData:(outputString == NULL) ? NULL : &outputData
														errorString:errorString];

	if( outputString != nil )
	{
		*outputString = [NSString.alloc initWithData:outputData
															encoding:NSUTF8StringEncoding];
	}

	return terminationStatus;
}

@end
