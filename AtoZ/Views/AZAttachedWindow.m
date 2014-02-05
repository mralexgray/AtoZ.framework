
//  AZAttachedWindow.m

//  Created by Matt Gemmell on 27/09/2007.
//  Copyright 2007 Magic Aubergine.
#import "AZAttachedWindow.h"
#define AZATTACHEDWINDOW_DEFAULT_BACKGROUND_COLOR [NSColor colorWithCalibratedWhite:0 alpha:0.85]
#define AZATTACHEDWINDOW_DEFAULT_BORDER_COLOR [NSColor blackColor]
#define AZATTACHEDWINDOW_SCALE_FACTOR [[NSScreen mainScreen] userSpaceScaleFactor]

@interface AZAttachedWindow (AZPrivateMethods)
// Geometry
- (void)_updateGeometry;
- (AZWindowPosition)_bestSideForAutomaticPosition;
- (float)_arrowInset;

// Drawing
- (void)_updateBackground;
- (NSColor *)_backgroundColorPatternImage;
- (NSBezierPath *)_backgroundPath;
- (void)_appendArrowToPath:(NSBezierPath *)path;
- (void)_redisplay;
@end
@implementation AZAttachedWindow
{
	NSPoint initialLocation;
}
@synthesize view = _view;

#pragma mark Initializers
- (AZAttachedWindow *)initWithView:(NSView *)view 
				   attachedToPoint:(NSPoint)point 
						  inWindow:(NSWindow *)window 
							onSide:(AZWindowPosition)side 
						atDistance:(float)distance
{
	// Insist on having a valid view.
	if (!view) return nil;
	// Create dummy initial contentRect for window.
	NSRect contentRect = NSZeroRect;
	contentRect.size = [view frame].size;
	
	if ((self = [super initWithContentRect:contentRect 
								styleMask:NSBorderlessWindowMask 
								  backing:NSBackingStoreBuffered 
									defer:NO])) {
		_view = view;
		_window = window;
		_point = point;
		_side = side;
		_distance = distance;
		
		// Configure window characteristics.
		[super setBackgroundColor:[NSColor clearColor]];
		[self setMovableByWindowBackground:NO];
		[self setExcludedFromWindowsMenu:YES];
		[self setAlphaValue:1.0];
		[self setOpaque:NO];
		[self setHasShadow:YES];
		[self useOptimizedDrawing:YES];
		
		// Set up some sensible defaults for display.
		_AZBackgroundColor = RANDOMCOLOR;// [AZATTACHEDWINDOW_DEFAULT_BACKGROUND_COLOR copy];
		self.borderColor = [AZATTACHEDWINDOW_DEFAULT_BORDER_COLOR copy];
		self.borderWidth = 0.0;
		self.viewMargin = 2.0;
		self.arrowBaseWidth = 20.0;
		self.arrowHeight = 16.0;
		self.hasArrow = YES;
		self.cornerRadius = 8.0;
		self.drawsRoundCornerBesideArrow = YES;
		_resizing = NO;
		// Work out what side to put the window on if it's "automatic".
		if ([@(_side) isEqual:@(AZPositionAutomatic)]) _side = [self _bestSideForAutomaticPosition];
		// Configure our initial geometry.
		[self _updateGeometry];
		// Update the background.
		[self _updateBackground];
		
		// Add view as subview of our contentView.
		[[self contentView] addSubview:_view];
		
		// Subscribe to notifications for when we change size.
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(windowDidResize:) 
													 name:NSWindowDidResizeNotification 
												   object:self];
	}
	return self;
}
- (AZAttachedWindow *)initWithView:(NSView *)view 
				   attachedToPoint:(NSPoint)point 
						  inWindow:(NSWindow *)window 
						atDistance:(float)distance
{
	return [self initWithView:view attachedToPoint:point 
					 inWindow:window onSide:AZPositionAutomatic 
				   atDistance:distance];
}
- (AZAttachedWindow *)initWithView:(NSView *)view 
				   attachedToPoint:(NSPoint)point 
							onSide:(AZWindowPosition)side 
						atDistance:(float)distance
{
	return [self initWithView:view attachedToPoint:point 
					 inWindow:nil onSide:side 
				   atDistance:distance];
}
- (AZAttachedWindow *)initWithView:(NSView *)view 
				   attachedToPoint:(NSPoint)point 
						atDistance:(float)distance
{
	return [self initWithView:view attachedToPoint:point 
					 inWindow:nil onSide:AZPositionAutomatic 
				   atDistance:distance];
}
- (AZAttachedWindow *)initWithView:(NSView *)view 
				   attachedToPoint:(NSPoint)point 
						  inWindow:(NSWindow *)window
{
	return [self initWithView:view attachedToPoint:point 
					 inWindow:window onSide:AZPositionAutomatic 
				   atDistance:0];
}
- (AZAttachedWindow *)initWithView:(NSView *)view 
				   attachedToPoint:(NSPoint)point 
							onSide:(AZWindowPosition)side
{
	return [self initWithView:view attachedToPoint:point 
					 inWindow:nil onSide:side 
				   atDistance:0];
}
- (AZAttachedWindow *)initWithView:(NSView *)view 
				   attachedToPoint:(NSPoint)point
{
	return [self initWithView:view attachedToPoint:point 
					 inWindow:nil onSide:AZPositionAutomatic 
				   atDistance:0];
}
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}
#pragma mark Geometry
- (void)_updateGeometry
{
	NSRect contentRect = NSZeroRect;
	contentRect.size = [_view frame].size;
	
	// Account for viewMargin.
	_viewFrame = NSMakeRect(self.viewMargin * AZATTACHEDWINDOW_SCALE_FACTOR,
							self.viewMargin * AZATTACHEDWINDOW_SCALE_FACTOR,
							[_view frame].size.width, [_view frame].size.height);
	contentRect = NSInsetRect(contentRect, 
							  - self.viewMargin * AZATTACHEDWINDOW_SCALE_FACTOR,
							  - self.viewMargin * AZATTACHEDWINDOW_SCALE_FACTOR);
	
	// Account for arrowHeight in new window frame.
	// Note: we always leave room for the arrow, even if it currently set to  not be shown. This is so it can easily be toggled whilst the window is visible, without altering the window's frame origin point.
	float scaledArrowHeight = self.arrowHeight * AZATTACHEDWINDOW_SCALE_FACTOR;
	switch (_side) {
		case AZPositionLeft:
		case AZPositionTopLeft:
		case AZPositionBottomLeft:
			contentRect.size.width += scaledArrowHeight;
			break;
		case AZPositionRight:
		case AZPositionTopRight:
		case AZPositionBottomRight:
			_viewFrame.origin.x += scaledArrowHeight;
			contentRect.size.width += scaledArrowHeight;
			break;
		case AZPositionTop:
//		case AZPositionTopLeft:
//		case AZPositionTopRight:
			_viewFrame.origin.y += scaledArrowHeight;
			contentRect.size.height += scaledArrowHeight;
			break;
		case AZPositionBottom:
//		case AZPositionBottomLeft:
//		case AZPositionBottomRight:
			contentRect.size.height += scaledArrowHeight;
			break;
		default:
			break; // won't happen, but this satisfies gcc with -Wall
	}
	
	// Position frame origin appropriately for _side, accounting for arrow-inset.
	contentRect.origin = (_window) ? [_window convertBaseToScreen:_point] : _point;
	float arrowInset = [self _arrowInset];
	float halfWidth = contentRect.size.width / 2.0;
//	float halfHeight = contentRect.size.height / 2.0;
	switch (_side) {
		case AZPositionTopLeft:
			contentRect.origin.x -= contentRect.size.width - arrowInset;
			break;
		case AZPositionTop:
			contentRect.origin.x -= halfWidth;
			break;
		case AZPositionTopRight:
			contentRect.origin.x -= arrowInset;
			break;
		case AZPositionBottomLeft:
			contentRect.origin.y -= contentRect.size.height;
			contentRect.origin.x -= contentRect.size.width - arrowInset;
			break;
//		case AZPositionBottom:
//			contentRect.origin.y -= contentRect.size.height;
//			contentRect.origin.x -= halfWidth;
//			break;
//		case AZPositionBottomRight:
//			contentRect.origin.x -= arrowInset;
//			contentRect.origin.y -= contentRect.size.height;
//			break;
//		case AZPositionTopLeft:
//			contentRect.origin.x -= contentRect.size.width;
//			contentRect.origin.y -= arrowInset;
//			break;
//		case AZPositionLeft:
//			contentRect.origin.x -= contentRect.size.width;
//			contentRect.origin.y -= halfHeight;
//			break;
//		case AZPositionBottomLeft:
//			contentRect.origin.x -= contentRect.size.width;
//			contentRect.origin.y -= contentRect.size.height - arrowInset;
//			break;
//		case AZPositionTopRight:
//			contentRect.origin.y -= arrowInset;
//			break;
//		case AZPositionRight:
//			contentRect.origin.y -= halfHeight;
//			break;
//		case AZPositionBottomRight:
//			contentRect.origin.y -= contentRect.size.height - arrowInset;
//			break;
		default:
			break; // won't happen, but this satisfies gcc with -Wall
	}
	
	// Account for _distance in new window frame.
	switch (_side) {
		case AZPositionLeft:
		case AZPositionTopLeft:
		case AZPositionBottomLeft:
			contentRect.origin.x -= _distance;
			break;
		case AZPositionRight:
		case AZPositionTopRight:
		case AZPositionBottomRight:
			contentRect.origin.x += _distance;
			break;
		case AZPositionTop:
//		case AZPositionTopLeft:
//		case AZPositionTopRight:
			contentRect.origin.y += _distance;
			break;
		case AZPositionBottom:
//		case AZPositionBottomLeft:
//		case AZPositionBottomRight:
			contentRect.origin.y -= _distance;
			break;
		default:
			break; // won't happen, but this satisfies gcc with -Wall
	}
	
	// Reconfigure window and view frames appropriately.
	[[self  animator] setFrame:contentRect display:NO];
	[[_view  animator] setFrame:_viewFrame];
}
- (AZWindowPosition)_bestSideForAutomaticPosition
{
	// Get all relevant geometry in screen coordinates.
	NSRect screenFrame;
	if (_window && [_window screen]) {
		screenFrame = [[_window screen] visibleFrame];
	} else {
		 screenFrame = [[NSScreen mainScreen] visibleFrame];
	}
	NSPoint pointOnScreen = (_window) ? [_window convertBaseToScreen:_point] : _point;
	NSSize viewSize = [_view frame].size;
	viewSize.width += (self.viewMargin * AZATTACHEDWINDOW_SCALE_FACTOR) * 2.0;
	viewSize.height += (self.viewMargin * AZATTACHEDWINDOW_SCALE_FACTOR) * 2.0;
	AZWindowPosition side = AZPositionBottom; // By default, position us centered below.
	float scaledArrowHeight = (self.arrowHeight * AZATTACHEDWINDOW_SCALE_FACTOR) + _distance;
	
	// We'd like to display directly below the specified point, since this gives a 
	// sense of a relationship between the point and this window. Check there's room.
	if (pointOnScreen.y - viewSize.height - scaledArrowHeight < NSMinY(screenFrame)) {
		// We'd go off the bottom of the screen. Try the right.
		if (pointOnScreen.x + viewSize.width + scaledArrowHeight >= NSMaxX(screenFrame)) {
			// We'd go off the right of the screen. Try the left.
			if (pointOnScreen.x - viewSize.width - scaledArrowHeight < NSMinX(screenFrame)) {
				// We'd go off the left of the screen. Try the top.
				if (pointOnScreen.y + viewSize.height + scaledArrowHeight < NSMaxY(screenFrame)) {
					side = AZPositionTop;
				}
			} else {
				side = AZPositionLeft;
			}
		} else {
			side = AZPositionRight;
		}
	}
	
	float halfWidth = viewSize.width / 2.0;
	float halfHeight = viewSize.height / 2.0;
	
	NSRect parentFrame = (_window) ? [_window frame] : screenFrame;
	float arrowInset = [self _arrowInset];
	
	// We're currently at a primary side. Try to avoid going outwith the parent area in the secondary dimension, by checking to see if an appropriate corner side would be better.
	switch (side) {
		case AZPositionBottom:
		case AZPositionTop:
			// Check to see if we go beyond the left edge of the parent area.
			if (pointOnScreen.x - halfWidth < NSMinX(parentFrame)) {
				// We go beyond the left edge. Try using right position.
				if (pointOnScreen.x + viewSize.width - arrowInset < NSMaxX(screenFrame)) {
					// We'd still be on-screen using right, so use it.
					if (side == AZPositionBottom) {
						side = AZPositionBottomRight;
					} else {
						side = AZPositionTopRight;
					}
				}
			} else if (pointOnScreen.x + halfWidth >= NSMaxX(parentFrame)) {
				// We go beyond the right edge. Try using left position.
				if (pointOnScreen.x - viewSize.width + arrowInset >= NSMinX(screenFrame)) {
					// We'd still be on-screen using left, so use it.
					if (side == AZPositionBottom) {
						side = AZPositionBottomLeft;
					} else {
						side = AZPositionTopLeft;
					}
				}
			}
			break;
		case AZPositionRight:
		case AZPositionLeft:
			// Check to see if we go beyond the bottom edge of the parent area.
			if (pointOnScreen.y - halfHeight < NSMinY(parentFrame)) {
				// We go beyond the bottom edge. Try using top position.
				if (pointOnScreen.y + viewSize.height - arrowInset < NSMaxY(screenFrame)) {
					// We'd still be on-screen using top, so use it.
					if (side == AZPositionRight) {
						side = AZPositionTopRight;
					} else {
						side = AZPositionTopLeft;
					}
				}
			} else if (pointOnScreen.y + halfHeight >= NSMaxY(parentFrame)) {
				// We go beyond the top edge. Try using bottom position.
				if (pointOnScreen.y - viewSize.height + arrowInset >= NSMinY(screenFrame)) {
					// We'd still be on-screen using bottom, so use it.
					if (side == AZPositionRight) {
						side = AZPositionBottomRight;
					} else {
						side = AZPositionBottomLeft;
					}
				}
			}
			break;
		default:
			break; // won't happen, but this satisfies gcc with -Wall
	}
	
	return side;
}
- (float)_arrowInset
{
	float cornerInset = (self.drawsRoundCornerBesideArrow) ? self.cornerRadius : 0;
	return (cornerInset + (self.arrowBaseWidth / 2.0)) * AZATTACHEDWINDOW_SCALE_FACTOR;
}
#pragma mark Drawing
- (void)_updateBackground
{
	// Call NSWindow's implementation of -setBackgroundColor: because we override  it in this class to let us set the entire background image of the window as an NSColor patternImage.
//	NSDisableScreenUpdates();
//	[super setBackgroundColor:[self _backgroundColorPatternImage]];
	if ([self isVisible]) {
//		[self display];
		[self invalidateShadow];
	}
//	NSEnableScreenUpdates();
}
- (NSColor *)_backgroundColorPatternImage
{
	NSImage *bg = [NSImage.alloc initWithSize:[self frame].size];
	NSRect bgRect = NSZeroRect;
//	[NSGraphicsContext saveGraphicsState];
	bgRect.size = [bg size];
	[bg lockFocus];
	NSBezierPath *bgPath = [self _backgroundPath];
	[bgPath addClip];									// Draw background.
	[_AZBackgroundColor set];
	[bgPath fill];										// Draw border if appropriate.
	if (self.borderWidth > 0) {								// Double the borderWidth since we're drawing inside the path.
		[bgPath setLineWidth:(self.borderWidth * 2.0) * AZATTACHEDWINDOW_SCALE_FACTOR];
		[self.borderColor set];
		[bgPath stroke];
	}
//	[NSGraphicsContext restoreGraphicsState];
	[bg unlockFocus];
	return [NSColor colorWithPatternImage:bg];
}
- (NSBezierPath *)_backgroundPath	{
	/*
	 Construct path for window background, taking account of:
	 1. hasArrow
	 2. _side
	 3. drawsRoundCornerBesideArrow
	 4. arrowBaseWidth
	 5. arrowHeight
	 6. cornerRadius
	 */
	
	float scaleFactor = AZATTACHEDWINDOW_SCALE_FACTOR;
	float scaledRadius = self.cornerRadius * scaleFactor;
	float scaledArrowWidth = self.arrowBaseWidth * scaleFactor;
	float halfArrowWidth = scaledArrowWidth / 2.0;
	NSRect contentArea = NSInsetRect(_viewFrame,
									 -self.viewMargin * scaleFactor,
									 -self.viewMargin * scaleFactor);
	float minX = NSMinX(contentArea) * scaleFactor;
	float midX = NSMidX(contentArea) * scaleFactor;
	float maxX = NSMaxX(contentArea) * scaleFactor;
	float minY = NSMinY(contentArea) * scaleFactor;
	float midY = NSMidY(contentArea) * scaleFactor;
	float maxY = NSMaxY(contentArea) * scaleFactor;
	
	NSBezierPath *path = [NSBezierPath bezierPath];
	[path setLineJoinStyle:NSRoundLineJoinStyle];
	
	// Begin at top-left. This will be either after the rounded corner, or 
	// at the top-left point if cornerRadius is zero and/or we're drawing 
	// the arrow at the top-left or left-top without a rounded corner.
	NSPoint currPt = NSMakePoint(minX, maxY);
	if (scaledRadius > 0 &&
		(self.drawsRoundCornerBesideArrow ||
			(_side != AZPositionBottomRight && _side != AZPositionBottomRight)) 
		) {
		currPt.x += scaledRadius;
	}
	
	NSPoint endOfLine = NSMakePoint(maxX, maxY);
	BOOL shouldDrawNextCorner = NO;
	if (scaledRadius > 0 &&
		(self.drawsRoundCornerBesideArrow ||
		 (_side != AZPositionBottomLeft && _side != AZPositionBottomLeft)) 
		) {
		endOfLine.x -= scaledRadius;
		shouldDrawNextCorner = YES;
	}
	
	[path moveToPoint:currPt];
	
	// If arrow should be drawn at top-left point, draw it.
	if (_side == AZPositionBottomRight) {
		[self _appendArrowToPath:path];
	} else if (_side == AZPositionBottom) {
		// Line to relevant point before arrow.
		[path lineToPoint:NSMakePoint(midX - halfArrowWidth, maxY)];
		// Draw arrow.
		[self _appendArrowToPath:path];
	} else if (_side == AZPositionBottomLeft) {
		// Line to relevant point before arrow.
		[path lineToPoint:NSMakePoint(endOfLine.x - scaledArrowWidth, maxY)];
		// Draw arrow.
		[self _appendArrowToPath:path];
	}
	
	// Line to end of this side.
	[path lineToPoint:endOfLine];
	
	// Rounded corner on top-right.
	if (shouldDrawNextCorner) {
		[path appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY) 
									   toPoint:NSMakePoint(maxX, maxY - scaledRadius) 
										radius:scaledRadius];
	}
	
	
	// Draw the right side, beginning at the top-right.
	endOfLine = NSMakePoint(maxX, minY);
	shouldDrawNextCorner = NO;
	if (scaledRadius > 0 &&
		(_drawsRoundCornerBesideArrow || 
		 (_side != AZPositionTopLeft && _side != AZPositionTopLeft)) 
		) {
		endOfLine.y += scaledRadius;
		shouldDrawNextCorner = YES;
	}
	
	// If arrow should be drawn at right-top point, draw it.
	if (_side == AZPositionBottomLeft) {
		[self _appendArrowToPath:path];
	} else if (_side == AZPositionLeft) {
		// Line to relevant point before arrow.
		[path lineToPoint:NSMakePoint(maxX, midY + halfArrowWidth)];
		// Draw arrow.
		[self _appendArrowToPath:path];
	} else if (_side == AZPositionTopLeft) {
		// Line to relevant point before arrow.
		[path lineToPoint:NSMakePoint(maxX, endOfLine.y + scaledArrowWidth)];
		// Draw arrow.
		[self _appendArrowToPath:path];
	}
	
	// Line to end of this side.
	[path lineToPoint:endOfLine];
	
	// Rounded corner on bottom-right.
	if (shouldDrawNextCorner) {
		[path appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY) 
									   toPoint:NSMakePoint(maxX - scaledRadius, minY) 
										radius:scaledRadius];
	}
	
	
	// Draw the bottom side, beginning at the bottom-right.
	endOfLine = NSMakePoint(minX, minY);
	shouldDrawNextCorner = NO;
	if (scaledRadius > 0 &&
		(self.drawsRoundCornerBesideArrow ||
		 (_side != AZPositionTopRight && _side != AZPositionTopRight)) 
		) {
		endOfLine.x += scaledRadius;
		shouldDrawNextCorner = YES;
	}
	
	// If arrow should be drawn at bottom-right point, draw it.
	if (_side == AZPositionTopLeft) {
		[self _appendArrowToPath:path];
	} else if (_side == AZPositionTop) {
		// Line to relevant point before arrow.
		[path lineToPoint:NSMakePoint(midX + halfArrowWidth, minY)];
		// Draw arrow.
		[self _appendArrowToPath:path];
	} else if (_side == AZPositionTopRight) {
		// Line to relevant point before arrow.
		[path lineToPoint:NSMakePoint(endOfLine.x + scaledArrowWidth, minY)];
		// Draw arrow.
		[self _appendArrowToPath:path];
	}
	
	// Line to end of this side.
	[path lineToPoint:endOfLine];
	
	// Rounded corner on bottom-left.
	if (shouldDrawNextCorner) {
		[path appendBezierPathWithArcFromPoint:NSMakePoint(minX, minY) 
									   toPoint:NSMakePoint(minX, minY + scaledRadius) 
										radius:scaledRadius];
	}
	
	
	// Draw the left side, beginning at the bottom-left.
	endOfLine = NSMakePoint(minX, maxY);
	shouldDrawNextCorner = NO;
	if (scaledRadius > 0 &&
		(self.drawsRoundCornerBesideArrow ||
		 (_side != AZPositionBottomRight && _side != AZPositionBottomRight)) 
		) {
		endOfLine.y -= scaledRadius;
		shouldDrawNextCorner = YES;
	}
	
	// If arrow should be drawn at left-bottom point, draw it.
	if (_side == AZPositionTopRight) {
		[self _appendArrowToPath:path];
	} else if (_side == AZPositionRight) {
		// Line to relevant point before arrow.
		[path lineToPoint:NSMakePoint(minX, midY - halfArrowWidth)];
		// Draw arrow.
		[self _appendArrowToPath:path];
	} else if (_side == AZPositionBottomRight) {
		// Line to relevant point before arrow.
		[path lineToPoint:NSMakePoint(minX, endOfLine.y - scaledArrowWidth)];
		// Draw arrow.
		[self _appendArrowToPath:path];
	}
	
	// Line to end of this side.
	[path lineToPoint:endOfLine];
	
	// Rounded corner on top-left.
	if (shouldDrawNextCorner) {
		[path appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
									   toPoint:NSMakePoint(minX + scaledRadius, maxY) 
										radius:scaledRadius];
	}
	
	[path closePath];
	return path;
}
- (void)_appendArrowToPath:(NSBezierPath *)path
{
	if (!self.hasArrow) {
		return;
	}
	
	float scaleFactor = AZATTACHEDWINDOW_SCALE_FACTOR;
	float scaledArrowWidth = self.arrowBaseWidth * scaleFactor;
	float halfArrowWidth = scaledArrowWidth / 2.0;
	float scaledArrowHeight = self.arrowHeight * scaleFactor;
	NSPoint currPt = [path currentPoint];
	NSPoint tipPt = currPt;
	NSPoint endPt = currPt;
	
	// Note: we always build the arrow path in a clockwise direction.
	switch (_side) {
		case AZPositionLeft:
		case AZPositionTopLeft:
		case AZPositionBottomLeft:
			// Arrow points towards right. We're starting from the top.
			tipPt.x += scaledArrowHeight;
			tipPt.y -= halfArrowWidth;
			endPt.y -= scaledArrowWidth;
			break;
		case AZPositionRight:
		case AZPositionTopRight:
		case AZPositionBottomRight:
			// Arrow points towards left. We're starting from the bottom.
			tipPt.x -= scaledArrowHeight;
			tipPt.y += halfArrowWidth;
			endPt.y += scaledArrowWidth;
			break;
		case AZPositionTop:
//		case AZPositionTopLeft:
//		case AZPositionTopRight:
			// Arrow points towards bottom. We're starting from the right.
			tipPt.y -= scaledArrowHeight;
			tipPt.x -= halfArrowWidth;
			endPt.x -= scaledArrowWidth;
			break;
		case AZPositionBottom:
//		case AZPositionBottomLeft:
//		case AZPositionBottomRight:
			// Arrow points towards top. We're starting from the left.
			tipPt.y += scaledArrowHeight;
			tipPt.x += halfArrowWidth;
			endPt.x += scaledArrowWidth;
			break;
		default:
			break; // won't happen, but this satisfies gcc with -Wall
	}
	
	[path lineToPoint:tipPt];
	[path lineToPoint:endPt];
}
- (void)_redisplay
{
	if (_resizing) {
		return;
	}
	
	_resizing = YES;
	NSDisableScreenUpdates();
	[self _updateGeometry];
	[self _updateBackground];
	NSEnableScreenUpdates();
	_resizing = NO;
}
# pragma mark Window Behaviour
- (BOOL)canBecomeMainWindow
{
	return YES;
}
- (BOOL)canBecomeKeyWindow
{
	return YES;
}
- (BOOL)isExcludedFromWindowsMenu
{
	return YES;
}
- (BOOL)validateMenuItem:(NSMenuItem *)item
{
	if (_window) {
		return [_window validateMenuItem:item];
	}
	return [super validateMenuItem:item];
}
- (IBAction)performClose:(id)sender
{
	if (_window) {
		[_window performClose:sender];
	} else {
		[super performClose:sender];
	}
}
# pragma mark Notification handlers
- (void)windowDidResize:(NSNotification *)note
{
	[self _redisplay];
}
#pragma mark Accessors
- (NSColor *)windowBackgroundColor {
	return _AZBackgroundColor;
}
- (void)setBackgroundColor:(NSColor *)value {
	if (_AZBackgroundColor != value) {
		_AZBackgroundColor = [value copy];
		
		[self _updateBackground];
	}
}
//- (NSColor *)borderColor {
//	return borderColor;
//}
- (void)setBorderColor:(NSColor *)value {
	if (_borderColor != value) {
		_borderColor = [value copy];
		
		[self _updateBackground];
	}
}
//- (float)borderWidth {
//	return borderWidth;
//}
- (void)setBorderWidth:(float)value {
	if (self.borderWidth != value) {
		float maxBorderWidth = self.viewMargin;
		if (value <= maxBorderWidth) {
			_borderWidth = value;
		} else {
			_borderWidth = maxBorderWidth;
		}
		
		[self _updateBackground];
	}
}
//- (float)viewMargin {
//	return viewMargin;
//}
- (void)setViewMargin:(float)value {
	if (self.viewMargin != value) {
		_viewMargin = MAX(value, 0.0);
		
		// Adjust cornerRadius appropriately (which will also adjust arrowBaseWidth).
		[self setCornerRadius:self.cornerRadius];
	}
}
//- (float)arrowBaseWidth {
//	return arrowBaseWidth;
//}
- (void)setArrowBaseWidth:(float)value {
	float maxWidth = (MIN(_viewFrame.size.width, _viewFrame.size.height) + 
					  (self.viewMargin * 2.0)) - self.cornerRadius;
	if (self.drawsRoundCornerBesideArrow) {
		maxWidth -= self.cornerRadius;
	}
	if (value <= maxWidth) {
		_arrowBaseWidth = value;
	} else {
		_arrowBaseWidth = maxWidth;
	}
	
	[self _redisplay];
}
//- (float)arrowHeight {
//	return arrowHeight;
//}
- (void)setArrowHeight:(float)value {
	if (self.arrowHeight != value) {
		_arrowHeight = value;
		
		[self _redisplay];
	}
}
//- (float)hasArrow {
//	return hasArrow;
//}
- (void)setHasArrow:(BOOL)value {
	if (self.hasArrow != value) {
		_hasArrow = value;
		
		[self _updateBackground];
	}
}
//- (float)cornerRadius {
//	return cornerRadius;
//}
- (void)setCornerRadius:(float)value {
	float maxRadius = ((MIN(_viewFrame.size.width, _viewFrame.size.height) + 
						(self.viewMargin * 2.0)) - self.arrowBaseWidth) / 2.0;
	if (value <= maxRadius) {
		_cornerRadius = value;
	} else {
		_cornerRadius = maxRadius;
	}
	_cornerRadius = MAX(self.cornerRadius, 0.0);
	
	// Adjust arrowBaseWidth appropriately.
	[self setArrowBaseWidth:self.arrowBaseWidth];
}
//- (float)drawsRoundCornerBesideArrow {
//	return drawsRoundCornerBesideArrow;
//}
- (void)setDrawsRoundCornerBesideArrow:(BOOL)value {
	if (_drawsRoundCornerBesideArrow != value) {
		_drawsRoundCornerBesideArrow = value;
		
		[self _redisplay];
	}
}
- (void)setBackgroundImage:(NSImage *)value
{
	if (value) {
		[self setBackgroundColor:[NSColor colorWithPatternImage:value]];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent
 {
 NSPoint currentLocation;
 NSPoint newOrigin;
 NSRect  screenFrame = [[NSScreen mainScreen] frame];
 NSRect  windowFrame = [self frame];

 currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
 newOrigin.x = currentLocation.x - initialLocation.x;
 newOrigin.y = currentLocation.y - initialLocation.y;

 if( (newOrigin.y + windowFrame.size.height) > (NSMaxY(screenFrame) - 22) ){
 //	[NSMenu menuBarHeight]) ){
 // Prevent dragging into the menu bar area
 //	newOrigin.y = NSMaxY(screenFrame) - windowFrame.size.height - 22;
 //	 [NSMenuView menuBarHeight];
 }

 if (newOrigin.y < NSMinY(screenFrame)) {
 // Prevent dragging off bottom of screen
 newOrigin.y = NSMinY(screenFrame);
 }
 if (newOrigin.x < NSMinX(screenFrame)) {
 // Prevent dragging off left of screen
 newOrigin.x = NSMinX(screenFrame);
 }
 if (newOrigin.x > NSMaxX(screenFrame) - windowFrame.size.width) {
 // Prevent dragging off right of screen
 newOrigin.x = NSMaxX(screenFrame) - windowFrame.size.width;
 }
 [self setFrameOrigin:newOrigin];
 }
 - (void)mouseDown:(NSEvent *)theEvent
 {
 NSRect windowFrame = [self frame];

 // Get mouse location in global coordinates
 initialLocation = [self convertBaseToScreen:[theEvent locationInWindow]];
 initialLocation.x -= windowFrame.origin.x;
 initialLocation.y -= windowFrame.origin.y;
 }

@end
