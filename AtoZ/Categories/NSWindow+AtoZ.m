//
//  NSWindow+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <objc/objc.h>
#import <QuartzCore/QuartzCore.h>
#include <sys/sysctl.h>
#import <AppKit/AppKit.h>
#import "AtoZ.h"

#import "NSWindow+AtoZ.h"

@implementation NSWindow (AtoZ)

-(NSPoint)midpoint {
NSRect frame = [self frame];
NSPoint midpoint = NSMakePoint(frame.origin.x + (frame.size.width/2),
                               frame.origin.y + (frame.size.height/2));
return midpoint;
}

-(void)setMidpoint:(NSPoint)midpoint {
	NSRect frame = [self frame];
	frame.origin = NSMakePoint(midpoint.x - (frame.size.width/2),
							   midpoint.y - (frame.size.height/2));
	[self setFrame:frame display:YES];
}

/**	   NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
 [button setBezelStyle:NSRecessedBezelStyle];
 NSButton *closeButton = [NSWindow standardWindowButton:NSWindowZoomButton forStyleMask:self.window.styleMask];
 [self.window addViewToTitleBar:button atXPosition:self.window.frame.size.width - button.frame.size.width - 10];
 [self.window addViewToTitleBar:closeButton atXPosition:70]; */

-(void)addViewToTitleBar:(NSView*)viewToAdd atXPosition:(CGFloat)x {
	viewToAdd.frame = NSMakeRect(x, [[self contentView] frame].size.height, viewToAdd.frame.size.width, [self heightOfTitleBar]);
	
	NSUInteger mask = 0;
	if( x > self.frame.size.width / 2.0 )
	{
		mask |= NSViewMinXMargin;
	}
	else
	{
		mask |= NSViewMaxXMargin;
	}
	[viewToAdd setAutoresizingMask:mask | NSViewMinYMargin];
	
	[[[self contentView] superview] addSubview:viewToAdd];
}

-(CGFloat)heightOfTitleBar {
	NSRect outerFrame = [[[self contentView] superview] frame];
	NSRect innerFrame = [[self contentView] frame];
	
	
	return outerFrame.size.height - innerFrame.size.height;
}

/*
 * @brief Set content size with animation
 */
- (void)setContentSize:(NSSize)aSize display:(BOOL)displayFlag animate:(BOOL)animateFlag
{
	NSRect  frame = [self frame];
	NSSize  desiredSize;
	
	desiredSize = [self frameRectForContentRect:NSMakeRect(0, 0, aSize.width, aSize.height)].size;
	frame.origin.y += frame.size.height - desiredSize.height;
	frame.size = desiredSize;
	
	[self setFrame:frame display:displayFlag animate:animateFlag];
}


/** @brief 	The method 'center' puts the window really close to the top of the screen.  
 This method puts it not so close. */
- (void)betterCenter {
	NSRect	frame = [self frame];
	NSRect	screen = [[self screen] visibleFrame];
	
	[self setFrame:NSMakeRect(screen.origin.x + (screen.size.width - frame.size.width) / 2.0f,
							  screen.origin.y + (screen.size.height - frame.size.height) / 1.2f,
							  frame.size.width,
							  frame.size.height)
		   display:NO];
}

/** @brief 	Height of the toolbar @result The height of the toolbar, or 0 if no toolbar exists or is visible */
- (CGFloat)toolbarHeight {
	NSToolbar 	*toolbar = [self toolbar];
	CGFloat 		toolbarHeight = 0.0f;
	
	if (toolbar && [toolbar isVisible]) {
		NSRect 		windowFrame = [NSWindow contentRectForFrameRect:[self frame]
													   styleMask:[self styleMask]];
		toolbarHeight = NSHeight(windowFrame) - NSHeight([[self contentView] frame]);
	}
	
	return toolbarHeight;
}
@end



// This is the minimum duration of the animation in seconds. 0.75 seems best.
#define DURATION (0.75)

// We subclass NSAnimation to maximize frame rate, instead of using progress marks.
@interface FliprAnimation : NSAnimation
@end

@implementation FliprAnimation
// We initialize the animation with some huge default value.
- (id)initWithAnimationCurve:(NSAnimationCurve)animationCurve {
	self = [super initWithDuration:1.0E8 animationCurve:animationCurve];
	return self;
}

// We call this to start the animation just beyond the first frame.
- (void)startAtProgress:(NSAnimationProgress)value withDuration:(NSTimeInterval)duration {
	[super setCurrentProgress:value];
	[self setDuration:duration];
	[self startAnimation];
}

// Called periodically by the NSAnimation timer.

- (void)setCurrentProgress:(NSAnimationProgress)progress {
	// Call super to update the progress value.
	[super setCurrentProgress:progress];
	if ([self isAnimating]&&(progress<0.99)) {
		/// Update the window unless we're nearly at the end. No sense duplicating the final window.
		// We can be sure the delegate responds to display.
		[(NSView *)[self delegate] display];
	}
}

@end

// This is the flipping window's content view.

@interface FliprView : NSView {
	NSRect originalRect;			// this rect covers the initial and final windows.
	NSWindow* initialWindow;
	NSWindow* finalWindow;
    CIImage* finalImage;			// this is the rendered image of the final window.
	CIFilter* transitionFilter;
	NSShadow* shadow;
	FliprAnimation* animation;
	float direction;				// this will be 1 (forward) or -1 (backward).
	float frameTime;				// time for last drawRect:
}
@end

@implementation FliprView

// The designated initializer; will be called when the flipping window is set up.

- (id)initWithFrame:(NSRect)frame andOriginalRect:(NSRect)rect {
	self = [super initWithFrame:frame];
	if (self) {
		originalRect = rect;
		initialWindow = nil;
		finalWindow = nil;
		finalImage = nil;
		animation = nil;
		frameTime = 0.0;
		// Initialize the CoreImage filter.
		transitionFilter = [CIFilter filterWithName:@"CIPerspectiveTransform"];// retain];
		[transitionFilter setDefaults];
		// These parameters come from http://boredzo.org/imageshadowadder/ by Peter Hosey,
		// and reproduce reasonably well the standard Tiger NSWindow shadow.
		// You should change these when flipping NSPanels and/or on Leopard.
		shadow = [[NSShadow alloc] init];
		[shadow setShadowColor:[[NSColor shadowColor] colorWithAlphaComponent:0.8]];
		[shadow setShadowBlurRadius:23];
		[shadow setShadowOffset:NSMakeSize(0,-8)];
	}
	return self;
}

// Notice that we don't retain the initial and final windows, so we don't release them here either.

//- (void)dealloc {
//	[finalImage release];
//	[transitionFilter release];
//	[shadow release];
//	[animation release];
//	[super dealloc];
//}

// This view, and the flipping window itself, are mostly transparent.

- (BOOL)isOpaque {
	return NO;
}


// This is called to calculate the transition images and to start the animation.
// The initial and final windows aren't retained, so weird things might happen if
// they go away during the animation. We assume both windows have the exact same frame.

- (void)setInitialWindow:(NSWindow*)initial andFinalWindow:(NSWindow*)final forward:(BOOL)forward {
	NSWindow* flipr = [NSWindow flippingWindow];
	if (flipr) {
		[NSCursor hide];
		initialWindow = initial;
		finalWindow = final;
		direction = forward?1:-1;
		// Here we reposition and resize the flipping window so that originalRect will cover the original windows.
		NSRect frame = [initialWindow frame];
		NSRect flp = [flipr frame];
		flp.origin.x = frame.origin.x-originalRect.origin.x;
		flp.origin.y = frame.origin.y-originalRect.origin.y;
		flp.size.width += frame.size.width-originalRect.size.width;
		flp.size.height += frame.size.height-originalRect.size.height;
		[flipr setFrame:flp display:NO];
		originalRect.size = frame.size;
		// Here we get an image of the initial window and make a CIImage from it.
		NSView* view = [[initialWindow contentView] superview];
		flp = [view bounds];
		NSBitmapImageRep* bitmap = [view bitmapImageRepForCachingDisplayInRect:flp];
		[view cacheDisplayInRect:flp toBitmapImageRep:bitmap];
		CIImage* initialImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
		// We immediately pass the initial image to the filter and release it.
		[transitionFilter setValue:initialImage forKey:@"inputImage"];
		//		[initialImage release];
		// To prevent flicker...
		NSDisableScreenUpdates();
		// We bring the final window to the front in order to build the final image.
		[finalWindow makeKeyAndOrderFront:self];
		// Here we get an image of the final window and make a CIImage from it.
		view = [[finalWindow contentView] superview];
		flp = [view bounds];
		bitmap = [view bitmapImageRepForCachingDisplayInRect:flp];
		[view cacheDisplayInRect:flp toBitmapImageRep:bitmap];
		finalImage = [[CIImage alloc] initWithBitmapImageRep:bitmap];
		// To save time, we don't order the final window out, just make it completely transparent.
		[finalWindow setAlphaValue:0];
		[initialWindow orderOut:self];
		// This will draw the first frame at value 0, duplicating the initial window. This is not really optimal,
		// but we need to compensate for the time spent here, which seems to be about 3 to 5x what's needed
		// for subsequent frames.
		animation = [[FliprAnimation alloc] initWithAnimationCurve:NSAnimationEaseInOut];
		[animation setDelegate:self];
		// This is probably redundant...
		[animation setCurrentProgress:0.0];
		[flipr orderWindow:NSWindowBelow relativeTo:[finalWindow windowNumber]];
		float duration = DURATION;
		// Slow down by a factor of 5 if the shift key is down.
		if ([[NSApp currentEvent] modifierFlags]&NSShiftKeyMask) {
			duration *= 5.0;
		}
		// We accumulate drawing time and draw a second frame at the point where the rotation starts to show.
		float totalTime = frameTime;
		[animation setCurrentProgress:DURATION/15];
		// Now we update the screen and the second frame appears, boom! :-)
		NSEnableScreenUpdates();
		totalTime += frameTime;
		// We set up the animation. At this point, totalTime will be the time needed to draw the first two frames,
		// and frameTime the time for the second (normal) frame.
		// We stretch the duration, if necessary, to make sure at least 5 more frames will be drawn. 
		if ((duration-totalTime)<(frameTime*5)) {
			duration = totalTime+frameTime*5;
		}
		// ...and everything else happens in the animation delegates. We start the animation just
		// after the second frame.
		[animation startAtProgress:totalTime/duration withDuration:duration];
	}
}

// This is called when the animation has finished.

- (void)animationDidEnd:(NSAnimation*)theAnimation {
	// We order the flipping window out and make the final window visible again.
	NSDisableScreenUpdates();
	[[NSWindow flippingWindow] orderOut:self];
	[finalWindow setAlphaValue:1.0];
	[finalWindow display];
	NSEnableScreenUpdates();
	// Clear stuff out...
	//	[animation autorelease];
	animation = nil;
	initialWindow = nil;
	finalWindow = nil;
	//	[finalImage release];
	finalImage = nil;
	[NSCursor unhide];
}

// All the magic happens here... drawing the flipping animation.

- (void)drawRect:(NSRect)rect {
	if (!initialWindow) {
		// If there's no window yet, we don't need to draw anything.
		return;
	}
	// For calculating the draw time...
	AbsoluteTime startTime = UpTime();
	// time will vary from 0.0 to 1.0. 0.5 means halfway.
	float time = [animation currentValue];
	// This code was adapted from http://www.macs.hw.ac.uk/~rpointon/osx/coreimage.html by Robert Pointon.
	// First we calculate the perspective.
	float radius = originalRect.size.width/2;
	float width = radius;
	float height = originalRect.size.height/2;
	float dist = 1600; // visual distance to flipping window, 1600 looks about right. You could try radius*5, too.
	float angle = direction*M_PI*time;
	float px1 = radius*cos(angle);
	float pz = radius*sin(angle);
	float pz1 = dist+pz;
	float px2 = -px1;
	float pz2 = dist-pz;
	if (time>0.5) {
		// At this point,  we need to swap in the final image, for the second half of the animation.
		if (finalImage) {
			[transitionFilter setValue:finalImage forKey:@"inputImage"];
			//			[finalImage release];
			finalImage = nil;
		}
		float ss;
		ss = px1; px1 = px2; px2 = ss;
		ss = pz1; pz1 = pz2; pz2 = ss;
	}
	float sx1 = dist*px1/pz1;
	float sy1 = dist*height/pz1;
	float sx2 = dist*px2/pz2;
	float sy2 = dist*height/pz2;
	// Everything is set up, we pass the perspective to the CoreImage filter
	[transitionFilter setValue:[CIVector vectorWithX:width+sx1 Y:height+sy1] forKey:@"inputTopRight"];
	[transitionFilter setValue:[CIVector vectorWithX:width+sx2 Y:height+sy2] forKey:@"inputTopLeft" ];
	[transitionFilter setValue:[CIVector vectorWithX:width+sx1 Y:height-sy1] forKey:@"inputBottomRight"];
	[transitionFilter setValue:[CIVector vectorWithX:width+sx2 Y:height-sy2] forKey:@"inputBottomLeft"];
	CIImage* outputCIImage = [transitionFilter valueForKey:@"outputImage"];
	// This will make the standard window shadow appear beneath the flipping window
	[shadow set];
	// And we draw the result image.
	NSRect bounds = [self bounds];
	[outputCIImage drawInRect:bounds fromRect:NSMakeRect(-originalRect.origin.x,-originalRect.origin.y,bounds.size.width,bounds.size.height) operation:NSCompositeSourceOver fraction:1.0];
	// Calculate the time spent drawing
	frameTime = UnsignedWideToUInt64(AbsoluteDeltaToNanoseconds(UpTime(),startTime))/1E9;
}

@end

@implementation NSWindow (NSWindow_Flipr)

// This function checks if the CPU can perform flipping. We assume all Intel Macs can do it,
// but PowerPC Macs need AltiVec.

static BOOL CPUIsSuitable() {
#ifdef __LITTLE_ENDIAN__
	return YES;
#else
	int altivec = 0;
	size_t length = sizeof(altivec);
	int error = sysctlbyname("hw.optional.altivec",&altivec,&length,NULL,0);
	return error?NO:altivec!=0;
#endif
}

// There's only one flipping window!

static NSWindow* flippingWindow = nil;

// Get (and initialize, if necessary) the flipping window.

+ (NSWindow*)flippingWindow {
	if (!flippingWindow) {
		// We initialize the flipping window if the CPU can do it...
		if (CPUIsSuitable()) {
			// This is a little arbitary... the window will be resized every time it's used.
			NSRect frame = NSMakeRect(128,128,512,768);
			flippingWindow = [[NSWindow alloc] initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
			[flippingWindow setBackgroundColor:[NSColor clearColor]];
			[flippingWindow setOpaque:NO];	
			[flippingWindow setHasShadow:NO];
			[flippingWindow setOneShot:YES];
			frame.origin = NSZeroPoint;
			// The inset values seem large enough so the animation doesn't slop over the frame.
			// They could be calculated more exactly, though.
			FliprView* view = [[FliprView alloc] initWithFrame:frame andOriginalRect:NSInsetRect(frame,64,256)];// autorelease];
			[view setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
			[flippingWindow setContentView:view];
		}
	}
	return flippingWindow;
}

// Release the flipping window.

+ (void)releaseFlippingWindow {
	//	[flippingWindow autorelease];
	flippingWindow = nil;
}

// This is called from outside to start the animation process.

- (void)flipToShowWindow:(NSWindow*)window forward:(BOOL)forward {
	// We resize the final window to exactly the same frame.
	[window setFrame:[self frame] display:NO];
	NSWindow* flipr = [NSWindow flippingWindow];
	if (!flipr) {
		// If we fall in here, the CPU isn't able to animate and we just change windows.
		[window makeKeyAndOrderFront:self];
		[self orderOut:self];
		return;
	}
	[(FliprView*)[flipr contentView] setInitialWindow:self andFinalWindow:window forward:forward];
}

@end


//  CocoatechCore
@interface NSWindow (NSDrawerWindowUndocumented)
- (NSWindow*)_parentWindow;
@end

@interface NSApplication (Undocumented)
- (NSArray*)_orderedWindowsWithPanels:(BOOL)panels;
@end

@implementation NSWindow (Utilities)

+ (void)cascadeWindow:(NSWindow*)inWindow;
{
    // find the topmost window with the same class
    NSEnumerator *enumerator = [[self visibleWindows:YES] objectEnumerator];
    NSWindow* window;
    
    while (window = [enumerator nextObject])
    {
        // class must match exactly, but don't cascade it off itself
        if (window != inWindow)
        {
            if ([window isMemberOfClass:[inWindow class]] && [[window delegate] isMemberOfClass:[[inWindow delegate] class]])
            {
                // cascade new window off this window we found
                NSRect windowFrame = [window frame];
                NSPoint topLeftPoint = NSMakePoint(windowFrame.origin.x, NSMaxY(windowFrame));
                NSPoint cascadedPoint;
                
                cascadedPoint = [inWindow cascadeTopLeftFromPoint:topLeftPoint];
                windowFrame.origin = NSMakePoint(cascadedPoint.x, cascadedPoint.y - NSHeight(windowFrame));
                
                [inWindow setFrame:windowFrame display:NO];
                break;
            }
        }
    }
}

+ (BOOL)isAnyWindowVisibleWithDelegateClass:(Class)class;
{
    NSArray* windows = [self visibleWindows:NO];
    NSWindow* window;
    
    for (window in windows)
    {
        
        id delegate = [window delegate];
        
        if ([delegate isKindOfClass:class])
            return YES;
    }
    
    return NO;    
}

+ (BOOL)isAnyWindowVisible;
{
    NSArray* windows = [self visibleWindows:NO];
    NSWindow* window;
    
    for (window in windows)
    {
        
        // this should elliminate drawers and floating windows
        if ([window styleMask] & (NSTitledWindowMask | NSClosableWindowMask))
            return YES;
    }
    
    return NO;
}

- (NSWindow*)topWindowWithDelegateClass:(Class)class;
{
	NSArray* arr = [NSWindow visibleWindows:YES delegateClass:class];
	
	if ([arr count])
		return [arr objectAtIndex:0];
	
	return nil;
}

+ (NSArray*)visibleWindows:(BOOL)ordered;
{
	return [self visibleWindows:ordered delegateClass:nil];
}

+ (NSArray*)visibleWindows:(BOOL)ordered delegateClass:(Class)delegateClass;
{
	NSArray* windows;
    NSMutableArray* visibles = [NSMutableArray array];
    
	if (ordered)
		windows = [NSApp _orderedWindowsWithPanels:YES];
	else
		windows = [NSApp windows];
    
    if (windows && [windows count])
    {
        NSWindow* window;
		BOOL visible;
		BOOL appHidden = [NSApp isHidden];
        
        for (window in windows)
        {
            
			// hack: if app is hidden, all windows are not visible
			visible = [window isVisible];
			if (!visible && appHidden)
				visible = YES;
			
            if ([window canBecomeKeyWindow] && visible)  
			{
				// filter by delegates class if not nil
				if (delegateClass)
				{
					if (![[window delegate] isKindOfClass:delegateClass])
						window = nil;
				}
				
				if (window)
					[visibles addObject:window];
			}
        }
    }
    
    return visibles;	
}

+ (NSArray*)miniaturizedWindows;
{
    NSArray* windows;
    NSMutableArray* minaturized = [NSMutableArray array];
    
    windows = [NSApp windows];
    
    if (windows && [windows count])
    {
        NSWindow* window;
        
        for (window in windows)
        {
            
            if ([window canBecomeKeyWindow] && [window isMiniaturized])
            {
                // this should elliminate drawers and floating windows
                if ([window styleMask] & (NSTitledWindowMask | NSClosableWindowMask))
                    [minaturized addObject:window];
            }
        }
    }
    
    return minaturized;
}

- (void)setFloating:(BOOL)set;
{
    if (set)
        [self setLevel:NSFloatingWindowLevel];
    else
        [self setLevel:NSNormalWindowLevel];
}

- (BOOL)isFloating;
{
    return ([self level] == NSFloatingWindowLevel);
}

- (BOOL)isMetallic;
{
	// under 10.5 drawers don't adopt the styleMask, must check parent
	NSWindow* win = [self parentWindowIfDrawerWindow];
    return NSTexturedBackgroundWindowMaskSet([win styleMask]);
}

- (BOOL)isBorderless;
{
	return NSBorderlessWindowMaskSet([self styleMask]);
}

// returns parentWindow if an NSDrawerWindow, otherwise returns self
- (NSWindow*)parentWindowIfDrawerWindow;
{
	if ([self respondsToSelector:(@selector(_parentWindow))])
		return [self _parentWindow];
	
	return self;
}

- (void)setDefaultFirstResponder;
{
	// send this out to ask our window to set the defaul first responder
	[[NSNotificationCenter defaultCenter] postNotificationName:kNTSetDefaultFirstResponderNotification object:self];
}

- (BOOL)dimControls;
{
	if ([self isFloating])
		return NO;
	
	return ![[self parentWindowIfDrawerWindow] isMainWindow];
}

- (BOOL)dimControlsKey;
{
	// if key window is a menu, just call plain dimControls
	if ([self keyWindowIsMenu])
		return [self dimControls];
	
	if ([self isFloating])
		return NO;
	
	return ![[self parentWindowIfDrawerWindow] isKeyWindow];
}

- (BOOL)keyWindowIsMenu;
{
	static Class sCarbonMenuWindowClass=nil;
	if (!sCarbonMenuWindowClass)
		sCarbonMenuWindowClass = NSClassFromString(@"NSCarbonMenuWindow");
	
	return [[NSApp keyWindow] isKindOfClass:sCarbonMenuWindowClass];
}

- (void)flushActiveTextFields;
{
	// flush the current editor
	id fr = [self firstResponder];
	if (fr)
	{
		[self makeFirstResponder:nil];
		[self makeFirstResponder:fr];
	}
}		

- (NSRect)setContentViewAndResizeWindow:(NSView*)view display:(BOOL)display;
{
	NSRect frame = [self frame];
	frame.size = [self frameRectForContentRect:[view bounds]].size;
	[self setContentView:view];
	
	frame.origin.y += (NSHeight([self frame]) - NSHeight(frame));
	
	[self setFrame:frame display:display animate:YES];
	
	return frame;
}

- (NSRect)windowFrameForContentSize:(NSSize)contentSize;
{
	NSRect frame = [self frame];
	frame.size = [self frameRectForContentRect:NSMakeRect(0,0,contentSize.width, contentSize.height)].size;
	
	frame.origin.y += (NSHeight([self frame]) - NSHeight(frame));
	
	return frame;
}

- (NSRect)resizeWindowToContentSize:(NSSize)contentSize display:(BOOL)display;
{
	NSRect result = [self windowFrameForContentSize:contentSize];		
	[self setFrame:result display:display animate:YES];
	
	return result;
}

+ (BOOL)windowRectIsOnScreen:(NSRect)windowRect;
{	
    // make sure window is visible
    NSEnumerator* enumerator = [[NSScreen screens] objectEnumerator];
	NSScreen *screen;
	
    while (screen = [enumerator nextObject])
    {
        if (NSIntersectsRect(windowRect, [screen frame]))
		{
			// someone reported that a detacted monitor was keeping windows off screen?  Didn't verify
			// not sure if this hack works since I can't test it, but seems reasonable
			if (!NSIsEmptyRect([screen visibleFrame]))
				return YES;
		}
    }
	
    return NO;
}

// NSCopying protocol
// added to be compatible with the beginSheet hack in NTApplication.m taken from OmniAppKit
- (id)copyWithZone:(NSZone *)zone;
{
    return self;// retain];
}

- (void)fadeIn {
    [self setAlphaValue:0.f];
    [self makeKeyAndOrderFront:nil];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:.6];
    [[self animator] setAlphaValue:1.f];
    [NSAnimationContext endGrouping];
}

- (void)fadeOut {
    [NSAnimationContext beginGrouping];
    __block __unsafe_unretained NSWindow *bself = self;
    [[NSAnimationContext currentContext] setDuration:.6];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [bself orderOut:nil];
        [bself setAlphaValue:1.f];
    }];
    [[self animator] setAlphaValue:0.f];
    [NSAnimationContext endGrouping];
}

- (void)slideDown {
	//	if ([[self contentView] isHidden]) [[self main] setHidden:YES];
	[self makeKeyAndOrderFront:self];
    NSRect firstViewFrame = [self frame];
	NSRect screen =  [[NSScreen mainScreen]visibleFrame];
	firstViewFrame.origin.y = screen.size.height;// + 22;
	NSRect destinationRect = firstViewFrame;
	destinationRect.origin.y -= self.frame.size.height - 4;// + 22;
	NSViewAnimation *theAnim = [[NSViewAnimation alloc] initWithViewAnimations: $array($map(
				self, NSViewAnimationTargetKey,
				[NSValue valueWithRect:firstViewFrame], NSViewAnimationStartFrameKey,
				[NSValue valueWithRect:destinationRect], NSViewAnimationEndFrameKey,
				NSAnimationEaseInOut, @"animationCurve",
				$float(4), @"duration"))];
	//	NSRect newViewFrame = firstViewFrame;
	//    newViewFrame.origin.y -= self.frame.size.height;
	//    newViewFrame.origin.y -= 22;
	//						  forKey:NSViewAnimationEndFrameKey];
//    [theAnim setAnimationCurve:NSAnimationEaseInOut];
//	[theAnim setDuration:.4];
	[theAnim setDelegate:self]; 
    [theAnim startAnimation];
	
	//    [NSAnimationContext beginGrouping];
	//    [[NSAnimationContext currentContext] setDuration:.6];
	//	NSPoint down = NSMakePoint(self.frame.origin.x, self.frame.origin.y - self.frame.size.height);
	//    [[self animator] setFrameOrigin:down];
	//    [NSAnimationContext endGrouping];
}

- (void)slideUp {
	[self makeKeyAndOrderFront:self];
    NSRect firstViewFrame = [self frame];
	NSRect newViewFrame = firstViewFrame;
    newViewFrame.origin.y = [[NSScreen mainScreen]visibleFrame].size.height+ 22;//= self.frame.size.height;
	NSViewAnimation *theAnim = [[NSViewAnimation alloc] initWithViewAnimations: $array($map(
		self, NSViewAnimationTargetKey,
		[NSValue valueWithRect:firstViewFrame], NSViewAnimationStartFrameKey,
		[NSValue valueWithRect:newViewFrame], NSViewAnimationEndFrameKey))];
	
    [theAnim setDuration:.5]; 
    [theAnim startAnimation];
	
	
	//    [self makeKeyAndOrderFront:self];
	//    [NSAnimationContext beginGrouping];
	//    __block __unsafe_unretained NSWindow *bself = self;
	//
	//    [[NSAnimationContext currentContext] setDuration:.6];
	//	NSPoint up = NSMakePoint(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
	//    [[self animator] setFrameOrigin:up];
	//    [NSAnimationContext endGrouping];
}


- (void) extendVerticallyBy:(int) amount { // extends the window vertically by the amount (which can be negative).
	
	//This doesn't disturb the positioning orsize of any of the views, whatever their autosizing parameters are set to.
	NSView	 *cv = [self contentView];	NSView	 *view;
	NSEnumerator	*iter = [[cv subviews] objectEnumerator]; 
	NSRect	 fr; NSPoint	 fro;
	[cv setAutoresizesSubviews:NO]; 	[self disableFlushWindow];
	while( view = [iter nextObject]) {
		fro = [view frame].origin;
		fro.y += amount;
		[view setFrameOrigin:fro];
	}
	fr = [self frame];
	fr.size.height += amount; fr.origin.y -= amount;
	[self setFrame:fr display:YES];
	[self enableFlushWindow];
	[cv setAutoresizesSubviews:YES]; 
	
}

//This is the core of it - it just extends or shrinks the window's bottom edge by the given amount, leaving all the current subviews undisturbed. It could probably most usefully be a catego
@end

