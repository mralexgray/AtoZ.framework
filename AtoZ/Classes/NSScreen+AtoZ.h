
//  NSScreen+AG.h
//  AGFoundation

//  Created by Alex Gray on 6/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Cocoa/Cocoa.h>

#import <Foundation/Foundation.h>

@interface NSScreen (PointConversion)

+ (NSPoint)convertAndFlipMousePointInView:(NSView *)view;

/* 
 Returns the screen where the mouse resides
*/
+ (NSScreen *)currentScreenForMouseLocation;

/*
 Allows you to convert a point from global coordinates to the current screen coordinates.
*/
- (NSPoint)convertPointToScreenCoordinates:(NSPoint)aPoint;

/*
 Allows to flip the point coordinates, so y is 0 at the top instead of the bottom. x remains the same
*/
- (NSPoint)flipPoint:(NSPoint)aPoint;

- (NSPoint)convertToScreenFromLocalPoint:(NSPoint)point relativeToView:(NSView *)view;
- (void) oveMouseToScreenPoint:(NSPoint)point;

+ (NSPoint)convertAndFlipEventPoint:(NSEvent*)event relativeToView:(NSView *)view;

@end

@interface NSScreen (CNBackstageController)

/**
 Returns the `NSScreen` that contains the system menu bar.
 
 @return    A NSScreen object.
 */
+ (NSScreen*)screenWithMenubar;

/**
 Returns the `NSScreen` of the given displayID.
 
 @param     The ID of the requested display.
 @return    A NSScreen object.
 */
+ (NSScreen*)screenWithDisplayID:(CGDirectDisplayID)displayID;

/**
 Creates and returns a desktop image.
 
 This method returns an instance of `NSImage` representing the desktop image of the given `NSScreen`.
 
 @return    A `NSImage` object with the desktop image.
 */
+ (NSImage*)desktopImageForScreen:(NSScreen*)aScreen;

/**
 Boolean value that indicates whether the current screen contains the Dock.
 
 @return    `YES` if the current screen contains the Dock, otherwise `NO`.
 */
- (BOOL)containsDock;

/**
 Boolean value that indicates whether the current screen contains the system menu bar.
 
 @return    `YES` if the current screen contains the system menu bar, otherwise `NO`.
 */
- (BOOL)containsMenuBar;

/**
 Boolean value that indicates whether the current screen is the main screen.
 
 The main screen refers to the screen containing the window that is currently receiving keyboard events.
 
 @return    `YES` if the current screen is the main screen, otherwise `NO`.
 */
- (BOOL)isMainScreen;


/**
 Creates and returns an snapshot of the screen with given image file type.
 
 Allowed image file type values are:
 
    enum {
        NSTIFFFileType,
        NSBMPFileType,
        NSGIFFileType,
        NSJPEGFileType,
        NSPNGFileType,
        NSJPEG2000FileType
    };
    typedef NSUInteger NSBitmapImageFileType;
 
 These values are defined in the [NSBitmapImageRep Class Reference](http://developer.apple.com/library/mac/#documentation/cocoa/reference/applicationkit/classes/nsbitmapimagerep_class/reference/reference.html).
 
 */
- (CGImageRef)snapshotOfType:(NSBitmapImageFileType)imageFileType;

/**
 Returns the file path of the current desktop image.
 
 @return    A `NSString` object containing the complete absolute file path to the desktop image.
 */
- (NSString*)desktopImageFilePath;

/**
 Creates and returns the current desktop image.
 
 This method returns an instance of `NSImage` representing the current desktop image of the receiver.
 
 @return    A `NSImage` object with the desktop image.
 */
- (NSImage*)desktopImage;


@end
