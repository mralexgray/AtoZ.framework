
#import "NotifyingOperationQueue.h"
#import "Project.h"

@implementation  NotifyingOperation 
//@synthesize 	exitStatus= _exitStatus, elapsed = _elapsed, elapsedTime=_elapsedTime, endDate, startDate, stdOutDelegate = _stdOutDelegate, notifyBlock = _notifyBlock;

-       (NSUInteger) elapsed 				{ return (NSUInteger)round([self.endDate timeIntervalSinceDate:self.startDate]); }
-             (NSS*) elapsedTime 		{	return //[NSS stringWithFormat:@"%02lu:%02lu:%02lu findihed:%@", self.elapsed/3600, 
																		[NSS stringWithFormat:@"%02lu:%02lu",
																		(self.elapsed/60)%60, self.elapsed%60];
																		//,[self.dateFormatter stringFromDate:self.endDate]];
}
- (NSDateFormatter*) dateFormatter 		{	NSDateFormatter*  _dateFormatter = NSDateFormatter.new;
																				_dateFormatter.dateStyle = NSDateFormatterMediumStyle;
																				_dateFormatter.timeStyle = NSDateFormatterMediumStyle; return _dateFormatter;
}
@end
@implementation NSTaskOperation


- (NSBlockOperation*) notifyBlock {

	return _notifyBlock = _notifyBlock ?: ^{
	__block id blockSelf = self;
	return [NSBlockOperation blockOperationWithBlock:^{		NSTask *task = NSTask.new; NSPipe *outP = NSPipe.pipe; 

    	task.standardOutput 	= outP;	task.standardError 	= outP;
		NSFileHandle *outH = [outP fileHandleForReading];
		[outH waitForDataInBackgroundAndNotify];
	   [NSNotificationCenter.defaultCenter addObserver:blockSelf selector:@selector(setCommandOutput:) name:NSFileHandleDataAvailableNotification object:outH];
		task.currentDirectoryPath 	= [blockSelf launchPath];//_project.projectFolder;
		task.launchPath	 			= @"/bin/bash";
		task.arguments 				= @[@"-c",[NSString stringWithFormat:@" %@ %@", [blockSelf executable], [blockSelf args]]];
		NSLog(@"task arguments:%@", task.arguments);
//		[NSNotificationCenter.defaultCenter addObserver:blockSelf selector:@selector(taskOutputAvailable:) name:NSFileHandleReadCompletionNotification object:[blockSelf standOut]];
		[blockSelf setStartDate:NSDate.date];	//_project.startDate = NSDate.date;
	   
		[task setTerminationHandler:^(NSTask *r) {
			[blockSelf setEndDate:NSDate.date];///_project.endDate 		= NSDate.date;
			[blockSelf performSelectorOnMainThread:@selector(setExitStatus:) withObject:@(r.terminationStatus) waitUntilDone:YES];
			//_project.exitStatus = @(task.terminationStatus);
		}];
		[task launch];
		[task waitUntilExit];    
		
	}];
	}();
}
- (void) setCommandOutput:(NSNotification*)n { //NSLog(@"%s : %@", __PRETTY_FUNCTION__, n);
	
	NSData *data = nil; id j = nil; NSString *str = nil;
	if ([n respondsToSelector:@selector(object)]) j = [n valueForKey:@"object"]; else return;
	if (![j isKindOfClass:NSFileHandle.class]) 													 return; 
	data = [(NSFileHandle*)n.object availableData];							     if (!data) return;
	
	if ((str = [NSString.alloc initWithData:data encoding:NSASCIIStringEncoding]).length == 0) return; 
	if (self.stdOutDelegate && [self.stdOutDelegate respondsToSelector:@selector(stdOutDidOutput:)])
			[self.stdOutDelegate stdOutDidOutput:str];
	[(NSFileHandle*)n.object waitForDataInBackgroundAndNotify];
}
@end

@implementation NotifyingOperationQueue { NotifyingOperationQueueStatusView *_statusView; }
-        (id) init 										{
	if (!(self = super.init )) return nil;
	self.lastCommandExitStatus = @0;//SET UP NSSTATUSITEM
//	_statusItem 		 			= [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
//	_statusItem.highlightMode 	= YES;
//	_statusItem.enabled			= YES;
//	_statusView = [NotifyingOperationQueueStatusView.alloc initWithFrame:(NSRect){0,0,NSSquareStatusItemLength, NSSquareStatusItemLength}];
//	_statusItem.view = _statusView;
	_statusView.queue = self;
	[_statusView bind:@"statusColor" toObject:self withKeyPath:@"lastCommandExitStatus" options:0];
	return self; 
}
-      (void) addProjectWithPath:(NSS*)path 		{		
	self.lastCommandExitStatus = @1000;
	Project *_project = [Project instanceWithProjectPath:path]; 
				_project.stdOutDelegate = _statusView;
	__block Project* _blockProject = _project;
	[_project.notifyBlock setCompletionBlock:^{
			[self 				removeExistingNotifications:_blockProject];		// Remove existing notifications for the same command.
			[self deliverNotificationForCommandCompletion:_blockProject];  	// Send appropriate notification.
			self.lastCommandExitStatus = _blockProject.exitStatus;
//			[Project setSharedInstance:_project];
			[_blockProject save];
			[ProjectArchive addProject:_blockProject];
			[ProjectArchive save];
			[[_blockProject saveFolder]openInTextMate];
	
			NSLog(@"savefile: %@", [_blockProject saveFile]);
			// exit([((NSNu	mber*)result[CommandCompletionStatus]) intValue]); // Exit with the status of the command we executed.   
	}];
	[self addOperation:_project.notifyBlock];
}
- (NSInteger) maxConcurrentOperationCount 		{ return 1; }
-      (void) deliverNotificationForCommandCompletion:(Project*)proj	{
	// Deliver a notification. Values to construct the notification come from the userInfo object.
	//    NSS *title =  //userInfo[Command];
   UNOTE *userNote 					= UNOTE.new;
	[NotifyingOperation.class.propertyNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSLog(@"prop:%@  val:%@", obj, [proj valueForKey:obj]); 
	}];
	system([[NSString stringWithFormat:@"/usr/bin/say status \"%@\" &", proj.exitStatus]UTF8String]);
   userNote.title 					= proj.projectFilename;
   userNote.actionButtonTitle 	= proj.exitStatus 	? @"Open App" 	: @"Try Again";
	userNote.otherButtonTitle		= proj.exitStatus 	? @"Cheeky!"	: @"FARTS!";
	userNote.soundName 				= NSUserNotificationDefaultSoundName;
	userNote.subtitle 				= [NSString stringWithFormat:@"%@ %@",proj.exitStatus	? @"Built AOK!": @"Fail!", proj.elapsedTime];
   userNote.informativeText 		= proj.projectPath;// [NSS stringWithFormat:@"Project '%@' finsihed:%@.", /, proj.elapsedTime];
   userNote.hasActionButton 		= YES;
   userNote.userInfo 				= @{@"projectFolder": proj.projectFolder};
	UCENTER.delegate 					= self;
   [UCENTER scheduleNotification:userNote];
}
-      (void) removeExistingNotifications:				(Project*)proj	{

	// Remove all existing notifications that were created by running the same command in the same directory.
	 for (UNOTE *userNotification in UCENTER.deliveredNotifications) {
		if ([proj.projectFilename isEqualToString:userNotification.title] 
		  && [proj isEqualTo:userNotification.userInfo[@"operation"]]) 
		  	[UCENTER removeDeliveredNotification:userNotification];
	}
}
-      (void) userNotificationCenter:(UCTR*)center   didActivateNotification:(UNOTE*)n	{
   // Nothing for us to do here. It is unlikely that this application is going to be running when a user
   // clicks on a notification. However, in case it is we will log a message like we don in aplicationDidFinishLaunching

	NSS* folder = [[n.userInfo objectForKey:@"projectFolder"] stringByAppendingPathComponent:@"Build/Release"];
   NSLog(@"Notification activated %@... FOLDER: %@", n.informativeText, folder);
	NSArray* files = [NSFM contentsOfDirectoryAtPath:folder error:nil];
	if (files.count) {
		__block NSS *ratget = nil;
		[files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if ([obj hasSuffix:@"app"]) {  ratget = obj;  *stop = YES; }
		}];
		if (ratget)  {
			NSS* app =[folder stringByAppendingPathComponent:ratget];
			NSLog(@"apppath?  %@", app);
			[NSWorkspace.sharedWorkspace openFile: app];
		}
	}
}
-      (void) userNotificationCenter:(UCTR*)center    didDeliverNotification:(UNOTE*)n	{
	
    // We don't have anything to do when a notification is delivered.
}
-      (BOOL) userNotificationCenter:(UCTR*)center shouldPresentNotification:(UNOTE*)n {
    return YES;
}
-      (void) _checkTaskStatus: 	  														 (NSNOTE*)n	{
	
	NSTask* aTask	= n.object;
	int		aStatus = aTask.terminationStatus;
	if (aStatus)	 NSLog(@"Task %@ exited with non-zero exit status (%i).", [aTask arguments], aStatus);
	else	 NSLog(@"Task %@ suceeded.", [aTask arguments]);
}
@end
@implementation NotifyingOperationQueueStatusView
- (NSAttributedString*) displayString 			{	

	return [self setNeedsDisplay:YES], 	
	[NSAttributedString.alloc initWithString:
	[NSString stringWithFormat:@"%ld", self.queue.operationCount] attributes:
	@{	NSForegroundColorAttributeName:NSColor.whiteColor, NSFontNameAttribute:[NSFont fontWithName:@"UbuntuMono-Bold" size:18], NSFontSizeAttribute:@22}];
}
-  (NSColor*) statusColor 							{
//	if (_queue.operationCount != 0) {  
//		if (!_prog) { _prog = NSProgressIndicator.new; _prog.indeterminate = YES; _prog.style = NSProgressIndicatorSpinningStyle; 
//								_prog.controlSize = NSRegularControlSize; _prog.frame = self.bounds; [self addSubview:_prog]; _prog.wantsLayer = YES;
//		}
//		[_prog setAlphaValue:1];
//		[_prog startAnimation:nil];
//	/} else if (_prog) { [_prog stopAnimation:nil]; [_prog setAlphaValue:0];  }
	return  _statusColor 	=
	_queue.operationCount != 0  ||  [_queue.lastCommandExitStatus isEqualToNumber:@1000] ? [NSColor orangeColor]
		 :	[_queue.lastCommandExitStatus isEqualToNumber:@0] 	? [NSColor greenColor] : NSColor.whiteColor;
}
-      (void) drawRect:			   (NSRect)r	{	

	[self.statusColor set]; NSRectFill(self.bounds);	
	[self.displayString drawAtPoint:(NSPoint) {5,5}];	if (!_stdOutWindow) [self stdOutWindow]; 
}
-      (void) mouseDown:       (NSEvent*)e 	{ 	[self showWindow: !_stdOutWindow.isVisible]; }
-      (void) showWindow:          (BOOL)s  	{	s ? [NSApplication.sharedApplication activateIgnoringOtherApps:YES] : nil;
															 	s ? [self.stdOutWindow makeKeyAndOrderFront:nil] 
																  : [_stdOutWindow orderOut:nil];
																s ? [_stdOutWindow.animator setAlphaValue:1.0]
																  : [_stdOutWindow.animator setAlphaValue:0];
}
- (NSWindow*) stdOutWindow 						{

	return _stdOutWindow = _stdOutWindow ?: ^{		NSScrollView *sv, *sv2;	NSRect screenFrame; NSRect r1, r2;
		
		_stdOutWindow = [NSWindow.alloc initWithContentRect:(NSRect){0,0,(screenFrame = NSScreen.mainScreen.frame).size.width,200} 
											styleMask:NSBorderlessWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
		r1 = AZRectExceptWide(_stdOutWindow.frame, _stdOutWindow.width/2);
		[_stdOutWindow.contentView addSubview: sv  = [NSScrollView.alloc initWithFrame:r1]];
		r2 = AZRectExceptOriginX(sv.bounds, sv.width);
		[_stdOutWindow.contentView addSubview:	sv2 = [NSScrollView.alloc initWithFrame:r2]];
		sv.hasVerticalScroller = sv2.hasVerticalRuler = YES;
		[sv setValue: _tv = [NSTextView.alloc initWithFrame:_stdOutWindow.frame] forKey:@"documentView"];
		[sv2 setValue:_ov = [NSOutlineView.alloc initWithFrame:sv2.bounds]       forKey:@"documentView"];
		NSTableColumn *head	= [NSTableColumn.alloc initWithIdentifier: @"projects"];
		NSTableColumn *data 	= [NSTableColumn.alloc initWithIdentifier:     @"info"];
		[_ov addTableColumn:head];
		[_ov addTableColumn:data];
		_ov.outlineTableColumn 	= head;
		_ov.floatsGroupRows 		= NO;
		[_ov expandItem:nil expandChildren:YES];
		_ov.dataSource = ProjectArchive.sharedInstance;
		_ov.delegate 	= ProjectArchive.sharedInstance;
//		[_ov bind:@"contents" toObject:[ProjectArchive sharedInstance].tc withKeyPathUsingDefaults:@"arrangedObjects"];

		_tv.font 				= [NSFont fontWithName:@"UbuntuMono-Bold" size:18];
		_tv.textColor 			= [NSColor whiteColor];
		_tv.backgroundColor 	= [NSColor colorWithCalibratedWhite:.1 alpha:.9];
		_stdOutWindow.frameTopLeftPoint = (NSPoint){0, screenFrame.size.height - [NSStatusBar.systemStatusBar thickness]};
		return _stdOutWindow;
	}();
}
-      (void) stdOutDidOutput:(NSString*)s 	{	  NSRange myRange;	_tv.string = [_tv.string stringByAppendingString:s];	myRange.location = _tv.string.length;	[_tv scrollRangeToVisible:myRange]; [self showWindow:YES]; }
@end


//		[self removeExistingNotifications:_project];	// Remove existing notifications for the same command.[self deliverNotificationForCommandCompletion:_project];  	// Send appropriate notification. Exit with the status of the command we executed.    exit([((NSNumber *)result[CommandCompletionStatus]) intValue]);};
//- (instancetype) initWithExecutable:(NSString*)e launchPath:(NSString*)p args:(NSArray*)a stdOutDelegate:(id<StdOutDelegate>)d completion:(void(^)(void))blk {
//}

//- (id) init {
//	if (self != super.init ) return nil;
////	self.stdOutDelegate = d;
//	self.completionBlock = blk;
//	return self;
//}
