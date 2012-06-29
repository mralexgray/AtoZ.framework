//
//  AZMenuBarAppController.m
//  AtoZ
//

#import "AZMenuBarAppController.h"

@implementation AZMenuBarAppController
//@synthesize 	dbx,	dbxGrid,	appList,		mLabelArray;
//@synthesize 	startupIndicator,	statusText,		advanceCounter,
//				menuItemView,		startupView, 	attachedWindow,
//				pieWindow,			gEditor,		gView, statusItem, menu;

-(NSPoint)menuPoint {
//	NSLog(@"Status: %@, mennu: %@", [statusItem propertiesPlease], [menuItem propertiesPlease]);
	NSPoint p = NSMakePoint(NSMidX([[statusItem view]frame]),NSMinY([[statusItem view] frame]));
	NSPoint nonlocal = [[NSScreen mainScreen] convertToScreenFromLocalPoint:p relativeToView:[statusItem view]];
//	NSLog(@"Menupoint calkled: %@", NSStringFromPoint(nonlocal));
	return nonlocal;
}



- (NSMenuItem *) quitMenuItem
{
  NSMenuItem *mi = [[NSMenuItem alloc] init];
  mi.title = @"Quit";
  mi.action = @selector(quit:);
  mi.target = self;
  return mi;
}

- (void) quit:(id)sender
{
  [[NSApplication sharedApplication] terminate:self];
}



- (void) toggleWindow {
	[attachedWindow performSelector:NSSelectorFromString( retracted ? @"slideDown" : @"slideUp")];
	retracted = !retracted;
}

- (void) applicationDidResignActive:(NSNotification *)notification{ if (!retracted)	[self toggleWindow]; }

- (void)awakeFromNib {						startupSteps = $map(
				@"StartingUp", 				@"1",
				@"Checking accessibility", 	@"2",
				@"Counting dock Items", 	@"3",
				@"Computing colors",		@"4",
				@"Success!",					@"5"	);
	uDefs 		= [NSUserDefaults 	standardUserDefaults];
	screen 		= [[NSScreen 		mainScreen]frame];
	statusItem 	= [[NSStatusBar 	systemStatusBar] statusItemWithLength:30];
 	menuItemView 	= [[AGMenuItemView 	alloc]
						initWithFrame:	NSMakeRect(0, 0, [[NSStatusBar systemStatusBar] thickness], 30)
						controller:	self];
	menu 			= [[NSMenu alloc] initWithTitle:@"Spaces"];
  	[menu addItem:	  [NSMenuItem separatorItem]];
	[menu addItem:	  [self quitMenuItem]];
	statusItem.menu = menu;
   	statusItem.view = menuItemView;

	activeView 	= startupView;		retracted 	= YES;
	[self attachedWindow];  			//init dropdown window

}

- (void)toggleAttachedWindowAtPoint:(NSPoint)pt withView:(NSView*)aView {
	if (	([[attachedWindow contentView] isNotEqualTo:aView] ) &
			([aView isNotEqualTo:nil]) ) {
				[self swapAttachedViewWithView:aView];
	}
	(retracted ? [attachedWindow slideDown] : [attachedWindow slideUp]);
}

- (void)swapAttachedViewWithView:(id)aView {

	if ( [attachedWindow.mainView isNotEqualTo:aView]) {
		NSRect frameNow = [attachedWindow.mainView frame];
		NSRect frameThen = [aView bounds];
		[aView setHidden:YES];

		[attachedWindow.mainView fadeToFrame:NSZeroRect];
//		AGRightEdge(frameNow, frameNow.size.width];
//		
//				[aView setFr
	}
//		[attachedWindow setFrame:AGMakeRect([self windowOriginWithFrame:[aView frame]],[aView frame].size) display:YES animate:YES];
//
//
//		void (^fadeOutSwapOutFadeIn)(id, NSUInteger, BOOL *) = ^(id aFooNumber, NSUInteger idx, BOOL *stop) {
//    NSLog(@"Amazing BLOCK 2 %@", aFooNumber);
//};
//
//
//		[activeView performBlock:^{
//			[self performSelectorOnMainThread:@selector(fadeOut) withObject:nil waitUntilDone:YES];
//
//
//		}
	[activeView fadeOut];
	activeView = aView;
	attachedWindow.mainView = activeView;
	[activeView fadeIn];

}

-(DBXWindow*)attachedWindow {
	if (!attachedWindow)
		attachedWindow = [DBXWindow windowWithFrame:[activeView frame]];
	[attachedWindow setDelegate:self];
	[attachedWindow setContentView:activeView];
	[attachedWindow setFrameOrigin:[self windowOriginWithFrame:[activeView frame]]];
//	[attachedWindow setMovableByWindowBackground:YES];
//	[attachedWindow display];
	return attachedWindow;
}

-(NSPoint)windowOriginWithFrame:(NSRect)frame {
	NSPoint windowOrigin = [self menuPoint];
	windowOrigin.x -= frame.size.width / 2;
	if		  ( frame.size.width == screen.size.width ) {  //full width window
				windowOrigin.x =  0;
	} else if ( windowOrigin.x + frame.size.width > screen.size.width ) { //too close to right
				windowOrigin.x = screen.size.width - frame.size.width - 20;
	}
//	if ( (retracted) & (windowOrigin.y < windowFrame.origin + 22) ) {
	windowOrigin.y = (retracted ? NSMaxY(screen) : NSMaxY(screen) - frame.size.height - 20 - 22);
	return windowOrigin;
}


-(void) applicationDidFinishLaunching:(NSNotification *)notification {
//	[self toggleAttachedWindowAtPoint:NSMakePoint(NSMidX(menuItem.frame), NSMinY(menuItem.frame))];
	//	NSLog(@"amIauthorized = %i, %@", trusted, (trusted ? @"YES, Authorized" : @"NO, NOT authorized"));

	counter = 0;
	startupIndicator.maxValue 		= 100;	startupIndicator.cornerRadius 	= 5;
	startupIndicator.hidden 			= NO;	startupStatusText.textColor 	= WHITE;

	startupTimer 	= [NSTimer 	scheduledTimerWithTimeInterval:2 target:self
								selector:@selector(setStartupStepStatus:) userInfo:nil repeats:YES];
	[NSApp activateIgnoringOtherApps:YES];
	retracted = ( [attachedWindow isVisible] ? NO : YES);
	if (retracted) [self toggleWindow];
	[startupUnlock fadeIn];

//	progressTimer 	= [NSTimer scheduledTimerWithTimeInterval:.1 target:self
//							 	Selector:@selector(progressAdvance) userInfo:nil repeats:YES];
}


	//		attachedWindow = [[MAAttachedWindow alloc] initWithView:activeView attachedToPoint:pt inWindow:[menuItem window]  onSide:MAPositionBottom atDistance:0];
	//		attachedWindow.arrowHeight = 0;
	//		attachedWindow.borderWidth = 0;
	//		attachedWindow.cornerRadius = 0;
	//		NSRect now = attachedWindow.frame;
	//		now.origin.y = screen.size.height;
	//		[attachedWindow slideUp];
	//		[attachedWindow setFrameOrigin:NSMakePoint(attachedWindow.frame.origin.x, NSMaxY(attachedWindow.frame))];
-(IBAction) advanceCounter:(id)sender{
	[self setStartupStepStatus:counter+1];

}
- (void) progressAdvance {
	NSInteger now = startupIndicator.doubleValue; NSInteger nowPlus = (now + 1);
	[menuItemView setString:$(@"%ld", now)];
	//	NSLog(@"NOW++: %@", [startupIndicator propertiesPlease]);
	if (now < 100) { [startupIndicator setDoubleValue:nowPlus];
		[startupIndicator setNeedsDisplay:YES];}
	else [progressTimer invalidate];
}

-(void) setNumberOfDBXObjects:(NSUInteger)objects {

	NSInteger now = startupIndicator.doubleValue;
	NSInteger nowPlus = (now + 1);
	[menuItemView setString:$(@"%i", objects)];
	NSLog(@"Delegate got updated count of: %ld", objects);
	if (now < 100) { [startupIndicator setDoubleValue:nowPlus];
		[startupIndicator setNeedsDisplay:YES];
	}
	else [progressTimer invalidate];
}

-(void) setStartupStepStatus:(NSUInteger)status {

	counter = status;
	if ( counter < [[startupSteps allKeys]count] ) {
		NSString *step = [startupSteps valueForKey:$(@"%i",counter)];
		NSLog(@"Step %i... %@",counter, step);
		[startupStatusText setStringValue:step];
		[startupStatusText 	setNeedsDisplay:YES];
		switch (counter) {
			case 0:	[startupUnlock fadeIn]; [self advanceCounter:self];    break;
			case 1: trusted = amIAuthorized(); break;
			case 2:	if (trusted) {
				[startupCountHand fadeIn];
				[self advanceCounter:self];
				}
				break;
			case 3:  { localApps = [dbx appArray].copy;
					[localApps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				NSLog(@"raw obj: %@", obj); }];

				break;
				}
				break;
					//	[dbx performSelectorInBackground:@selector(appArray) withObject:nil];
			case 4:	[startupSuccess fadeIn]; [self advanceCounter:self]; break;
			default:	break;
		}
	} else [self didFinishDBXInit];
}
-(void) didFinishDBXInit {

		NSLog(@"DELEGATE SAYS: DOck is finnished!");
		[startupTimer invalidate];
		self.dbxGrid = [[DBXGridView alloc]initWithFrame:NSMakeRect(0,0,screen.size.width,screen.size.width *.3)];
		[self swapAttachedViewWithView:dbxGrid];
//		[self.attachedWindow setFrame:new display:YES];
//		[[attachedWindow contentView]replaceSubview:startupView with:bv];
//		[self menuWindowNeededAtPoint:NSMakePoint(NSMidX(menuItem.frame), NSMinY(menuItem.frame))];
		if (retracted) [attachedWindow slideDown];
}

-(BOOL) isItTrusted {
   	NSTask 		*authWorker = [NSTask new];  NSPipe *pipe= [NSPipe new];
	NSArray 	*args 		= $array(@"-stringArg", @"testIfAccessabilityIsEnabled");
	NSString 	*launchP 	= [[NSBundle mainBundle]pathForAuxiliaryExecutable:@"AGAuthTool"];
	NSLog(@"Testing auth with path: %@.  And args: %@", launchP, args);

	[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObject: @"/tmp/script2.sh"]];

	[authWorker setStandardOutput:pipe]; 	[authWorker setLaunchPath: launchP];
	[authWorker setArguments:args];			[authWorker launch];
	[authWorker waitUntilExit];
	NSData 		*data 		= [[pipe fileHandleForReading] readDataToEndOfFile];
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog (@"got\n%@", string);
	//	NSString *results = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding];
	//	NSLog(@"taskdeleagte is done. raw results: %@", results);
	return NO;
}
- (void)dealloc { [[NSStatusBar systemStatusBar] removeStatusItem:statusItem]; }

- (void) finishStartup {
//	[[view animator] setFrameOrigin:NSMakePoint(view.frame.origin.x, view.frame.origin.y+300)];
[NSAnimationContext beginGrouping]; [[NSAnimationContext currentContext] setDuration:5.0f];
for (NSView *thing in [startupView subviews]) {  // viewDisposal) {
	[[thing animator]setFrameOrigin:NSMakePoint(thing.frame.origin.x, thing.frame.origin.y+screen.size.height)];
}

[NSAnimationContext endGrouping];
}


//	else {
//		[self performSelectorOnMainThread:@selector(finishStartup) withObject:nil waitUntilDone:NO];
//		return;
//	}
//	switch (counter) {
//		case 0: {	[startupUnlock setEnabled:YES];	break;	}
//		case 1: {
//			NSString *test = $(@"Process %@ Trusted", ( [self isItTrusted] ? @"IS" : @"NOT"));
//			NSLog(@"%@", test);
//
//			[startupStatusText setStringValue:test];
//
//
//			if([checkAuthBox state] == NSOnState)		{
//				//			[menuController loadStatusMenu];
//
//				if ( [returnVal intValue] >= 0) break;
//				else { NSBeep();
//					CALayer *windowLayer = [CALayer layer];
//					[[[startupIndicator window] contentView]setLayer: windowLayer];
//					[[[startupIndicator window] contentView]setWantsLayer:YES];
//					windowLayer.backgroundColor = cgRED;
//					[tasker performSelectorOnMainThread:@selector(queryWorkerFor:)
//											 withObject:@"trust" waitUntilDone:YES];
//					[startupUnlock setImage:[[NSImage imageNamed:@"thumbsup.white.png"]rotated:180]];
//					[numberOfItems setTitle:@"Wonk WOnk"];
//				}
//			}
//			break;
//		}
//		case 2:	{
//			[startupCountHand setEnabled:YES];  NSBeep();
//			if (!dbx.appArray)
//				[numberOfItems setTitle:@"N/A!"];
//			else
//				[numberOfItems setTitle:[NSString stringWithFormat:@"%i", dbx.appArray.count]];
//			break;
//		}
//		case 3: { [startupSuccess setEnabled:YES]; 	}
//			//		case 4: {
//			//				for ( id aView in views) [(NSView*)aView:aView];
//			//			NSLog(@"%@",[[startupUnlock window]propertiesPlease]);
//			//				NSLog(@"Contemtview layers: %@", [[[startupIndicator window] contentView]layer]);
//			//				menuController.windowContentView = _startupView;
//			//				NSRect orgi = [[menuController windowContentView]frame];
//			//				[[[menuController windowContentView] animator] 	setFrameOrigin: NSMakePoint(												orgi.origin.x - 400,orgi.origin.y)];
//			//				[menuController toggleMenuAppWindow:self];//[menuController.windowContentView ];// loadStatusMenu];
//			//				menuController.isWindowVisible = NO;
//			//			break;
//			//	[statusItemPrototype startAnimation:statusItemPrototype];
//			//	menuController.menuWindow = _window;
//			//	Sets up the status item.
//			//		}
//		default:
//		{
//			[NSAnimationContext beginGrouping]; [[NSAnimationContext currentContext] setDuration:5.0f];
//			for (id NSView *thing  in viewDisposal) {//	[viewDisposal shift];

//				 :NSMakePoint(thing.frame.origin.x, thing.frame.origin.y+300) disp ];
//				NSDictionary *animDict = [NSDictionary dictionaryWithObjectsAndKeys:
//					view, NSViewAnimationTargetKey, NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey, nil];
//				NSViewAnimation *anim = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:animDict]];
//				[anim setDuration:0.5];
//				[anim setAnimationBlockingMode:NSAnimationNonblockingThreaded];
//				[anim performSelector:@selector(startAnimation) withObject:nil afterDelay:timed];
//				timed = (timed + 1.0);
//			}
//Tell the threads to stop, then wait for them to comply.
//			[startupTimer invalidate];
//			[self performSelectorOnMainThread:@selector(finishStartup) withObject:nil waitUntilDone:NO];
//			break;
//		}
//	}


//    [NSAnimationContext beginGrouping];
//	[[NSAnimationContext currentContext] setDuration:1.0];
//	[attachedWindow setFrame:(retracted ? visibleFrame : retractedFrame) display:NO animate:NO];
//	NSPoint toggle = (retracted ?
//		NSMakePoint(attachedWindow.frame.origin.x, attachedWindow.frame.origin.y - NSHeight(attachedWindow.frame)) :
//		NSMakePoint(attachedWindow.frame.origin.x, attachedWindow.frame.origin.y + NSHeight(attachedWindow.frame)));
//	[[attachedWindow animator] setFrameOrigin:toggle];
//    [NSAnimationContext endGrouping];

//	NSDictionary *shade = [NSDictionary dictionaryWithObjectsAndKeys:
//								attachedWindow, NSViewAnimationTargetKey,
//							   	[NSValue valueWithRect:(retracted ? retractedFrame : visibleFrame)], NSViewAnimationStartFrameKey,
//							   [NSValue valueWithRect:(retracted ? visibleFrame : retractedFrame)], NSViewAnimationEndFrameKey, nil];
//	NSViewAnimation *ani = [[NSViewAnimation alloc] initWithDuration:.3 animationCurve:NSAnimationEaseInOut];
//	[ani setViewAnimations:$array(shade)];
//	[ani setAnimationBlockingMode: NSAnimationNonblockingThreaded];
//	NSMutableArray *animations = [NSMutableArray arrayWithObject:ani];
//	for (NSButton *obj in $array(startupUnlock, startupCountHand, startupSuccess)) {
//		NSRect up = obj.frame;
//		up.origin.y +=  500;
//		NSDictionary *buttonDown = $map(	obj, NSViewAnimationTargetKey,
//											[NSValue valueWithRect:up], NSViewAnimationStartFrameKey,
//											[NSValue valueWithRect:obj.frame], NSViewAnimationEndFrameKey);
//		NSViewAnimation * cA = [[NSViewAnimation alloc]initWithViewAnimations:$array(buttonDown)];
//		[cA setDuration: 2];
//		[cA startWhenAnimation:[animations lastObject] reachesProgress:1];
//		[animations addObject:cA];
//	}

//		NSPoint up = NSMakePoint(obj.frame.origin.x,obj.frame.origin.y + 300);
//				//(NSMaxX(startupView.frame)/3-(obj.frame.size.width/2)), NSMaxY(attachedWindow.frame));
////		end.origin.y -= 300;// (NSMaxY(attachedWindow.frame) + 29);
//		[obj setHidden:YES];
//		[obj setFrame: end];
//		NSDictionary *fadeIn = $map (obj, NSViewAnimationTargetKey,
//                                   NSViewAnimationFadeInEffect,
//                                   NSViewAnimationEffectKey);
//		NSViewAnimation * cA = [[NSViewAnimation alloc]initWithViewAnimations:$array(fadeIn)];
//		[cA setAnimationCurve:NSAnimationEaseInOut];
//	    [cA setDuration: 2];
//		[cA performSelector:@selector(startAnimation) afterDelay:(idx*del)];
//	}];
//	retracted = !retracted;


//
//	[ enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		[self performSelector:@selector(animateStringFrames:) withObject:nil afterDelay:0.2];
//
//
//	if ( activeView == startupView ) {
//
//		[startupIcons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//			NSButton *b = obj;
//			[b setFrame:upRect];
////			[b setHidden:NO];
//			NSDictionary *buttonDown = $map(
//											b, NSViewAnimationTargetKey,
//											[NSValue valueWithRect:upRect], NSViewAnimationStartFrameKey,
//											[NSValue valueWithRect:normalRect], NSViewAnimationEndFrameKey);
//			__block NSViewAnimation * aniButton = [[NSViewAnimation alloc] initWithDuration:1 animationCurve:NSAnimationEaseInOut];
//			[aniButton setAnimationBlockingMode: NSAnimationNonblockingThreaded];
//			[aniButton setViewAnimations:$array(buttonDown)];
//			if (idx != 0) [aniButton startWhenAnimation:[allAnis last] reachesProgress:1];
//			[allAnis addObject:aniButton];
//			[aniButton startAnimation];
//		}];
//	}

//[NSApp activateIgnoringOtherApps:YES];
//	__weak SimpleView *c = [[SimpleView alloc]initWithFrame:NSMakeRect(0,0,[[NSScreen mainScreen]frame].size.width - 100, 29)];
//
//
//	__block float unit = c.frame.size.width / dbx.sortedApps.count;
//	[[dbx.sortedApps valueForKeyPath:@"color"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		SimpleView *ss = [[SimpleView alloc]initWithFrame:NSMakeRect( unit * idx, 0, unit, c.frame.size.height)];
//		ss.backgroundColor = [[dbx.sortedApps objectAtIndex:idx]valueForKey:@"color"];
//		[c addSubview:ss];
//
//	}];
//
//	//	AGGradientView *c = [[AGGradientView alloc]initWithFrame:NSMakeRect(0,0,[[NSScreen mainScreen]frame].size.width - 100, 29)];
//	//	c.startingColor = RANDOMCOLOR;
//	//	c.endingColor = RANDOMCOLOR;
//	//	c.angle = 0;
//	//	c.colorPoints = [dbx.sortedApps valueForKeyPath:@"color"];
//	//$array(RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR, RANDOMCOLOR);
//	//	 [self.dbx.appArray arrayWithKey:@"color"];// arrayUsingBlock:^id(id obj) {
//	//		DBXApp *app = obj;
//	//		NSLog(@"%@", [app.color crayonName]);
//	//		return app.color;
//	//	}];
//
//	//$array(RED, BLUE, YELLOw);
//	//[self.dbx.appArray valueForKeyPath:@"color"];
//
//	//	[gEditor setFrame:NSInsetRect(c.frame, 0,0)];
//	//	[gView setFrame:NSInsetRect(c.frame, 29,29)];
//	//	[c addSubview:gView];
//
//	//	[c addSubview:gEditor];
//
//	//	[gEditor setTarget: gView];
//	//	[gView setGradient:gg];
//	//  [gView setAngle: 90];
//
//	//	[c addBoxesWithColors:[dbx.sortedApps valueForKeyPath:@"color"]];
//    // Attach/detach window.
//    if (!attachedWindow) {
//		//		[c lockFocus];
//		//		NSGradient *gg = [[NSGradient alloc]initWithColors:$array(RED, BLUE, YELLOw)];
//		//	//    [self gradientChanged: self];
//		//		[gg drawInRect:c.frame angle:80];
//		//		[c unlockFocus];
//
//        attachedWindow = [[MAAttachedWindow alloc] initWithView:c
//						  //		view
//                                                attachedToPoint:pt
//                                                       inWindow:nil
//                                                         onSide:MAPositionBottom
//                                                     atDistance:5.0];
////        [textField setTextColor:[attachedWindow borderColor]];
////        [textField setStringValue:@"Your text goes here..."];
//        [attachedWindow makeKeyAndOrderFront:self];
//    } else if (!appList) {
//		AGFoamRubberView *c1 = [[AGFoamRubberView alloc]initWithFrame:NSMakeRect(0,0,[[NSScreen mainScreen]frame].size.width - 100, [[NSScreen mainScreen]frame].size.height - 200)];
//		__weak AGBoxView *c2 = [[AGBoxView alloc]initWithFrame:c1.frame];
//		[dbx.sortedApps.reversed enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//			DBXApp *app = obj;
//			AGBox *b = [[AGBox alloc]initWithFrame:NSMakeRect(0,0,100,100)];
//			b.representedObject = app;
//			[c2 addSubview:b];
//		}];
//		[c2 doLayout];
//        appList = [[MAAttachedWindow alloc] initWithView:c2
//				   //		view
//										 attachedToPoint:NSMakePoint(pt.x,pt.y-36)
//												inWindow:nil
//												  onSide:MAPositionBottom
//											  atDistance:5.0];
//
//		[appList makeKeyAndOrderFront:self];
//	} else {
//        [attachedWindow orderOut:self];
//        [appList orderOut:self];
//        attachedWindow = nil;
//		appList = nil;
//    }
//}

//- (void)togglePieViewAtPoint:(NSPoint)aPoint forApp:(DBXApp*)anApp{   //MAAttachedWindow
//	[appList removeChildWindow:pieWindow];
//	[attachedWindow orderOut:self];
//	attachedWindow = nil;
//	AGPieView *aPieView = [[AGPieView alloc]initWithFrame:NSMakeRect(0,0,150,150)];
//	NSAttributedString *labelString = [[NSAttributedString alloc]initWithString:	[NSString stringWithFormat: @"%@\nSpot: %i.\n X:%@  Y:%@", anApp.name, anApp.spot, anApp.x, anApp.y]
//																	 attributes:[NSDictionary dictionaryWithObjects:	[NSArray arrayWithObjects:
//																														 [NSColor randomColor], @"Ubuntu Mono Bold", [NSNumber numberWithInt:18], nil]
//																											forKeys:[NSArray arrayWithObjects:
//																													 NSForegroundColorAttributeName, NSFontNameAttribute, NSFontSizeAttribute, nil]]];
//	//		NSRect framee = pieView.frame; framee.size.height += label.frame.size.height;
//	//		*aPieView = [[AGPieView alloc]initWithFrame:cell2.frame]; [aPieView addSubview:label];
//	//		[pieText setAttributedStringValue:labelString];/// drawInRect:[label frame]];
//	[aPieView setSliceValues:anApp.colors];
//	int side = 12; //[sidePopup indexOfSelectedItem];
//	NSPoint buttonPoint = aPoint;
//	//NSMakePoint(NSMidX([toggleButton frame]), NSMidY([toggleButton frame]));
//	attachedWindow = [[MAAttachedWindow alloc] initWithView:aPieView attachedToPoint:buttonPoint        inWindow:appList onSide:side  atDistance:10.];
//	[attachedWindow setBorderColor:[anApp.color contrastingForegroundColor]];//[borderColorWell color]];
//	//        [textField setTextColor:[borderColorWell color]]; [pieView setSliceValues:[anApp valueForKey:@"colors"]];
//	[attachedWindow setBackgroundColor:anApp.color];
//	//		[backgroundColorWell color]];
//	[attachedWindow setViewMargin:19];//viewMarginSlider floatValue]];
//	[attachedWindow setBorderWidth:6];//[borderWidthSlider floatValue]];
//	[attachedWindow setCornerRadius:3];//[cornerRadiusSlider floatValue]];
//	[attachedWindow setHasArrow:YES];//([hasArrowCheckbox state] == NSOnState)];
//	[attachedWindow setDrawsRoundCornerBesideArrow:YES];
//	//            ([drawRoundCornerBesideArrowCheckbox state] == NSOnState)];
//	//        [attachedWindow setArrowBaseWidth:[arrowBaseWidthSlider floatValue]];
//	[attachedWindow setArrowHeight:14];//[arrowHeightSlider floatValue]];
//	[attachedWindow setAlphaValue:0.0];
//
//	[appList addChildWindow:attachedWindow ordered:NSWindowAbove];
//	[NSAnimationContext beginGrouping];
//	[[NSAnimationContext currentContext] setDuration:0.5];
//	//		[attachedWindow makeKeyAndOrderFront:self];
//	[[attachedWindow animator] setAlphaValue:1.0];
//	[NSAnimationContext endGrouping];
//
//	[labelString drawInRect:NSInsetRect(aPieView.frame, 3, 120)];
//}

//	NSRect p =  NSMakeRect(0, (screen.size.height - 72), screen.size.width, 50);
//	[menuController.menuWindow setFrame:p display:YES animate:YES];
//	[menuController.windowContentView addSubview:colorCollectionBar];
//	[colorCollectionBar setCellSize:NSMakeSize(
//											   ([[NSScreen mainScreen]frame].size.width / (float)content.count), 50)];
//	[colorCollectionBar setDesiredNumberOfRows:1];
//	[colorCollectionBar reloadData];

//-(void) testTrust {
//	NSDictionary *d = [self makeTaskWrapper];
//	[[d valueForKey:@"task"] setArguments: $array(@"-stringArg", @"testIfAccessabilityIsEnabled")];
//	[(NSString*)[d valueForKey:@"handle"] readDataToEndOfFile] encoding:NSASCIIStringEncoding];
//	NSLog(@"taskdeleagte is done. raw results: %@", results);
//}
//-(void) authorizeTrust {
// 	NSTask *task =[self makeTaskWrapper];
//	[task setArguments: $array(@"-stringArg", @"makeProcessTrusted")];
//	[authWorker launch];
//  	NSString *results = [[NSString alloc] initWithData:[handle readDataToEndOfFile] encoding:NSASCIIStringEncoding];
//	NSLog(@"taskdeleagte is done. raw results: %@", results);
//}


//- (void)mouseDown:(NSEvent *)theEvent {
//		/* get themouse location in local coordinates */
//		NSPoint initialMouseLocation = [theEvent locationInWindow];
//		if( initialMouseLocation.x >= ([self frame].size.width - 15) && initialMouseLocation.y <= 15 ) {
//			 isResizeOperation= YES;
//			 initialWindowFrame= [self frame];
//		}
//		else
//		{
//			 isResizeOperation= NO;
//		}
//}
//
//- (void)mouseDragged:(NSEvent *)theEvent
//{
//
//		if(isResizeOperation) // resize the window
//		{
//			 /* get the current local mouse location via the global
//coordinates,
//					this ensures we get the right coordinates in case the resizing
//of the window is not following fast enough */
//			 NSPoint currentLocation = [self convertBaseToScreen:[self
//mouseLocationOutsideOfEventStream]];
//			 currentLocation.x -= initialWindowFrame.origin.x;
//			 currentLocation.y -= initialWindowFrame.origin.y;
//
//			 float deltaX= currentLocation.x - initialMouseLocation.x;
//
//			 NSRect newFrame= initialWindowFrame;
//			 newFrame.size.width= initialWindowFrame.size.width + deltaX;
//
//			 /* your min-size goes here,
// you can do something like this: */
//			 if( newFrame.size.width &lt; 100 )
//					newFrame.size.width= 100;
//
//			 /* set the height according to the windows aspect-ratio */
//			 newFrame.size.height= newFrame.size.width / [self
//aspectRatio].width * [self aspectRatio].height;
//			 float deltaY= newFrame.size.height -
//initialWindowFrame.size.height;
//
//			 newFrame.origin.x= initialWindowFrame.origin.x;
//			 newFrame.origin.y= initialWindowFrame.origin.y - deltaY;
//
//			 [self setFrame:newFrame display:YES];
//		}
//}

@end
