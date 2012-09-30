
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
- (void)moveMouseToScreenPoint:(NSPoint)point;

+ (NSPoint)convertAndFlipEventPoint:(NSEvent*)event relativeToView:(NSView *)view;

@end

