
//#import <extobjc_OSX/extobjc.h>
#import "AtoZDelegate.h"

//@interface AtoZApplicationBridge (PRIVATE)
//+ (void) _checkSandbox;
//@end
//
//static NSDictionary *cachedRegistrationDictionary = nil;
//static NSString	*appName = nil;
//static id			delegate = nil;
//static BOOL			atozLaunched = NO;
//
//static NSMutableArray	*queuedGrowlNotifications = nil;
//
//static BOOL registeredWithGrowl = NO;
////Do not touch the attempts variable directly! Use the +attempts method every time, to ensure that the array exists.
//static NSMutableArray *_attempts = nil;
//
////used primarily by GIP, but could be useful elsewhere.
//static BOOL		registerWhenGrowlIsReady = NO;
//
//static BOOL    attemptingToRegister = NO;
//
//static BOOL    sandboxed = NO;
//static BOOL    networkClient = NO;
//

@concreteprotocol (AtoZDelegate)
- (NSBundle*)bundle { return AZAPPBUNDLE; }
@end
/**
+ (void) setGrowlDelegate:(NSObject*)inDelegate {

	NSDistributedNotificationCenter *NSDNC = NSDistributedNotificationCenter.defaultCenter;

	if (inDelegate != delegate) {
		[delegate release];
		delegate = [inDelegate retain];
	}

	[cachedRegistrationDictionary release];
	cachedRegistrationDictionary = [[self bestRegistrationDictionary] retain];

	//Cache the appName from the delegate or the process name
	[appName autorelease];
	appName = [[self _applicationNameForGrowlSearchingRegistrationDictionary:cachedRegistrationDictionary] retain];
	if (!appName) {
		NSLog(@"%@", @"GrowlApplicationBridge: Cannot register because the application name was not supplied and could not be determined");
		return;
	}

//	Cache the appIconData from the delegate if it responds to the applicationIconDataForGrowl selector, or the application if not
	[appIconData autorelease];
	appIconData = [[self _applicationIconDataForGrowlSearchingRegistrationDictionary:cachedRegistrationDictionary] retain];

	//Add the observer for GROWL_IS_READY which will be triggered later if all goes well
	[NSDNC addObserver:self
			  selector:@selector(_growlIsReady:)
				  name:GROWL_IS_READY
				object:nil];

Watch for notification clicks if our delegate responds to th growlNotificationWasClicked: selector. Notifications will come in on a  unique notification name based on our app name, pid and GROWL_DISTRIBUTED_NOTIFICATION_CLICKED_SUFFIX.
	int pid = [[NSProcessInfo processInfo] processIdentifier];
	NSString *growlNotificationClickedName = [NSString.alloc initWithFormat:@"%@-%d-%@",
		appName, pid, GROWL_DISTRIBUTED_NOTIFICATION_CLICKED_SUFFIX];
	if ([delegate respondsToSelector:@selector(growlNotificationWasClicked:)])
		[NSDNC addObserver:self
				  selector:@selector(growlNotificationWasClicked:)
					  name:growlNotificationClickedName
					object:nil];
	else
		[NSDNC removeObserver:self
						 name:growlNotificationClickedName
					   object:nil];
	[growlNotificationClickedName release];
	
//We also look for notifications which arne't pid-specific but which are for our application
	growlNotificationClickedName = [NSString.alloc initWithFormat:@"%@-%@",
									appName, GROWL_DISTRIBUTED_NOTIFICATION_CLICKED_SUFFIX];
	if ([delegate respondsToSelector:@selector(growlNotificationWasClicked:)])
		[NSDNC addObserver:self
				  selector:@selector(growlNotificationWasClicked:)
					  name:growlNotificationClickedName
					object:nil];
	else
		[NSDNC removeObserver:self
						 name:growlNotificationClickedName
					   object:nil];
	[growlNotificationClickedName release];

	NSString *growlNotificationTimedOutName = [NSString.alloc initWithFormat:@"%@-%d-%@",
		appName, pid, GROWL_DISTRIBUTED_NOTIFICATION_TIMED_OUT_SUFFIX];
	if ([delegate respondsToSelector:@selector(growlNotificationTimedOut:)])
		[NSDNC addObserver:self
				  selector:@selector(growlNotificationTimedOut:)
					  name:growlNotificationTimedOutName
					object:nil];
	else
		[NSDNC removeObserver:self
						 name:growlNotificationTimedOutName
					   object:nil];
	[growlNotificationTimedOutName release];
	
//We also look for notifications which arne't pid-specific but which are for our application
	growlNotificationTimedOutName = [NSString.alloc initWithFormat:@"%@-%@",
									 appName, GROWL_DISTRIBUTED_NOTIFICATION_TIMED_OUT_SUFFIX];
	if ([delegate respondsToSelector:@selector(growlNotificationTimedOut:)])
		[NSDNC addObserver:self
				  selector:@selector(growlNotificationTimedOut:)
					  name:growlNotificationTimedOutName
					object:nil];
	else
		[NSDNC removeObserver:self
						 name:growlNotificationTimedOutName
					   object:nil];
	[growlNotificationTimedOutName release];

	[self reregisterGrowlNotifications];
}


#pragma mark -

+ (BOOL) registerWithDictionary:(NSDictionary *)regDict {
   if(attemptingToRegister){
      NSLog(@"Attempting to register while an attempt is already running");
   }
   
   //Will register when growl is running and ready
   if(![self _growlIsReachableUpdateCache:NO]){
      registerWhenGrowlIsReady = YES;
      return NO;
   }
   
	if (regDict)
		regDict = [self registrationDictionaryByFillingInDictionary:regDict];
	else
		regDict = [self bestRegistrationDictionary];

   attemptingToRegister = YES;
   
      
   
	[cachedRegistrationDictionary release];
	cachedRegistrationDictionary = [regDict retain];

	GrowlCommunicationAttempt *firstAttempt = nil;
   GrowlApplicationBridgeRegistrationAttempt *secondAttempt = nil;
   
   if(hasGNTP){
      //These should be the only way we get marked as having gntp
      if([GrowlXPCCommunicationAttempt canCreateConnection])
         firstAttempt = [[GrowlXPCRegistrationAttempt.alloc initWithDictionary:regDict] autorelease];
      else if(networkClient)
         firstAttempt = [[GrowlGNTPRegistrationAttempt.alloc initWithDictionary:regDict] autorelease];
      
      if(firstAttempt){
         firstAttempt.delegate = (id <GrowlCommunicationAttemptDelegate>)self;
         [[self attempts] addObject:firstAttempt];
      }
   }

   if(!sandboxed){
      secondAttempt = [[GrowlApplicationBridgeRegistrationAttempt.alloc initWithDictionary:regDict] autorelease];
      secondAttempt.applicationName = [self _applicationNameForGrowlSearchingRegistrationDictionary:regDict];
      secondAttempt.delegate = (id <GrowlCommunicationAttemptDelegate>)self;
      [[self attempts] addObject:secondAttempt];
      if(firstAttempt)
         firstAttempt.nextAttempt = secondAttempt;
      else
         firstAttempt = secondAttempt;
   }

	[firstAttempt begin];

	return YES;
}

#pragma mark Private methods

+ (NSString *) _applicationNameForGrowlSearchingRegistrationDictionary:(NSDictionary *)regDict {

	NSString *applicationNameForGrowl = nil;

	if (delegate && [delegate respondsToSelector:@selector(applicationNameForGrowl)])
		applicationNameForGrowl = [delegate applicationNameForGrowl];

	if (!applicationNameForGrowl) {
		applicationNameForGrowl = [regDict objectForKey:GROWL_APP_NAME];

		if (!applicationNameForGrowl)
			applicationNameForGrowl = [[NSProcessInfo processInfo] processName];
	}

	return applicationNameForGrowl;
}
+ (NSData *) _applicationIconDataForGrowlSearchingRegistrationDictionary:(NSDictionary *)regDict {
	NSData *iconData = nil;

	if (delegate) {
		if ([delegate respondsToSelector:@selector(applicationIconForGrowl)])
			iconData = (NSData *)[delegate applicationIconForGrowl];
		else if ([delegate respondsToSelector:@selector(applicationIconDataForGrowl)])
			iconData = [delegate applicationIconDataForGrowl];
	}

	if (!iconData)
		iconData = [regDict objectForKey:GROWL_APP_ICON_DATA];

	if (iconData && [iconData isKindOfClass:[NSImage class]])
		iconData = [(NSImage *)iconData PNGRepresentation];

	if (!iconData) {
		NSString *path = [[NSBundle mainBundle] bundlePath];
		iconData = [[[NSWorkspace sharedWorkspace] iconForFile:path] PNGRepresentation];
	}

	return iconData;
}

// Selector called when a growl notification is clicked.  This should never b called manually, and the calling observer should only be registered if the delegate

+ (void) growlNotificationWasClicked:(NSNotification *)notification {
	NSAutoreleasePool *pool = NSAutoreleasePool.new;
	[delegate growlNotificationWasClicked:
		[[notification userInfo] objectForKey:GROWL_KEY_CLICKED_CONTEXT]];
	[pool drain];
}
+ (void) growlNotificationTimedOut:(NSNotification *)notification {
	NSAutoreleasePool *pool = NSAutoreleasePool.new;
	[delegate growlNotificationTimedOut:
		[[notification userInfo] objectForKey:GROWL_KEY_CLICKED_CONTEXT]];
	[pool drain];
}

#pragma mark -

+ (void) _emptyQueue
{
   for (NSDictionary *noteDict in queuedGrowlNotifications) {
      [self notifyWithDictionary:noteDict];
   }
   [queuedGrowlNotifications release]; queuedGrowlNotifications = nil;
}

+ (void) _growlIsReady:(NSNotification *)notification {
	NSAutoreleasePool *pool = NSAutoreleasePool.new;

   //We may have gotten a new version of growl
   [self _growlIsReachableUpdateCache:YES];
	//Growl has now launched; we may get here with (growlLaunched == NO) when the user first installs
	growlLaunched = YES;

	//Inform our delegate if it is interested
	if ([delegate respondsToSelector:@selector(growlIsReady)])
		[delegate growlIsReady];

	//Post a notification locally
	[[NSNotificationCenter defaultCenter] postNotificationName:GROWL_IS_READY
														object:nil
													  userInfo:nil];

	//Stop observing for GROWL_IS_READY
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self
															   name:GROWL_IS_READY
															 object:nil];

	//register (fixes #102: this is necessary if we got here by Growl having just been installed)
	if (registerWhenGrowlIsReady) {
		[self reregisterGrowlNotifications];
		registerWhenGrowlIsReady = NO;
	} else {
		registeredWithGrowl = YES;
      [self _emptyQueue];
	}

	[pool drain];
}

+ (BOOL) _growlIsReachableUpdateCache:(BOOL)update
{
   static BOOL _cached = NO;
   static BOOL _reachable = NO;
   
   BOOL running = [self isGrowlRunning];
   
   //No sense in running version checks repeatedly, but if growl relaunched, we will recheck
   if(_cached && !update){
      if(running)
         return _reachable;
      else
         return NO;
   }
   
   //We dont say _cached = YES here because we haven't done the other checks yet
   if(!running)
      return NO;
   
   [self _checkSandbox];

   //This is a bit of a hack, we check for Growl 1.2.2 and lower by seeing if the running helper app is inside Growl.prefpane
   NSString *runningPath = [[[[NSRunningApplication runningApplicationsWithBundleIdentifier:GROWL_HELPERAPP_BUNDLE_IDENTIFIER] objectAtIndex:0] bundleURL] absoluteString];
   NSString *prefPaneSubpath = @"Growl.prefpane/Contents/Resources";
   
   if([runningPath rangeOfString:prefPaneSubpath options:NSCaseInsensitiveSearch].location != NSNotFound){
      hasGNTP = NO;
      _reachable = !sandboxed;
      if(!_reachable)
         NSLog(@"%@ could not reach Growl, You are running Growl version 1.2.2 or older, and %@ is sandboxed", appName, appName);
   }else{
      //If we are running 1.3+, and we are sandboxed, do we have network client, or an XPC?
      hasGNTP = YES;
      if(sandboxed){
         if(networkClient || [GrowlXPCCommunicationAttempt canCreateConnection]){
            _reachable = YES;
         }else{
            NSLog(@"%@ could not reach Growl, %@ is sandboxed and does not have the ability to talk to Growl, contact the developer to resolve this", appName, appName);
            _reachable = NO;
         }
      }else
         _reachable = YES;
   }
   
   _cached = YES;
   return _reachable;
}

+ (void) _checkSandbox
{
   static BOOL checked = NO;
   
   //Sandboxing is not going to change on us while we are running
   if(checked)
      return;
   
   checked = YES;
   
   if(xpc_connection_create == NULL){
      sandboxed = NO;
      networkClient = NO; //Growl.app 1.3+ is required to be a network client, Growl.app 1.3+ requires 10.7+
      return;
   }

   //This is a hacky way of detecting sandboxing, and whether we have network client on the main app is up to app developers
   NSString *homeDirectory = NSHomeDirectory();
   NSString *suffix = [NSString stringWithFormat:@"Containers/%@/Data", [[NSBundle mainBundle] bundleIdentifier]];
   if([homeDirectory hasSuffix:suffix]){
      sandboxed = YES;
      if(delegate && [delegate respondsToSelector:@selector(hasNetworkClientEntitlement)])
         networkClient = [delegate hasNetworkClientEntitlement];
      else
         networkClient = NO;
   }else{
      sandboxed = NO;
      networkClient = YES;
   }
   
      
   return;
}

@end
*/