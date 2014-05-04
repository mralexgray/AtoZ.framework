
//  NSScreen+AG.m
//  AGFoundation

//  Created by Alex Gray on 6/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "NSScreen+AtoZ.h"
#import "AZMouser.h"

@implementation NSScreen (PointConversion)

+ (NSScreen *)currentScreenForMouseLocation
{
	NSPoint mouseLocation = [NSEvent mouseLocation];
	
	NSEnumerator *screenEnumerator = [[NSScreen screens] objectEnumerator];
	NSScreen *screen;
	while ((screen = [screenEnumerator nextObject]) && !NSMouseInRect(mouseLocation, screen.frame, NO))
		;
	
	return screen;
}

- (NSPoint)convertPointToScreenCoordinates:(NSPoint)aPoint
{
	float normalizedX = fabs(fabs(self.frame.origin.x) - fabs(aPoint.x));
	float normalizedY = aPoint.y - self.frame.origin.y;
	
	return NSMakePoint(normalizedX, normalizedY);
}

- (NSPoint)flipPoint:(NSPoint)aPoint
{
	return NSMakePoint(aPoint.x, self.frame.size.height - aPoint.y);
}

+ (NSPoint)convertAndFlipMousePointInView:(NSView *)view {
	NSScreen *now = [NSScreen currentScreenForMouseLocation];
	NSPoint mp = mouseLoc();
	NSPoint j = [now flipPoint:[now convertToScreenFromLocalPoint:mp relativeToView:view]];
	return [view isFlipped] ? [[self mainScreen]flipPoint:j] :j;

}

+ (NSPoint)convertAndFlipEventPoint:(NSEvent*)event relativeToView:(NSView *)view {

		return [[self class] convertAndFlipMousePointInView:view];
}

- (NSPoint)convertToScreenFromLocalPoint:(NSPoint)point relativeToView:(NSView *)view {
	//	NSScreen *currentScreen = [NSScreen currentScreenForMouseLocation];
	if(self)	{
		NSPoint windowPoint = [view convertPoint:point toView:nil];
		NSPoint screenPoint = [[view window] convertBaseToScreen:windowPoint];
		NSPoint flippedScreenPoint = [self flipPoint:screenPoint];
		flippedScreenPoint.y += [self frame].origin.y;
 		return flippedScreenPoint;
	}
 	return NSZeroPoint;
}
 
- (void) oveMouseToScreenPoint:(NSPoint)point
{
	CGPoint cgPoint = NSPointToCGPoint(point);
	/* Set the interval that local hardware events may be suppressed following the posting of a Quartz event. This function sets the period of time in seconds that local hardware events may be suppressed after posting a Quartz event created with the specified event source. The default suppression interval is 0.25 seconds. */

	CGEventSourceSetLocalEventsSuppressionInterval(nil,0);
//	CGSetLocalEventsSuppressionInterval(0.0);
	CGWarpMouseCursorPosition(cgPoint);
	CGEventSourceSetLocalEventsSuppressionInterval(nil,.25);
//	CGSetLocalEventsSuppressionInterval(0.25);
}
@end


static NSString *kDefaultsDockDomainKey     = @"com.apple.dock";
static NSString *kDefaultsDesktopDomainKey  = @"com.apple.desktop";
static NSString *kNSScreenNumberKey         = @"NSScreenNumber";
static NSString *kImageFilePathKey          = @"ImageFilePath";

enum {
    CNDockOrientationLeft = 0,
    CNDockOrientationRight,
    CNDockOrientationBottom
};
typedef NSUInteger CNDockOrientation;


@interface NSScreen (CNBackstageControllerExtension)
+ (CNDockOrientation)dockOrientation;
+ (NSArray*)dockOrientations;
@end


@implementation NSScreen (CNBackstageController)

/////#pragma mark - API

+ (NSScreen*)screenWithMenubar
{
    NSScreen *result;
    for (NSScreen *screen in [NSScreen screens]) {
        NSRect totalFrame = [screen frame];
        NSRect visibleFrame = [screen visibleFrame];
        
        if (totalFrame.size.height > visibleFrame.size.height) {
            result = screen;
        }
    }
    return result;
}

+ (NSScreen*)screenWithDisplayID:(CGDirectDisplayID)displayID
{
    NSScreen *result;
    for (NSScreen *aScreen in [NSScreen screens]) {
        if ([[[aScreen deviceDescription] valueForKey:@"NSScreenNumber"] intValue] == displayID) {
            result = aScreen;
            break;
        }
    }
    return result;
}

+ (NSImage*)desktopImageForScreen:(NSScreen*)aScreen
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *desktopDefaults = [defaults persistentDomainForName:kDefaultsDesktopDomainKey];
    NSDictionary *screenDefaults = [desktopDefaults objectForKey:[[aScreen deviceDescription] valueForKey:kNSScreenNumberKey]];
    return [NSImage imageNamed:[screenDefaults valueForKey:kImageFilePathKey]];
}

- (BOOL)containsDock
{
    NSRect totalFrame = [self frame];
    NSRect visibleFrame = [self visibleFrame];
    int statusBarThickness = (self.isMainScreen ? [[NSStatusBar systemStatusBar] thickness] : 0);
    BOOL result = YES;
    
    switch ([NSScreen dockOrientation]) {
        case CNDockOrientationLeft:
        case CNDockOrientationRight:
            result = (NSWidth(visibleFrame) == NSWidth(totalFrame) ? NO : YES);
            break;
            
        case CNDockOrientationBottom:
            result = (NSHeight(visibleFrame) == (NSHeight(totalFrame) - statusBarThickness) ? NO : YES);
            break;
    }
    return result;
}

- (BOOL)containsMenuBar
{
    CGDirectDisplayID myDisplayID = (CGDirectDisplayID)[[[self deviceDescription] valueForKey:kNSScreenNumberKey] unsignedIntValue];
    CGDirectDisplayID menuBarScreenDisplayID = (CGDirectDisplayID)[[[[NSScreen screenWithMenubar] deviceDescription] valueForKey:kNSScreenNumberKey] unsignedIntValue];
    return (myDisplayID == menuBarScreenDisplayID);
}

- (BOOL)isMainScreen
{
    int mainscreen = [[[[NSScreen mainScreen] deviceDescription] valueForKey:kNSScreenNumberKey] intValue];
    int currentscreen = [[[self deviceDescription] valueForKey:kNSScreenNumberKey] intValue];
    return (mainscreen == currentscreen);
}

- (CGImageRef)snapshotOfType:(NSBitmapImageFileType)imageFileType
{
    @try {
        switch (imageFileType) {
            case NSTIFFFileType:
            case NSBMPFileType:
            case NSGIFFileType:
            case NSJPEGFileType:
            case NSPNGFileType:
            case NSJPEG2000FileType: {
                CGDirectDisplayID displayID = (CGDirectDisplayID)[[[self deviceDescription] valueForKey:kNSScreenNumberKey] unsignedIntValue];
                CGRect rect = NSRectToCGRect([self frame]);
                rect.origin = CGPointMake(0, 0);
                CGImageRef snapshotImageRef = CGDisplayCreateImageForRect(displayID, rect);
                NSBitmapImageRep *snapshot = [NSBitmapImageRep.alloc initWithCGImage:snapshotImageRef];
                return [snapshot CGImage];
                break;
            }
                
            default: {
                NSException *wrongFileTypeException = [NSException exceptionWithName:@"CNUnknownBitmapImageFileTypeException"
                                                                              reason:[NSString stringWithFormat:@"The given bitmap image file type is unknown (%li).", imageFileType]
                                                                            userInfo:nil];
                @throw wrongFileTypeException;
                break;
            }
        }
    }
    @catch (NSException *wrongFileTypeException) {
        NSLog(@"ERROR: Caught %@: %@", [wrongFileTypeException name], [wrongFileTypeException reason]);
    }
    return NULL;
}

- (NSString*)desktopImageFilePath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *desktopDefaults = [defaults persistentDomainForName:kDefaultsDesktopDomainKey];
    NSDictionary *screenDefaults = [desktopDefaults objectForKey:[[self deviceDescription] valueForKey:kNSScreenNumberKey]];
    return [screenDefaults valueForKey:kImageFilePathKey];
}

- (NSImage*)desktopImage
{
    return [NSImage imageNamed:[self desktopImageFilePath]];
}

/////#pragma mark - Private Helper

+ (CNDockOrientation)dockOrientation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dockDefaults = [defaults persistentDomainForName:kDefaultsDockDomainKey];
    return [self.dockOrientations indexOfObject:[dockDefaults valueForKey:@"orientation"]];
}

+ (NSArray*)dockOrientations { return [NSArray arrayWithObjects:@"left", @"right", @"bottom", nil]; }

@end
