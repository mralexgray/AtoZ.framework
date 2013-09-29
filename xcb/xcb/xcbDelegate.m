#import "xcbDelegate.h"
#import "Project.h"
#import "NotifyingOperationQueue.h"
#import <AtoZ/AtoZ.h>

@implementation xcbDelegate

- (void) awakeFromNib {

	 [NSApp setDelegate:self];
	 [self setDefCTL:DefinitionController.new];
	 [_menuApp = MenuAppController.new loadStatusMenu];
	 
//	[NCENTER addObserver:self selector:@selector(_checkTaskStatus:) 
//						 name: NSTaskDidTerminateNotification object:nil];
//	[NSApp setServicesProvider: self]; 	// Provide application services
//	return self;
//}
//0
//	[self setBuildQueue:NotifyingOperationQueue.new];
		
}

-  (IBAction) open:(id)panel		{	NSOpenPanel* op = NSOpenPanel.openPanel;
	op.canChooseFiles = op.canChooseDirectories = op.allowsMultipleSelection = YES;
	op.runModal == NSOKButton ? ^{	NSS* path = [op.URLs valueForKeyPath:@"path"][0];
	NSLog(@"PATH: %@", path);				  	  [self application:nil openFiles:@[path]];	}() : nil;
}
-      (BOOL) application:(NSApplication*)a openFile:(NSS*)f			 {	[self application:a openFiles:@[f]];	return YES;	}	
-      (BOOL) application:(NSApplication*)a openFileWithoutUI:(NSS*)f {	[self application:a openFiles:@[f]];	return YES;	}
-      (void) application:(NSApplication*)a openFiles:(NSA*)fs 		 {

	[fs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {	[_buildQueue addProjectWithPath:obj];  }];
}
@end




/*- (NSA*) xcodeProjectsIn:(NSS*)path {
	__block NSS *validXcodeProj;
	return [[NSFM contentsOfDirectoryAtPath:path error:nil] map:^id(NSS *folder) {
	  		if ((validXcodeProj = [self lookForXocdeProjIn:folder])) 
			[_buildQueue addOperation:[Project.alloc initWithPath:validXcodeProj]]; 
//		NSLog(@"added a file to batch!  %@", xvod); }
	}];

}
-  (void) recursiveSearchIn:		  (NSS*)path	 							{

	[fs enumerateObjectsUsingBlock:^(NSS* path, NSUInteger idx, BOOL *stop) {
		BOOL isDir, isXcodeProj;
		BOOL exists = [NSFM fileExistsAtPath:path isDirectory:&isDir];
		NSLog(@"%@ Found opened \"file\" %@.   It %@ a folder!", NSStringFromSelector(_cmd), path, isDir ? @"IS": @"IS NOT");
		if (exists) {
			if ([path.pathExtension isEqualToString:@"xcodeproj"]) 
			[_buildQueue addProjectWithPath:path];
			else if (isDir) {
				 NSS* projPath =	[self lookForXocdeProjIn:f];
			if (projPath)	{ 	self.projectPath = projPath;	[self executeCommand:nil];	}
			else 				{ 	if (_batchFiles == nil)	 _batchFiles = NSMutableArray.new;
									[self exploreSubdirs:f.stringByDeletingLastPathComponent]; }
		}
	}
}
-  (NSS*) lookForXocdeProjIn:	  (NSS*)folder					 			{

	__block NSS *target = nil;
	NSArray* files = [NSFM contentsOfDirectoryAtPath:folder error:nil];
	[files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj hasSuffix:@"xcodeproj"]) {  target = obj;  *stop = YES; }
	}];
	return  target ?  [folder stringByAppendingPathComponent:target] : nil;
}


//	self.projectPath =  valueForKeyPath:@"path"][0]; NSLog(@"Argument: %@", _projectPath);
//	if (_projectPath)								[self executeCommand:nil];
//-  (void) _delayedOpenFile:	    (id) anObject							{
//	NSLog(@"%@", NSStringFromSelector(_cmd));
//	[self executeCommand: _batchFiles];
//	_batchFiles = nil;
//	if (myAppWasLaunchedWithDocument) [NSApp terminate: self];
//}
//-  (NSA*) targets { }

Information about project "appledoc":
    Targets:
        appledoc
        AppledocTests

    Build Configurations:
        Debug
        Release

    If no build configuration is specified and -scheme is not passed then "Release" is used.

    This project contains no schemes.

-   (void) applicationDidFinishLaunching:(NSNOTE*)aNotification			{	_launching = NO;
//    UNOTE *userNotification = aNotification.userInfo[NSApplicationLaunchUserNotificationKey];
//    if (userNotification) {
//        // We were launched because a notification was clicked on. There's nothing
//        // for us to do in this case but log a message.
//        NSLog(@"Application launched with notification %@", userNotification.informativeText);
//        exit(0);
//    } else {
//        NSArray *args = [[NSProcessInfo processInfo] arguments];
//			// Construct the command from the arguments.
//        NSS *command = [[self commandFromArguments:args] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        
//        if ([@"" isEqualToString:command]) {
//            // No command so print some usage information.
//            [self printUsage];
//            exit(1);
//        } else {
//            // Execute the command.
//            NSMD *result = [self executeCommand:command];
//            
//            // Remove existing notifications for the same command.
//            [self removeExistingNotifications:result];
//            
//            // Send appropriate notification.
//            [self deliverNotificationForCommandCompletion:result];
//            
//            // Exit with the status of the command we executed.
//            exit([((NSNumber *)result[CommandCompletionStatus]) intValue]);
//        }
//    }
}
-  (NSS*) commandFromArguments:(NSArray*)args							{

    NSUInteger numberOfArgs = args.count;	// Create string rep. the command to exec, from the arguments passed to the program.
    NSMutableArray *commandArguments = NSMutableArray.new;
    BOOL skipNextArgument = NO; // This is used to skip the -NSDocumentRevisionsDebugMode YES arguments added running under XCode
    for (NSUInteger i = 1; i < numberOfArgs; ++i) {    // Skip args[0], it's the program name
	     NSS *currentArgument = args[i];
        if ([@"-NSDocumentRevisionsDebugMode" isEqualToString:currentArgument])  skipNextArgument = YES;
        else if (skipNextArgument)        													skipNextArgument = NO;
        else           				 [commandArguments addObject:currentArgument];
	}
	return [commandArguments componentsJoinedByString:@" "];
}
-  (void) printUsage																{
    const char *appName = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"] UTF8String];
    const char *appVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] UTF8String];
    printf("%s (%s) is a command-line tool to send an OS X User Notification when a command completes\n" \
           "\n" \
           "Usage: %s command to execute\n" \
           "\n" \
           "   Where \"command to execute\" is the series of shell commands you want to run.\n" \
           "   For example \'%s mvn clean install\'\n " \
           "   Chaining commands and notifying when they all complete is not currently supported.\n",
           appName, appVersion, appName, appName);
}

*/


