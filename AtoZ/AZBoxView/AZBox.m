//
//  AZBox.m
//  AtoZ
//
//  Created by Alex Gray on 7/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZBox.h"

@implementation AZBox
{
	BOOL _wasAcceptingMouseEvents;
	NSTrackingArea *_trackingArea;
	NSBezierPath *_path;
	NSGradient *_gradient;
	NSShadow *_shadow;
	NSTimer *_timer;
	NSTimeInterval _interval;
	BOOL _hovered;
	BOOL _selected;
	float _mPhase;
	float _all;
}
@synthesize pattern = _pattern, color = _color, tag = _tag, representedObject = _representedObject, string = _string, radius = _radius;

- (id) initWithObject:(id)object {
	_representedObject = object;
	return [self initWithFrame:NSZeroRect];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_color = ([_representedObject valueForKey:@"color"] ? 		
				  [_representedObject valueForKey:@"color"] : RANDOMCOLOR);
		if (!_representedObject) while ( ![_color isRedish] ) _color = RANDOMCOLOR;
		_radius = 5;
		_selected = NO;
		_gradient = [self gradient];
		_path = [self apath];
		_mPhase = 0;
		_interval = .05;
    }
	return self;
}
-(void) awakeFromNib {	[self updateTrackingAreas]; }

-(void) updateTrackingAreas {
	if (_trackingArea) _trackingArea = nil;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
			options:NSTrackingMouseEnteredAndExited
 | NSTrackingActiveInActiveApp
//			| NSTrackingMouseMoved | NSTrackingActiveInActiveApp 
			owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (NSColor*) pattern {
//	if (!_backgroundColor) {
//		NSString *imagePath = [[NSBundle bundleForClass:[AtoZ class]] pathForImageResource:@"linen.png"];
//		if ( imagePath != nil ) { NSLog(@"setting the linen"); 
//			_backgroundColor = 
			
			return [NSColor colorWithPatternImage: [[NSImage imageInFrameworkWithFileName:@"linen.png"] tintedWithColor:_color]];
			
//			[[NSImage alloc] initWithContentsOfFile:imagePath]];
//		} 
//		if  (_backgroundColor == nil)
//			NSLog(@"Linen not found"); _backgroundColor = RANDOMCOLOR; 
//	
//	return _backgroundColor;	
}

-(void) setColor:(NSColor *)color {
	
	_color = color;
	_gradient = [self gradient];
	[self setNeedsDisplay: YES];
}

-(NSGradient*) gradient {	NSLog(@"call to gradient: %ld", [self tag]);
	return [[NSGradient alloc] initWithStartingColor:_color.brighter.brighter endingColor:_color.darker.darker];
}

- (NSBezierPath*) apath {
	NSBezierPath *aP = [NSBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:0];
	[aP setLineWidth: 5];
	return  aP;

}
- (void)drawRect:(NSRect)dirtyRect
{

//	NSLog(@"Tag: %ld ALL: %f, mPhase: %f", self.tag, _all, _mPhase);
//	[NSGraphicsContext saveGraphicsState];
//	[[NSGraphicsContext currentContext] setShouldAntialias:NO];
//	[NSShadow setShadowWithOffset:NSMakeSize(10,10) blurRadius:11 color:BLACK];
//	[[self backgroundColor] set];
	NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    
    
    BOOL outer = NO;
    BOOL background = YES;
    BOOL stroke = YES;
    BOOL innerStroke = YES;
    NSRect frame = self.bounds;
    if(outer) {
//        [ctx saveGraphicsState];
        NSBezierPath *outerClip = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:_radius yRadius:_radius];
        [outerClip setClip];
		
        NSGradient *outerGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                     [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.0f, 
                                     [NSColor colorWithDeviceWhite:0.21f alpha:1.0f], 1.0f, 
                                     nil];
        
        [outerGradient drawInRect:[outerClip bounds] angle:90.0f];
//        [ctx restoreGraphicsState];
    }
	
    if(background) {
//        [ctx saveGraphicsState];
        NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) xRadius:_radius yRadius:_radius];
        [backgroundPath setClip];
        
//        NSGradient *backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
//			[NSColor colorWithDeviceWhite:0.17f alpha:1.0f], 0.0f, 
//			[NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.12f, 
//			[NSColor colorWithDeviceWhite:0.27f alpha:1.0f], 0.5f, 
//			[NSColor colorWithDeviceWhite:0.30f alpha:1.0f], 0.5f, 
//			[NSColor colorWithDeviceWhite:0.42f alpha:1.0f], 0.98f, 
//			[NSColor colorWithDeviceWhite:0.50f alpha:1.0f], 1.0f, 
//			nil];
        
        [[self gradient] drawInRect:[backgroundPath bounds] angle:270];

//        [ctx restoreGraphicsState];
    }
    
    if(stroke) {
//        [ctx saveGraphicsState];
        [[NSColor colorWithDeviceWhite:0.12f alpha:1.0f] setStroke];
        [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.5f, 1.5f) xRadius:_radius yRadius:_radius] stroke];
//        [ctx restoreGraphicsState];
    }
    
    if(innerStroke) {
        [ctx saveGraphicsState];
        [[NSColor colorWithDeviceWhite:1.0f alpha:0.1f] setStroke];
        [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.5f, 2.5f) xRadius:_radius yRadius:_radius] stroke];
        [ctx restoreGraphicsState];        
    }
	if(_hovered) {
        [ctx saveGraphicsState];
        [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) xRadius:_radius yRadius:_radius] setClip];
        [[NSColor colorWithCalibratedWhite:0.0f alpha:0.35] setFill];
        NSRectFillUsingOperation(frame, NSCompositeSourceOver);
        [ctx restoreGraphicsState];
    }

	if (_selected) {
		[ctx saveGraphicsState];
		NSRect insidef = NSInsetRect(frame, 2.5f, 2.5f);
		_all = ( NSMaxY(insidef) + NSMaxX(insidef)  - (2* _radius) + (.5* (pi *(2*_radius))) );
		NSBezierPath *inside = [NSBezierPath bezierPathWithRoundedRect:insidef xRadius:_radius yRadius:_radius];
		[inside setLineWidth:4];
		[inside setLineCapStyle:NSRoundLineCapStyle];
		[(_color.isDark ? _color.brighter : _color.darker) set];
		[inside strokeInsideWithinRect:insidef];
 		CGFloat dashArray[4] = { (_all/4), (_all/4), (_all/4), (_all/4) };
		[inside setLineDash:dashArray count:4 phase:_mPhase];
		[BLACK set];
		[inside strokeInsideWithinRect:insidef];
		[ctx restoreGraphicsState];

	}
//	[[self path] fill];
//	[_gradient drawInBezierPath:_path angle:270];
//	NSShadow *sh = [[NSShadow alloc]init];
//	[sh setShadowColor:_color.brighter.brighter];
//	[sh setShadowOffset:NSMakeSize(4, -4)];
//	[sh setShadowBlurRadius:4];///3];
//	[_path fillWithInnerShadow:sh];
//	NSShadow *sh1 = [[NSShadow alloc]init];
//	[sh1 setShadowColor:_color.darker.darker];
//	[sh1 setShadowOffset:NSMakeSize(-4., 4)];
//	[sh1 setShadowBlurRadius:4];///3];
//	[_path fillWithInnerShadow:sh1];
//	if (_hovered) {
////		NSLog(@"drawing %ld hovered", self.tag);
//		[[BLACK colorWithAlphaComponent:.5] set];
//		[_path fill];
//		
//	}
//	} //else { [[self color].darker set]; [[self path] stroke]; }
}


- (void)handleAntAnimationTimer:(NSTimer*)timer {
//	float all = (self.bounds.size.width+self.bounds.size.height);
	_mPhase = (_mPhase < _all ? _mPhase + ((_all/8)/4) : 0);
	[self setNeedsDisplay:YES];
}


- (void)mouseEntered:(NSEvent *)theEvent {
//    wasAcceptingMouseEvents = [[self window] acceptsMouseMovedEvents];
//    [[self window] setAcceptsMouseMovedEvents:YES];
//    [[self window] makeFirstResponder:self];
//    NSPoint eyeCenter = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSLog(@"mouse entered %@", NSStringFromRect([self frame]));
	_hovered = YES;
	[self setNeedsDisplay:YES];
}
-(void) mouseUp:(NSEvent *)theEvent
{
	if (_hovered) {
		if (_selected)  { 
			[_timer invalidate];
			NSLog(@"%ld %s, was hit!  %@ Rep: %@", _tag,
				  _selected ? "SELECTED" : "NOT SELECTED",
				  NSStringFromRect(self.frame), _representedObject);			
			_all = 0;	
			_selected = NO; 
			[self setNeedsDisplay:YES]; return;
		}
		else { 
			 _timer = [NSTimer scheduledTimerWithTimeInterval:.05
														 target:self 
													   selector:@selector(handleAntAnimationTimer:) 
													   userInfo:nil 
														repeats:YES];
			_selected = YES;
			self.needsDisplay = YES; return;
		}
	}		
}
- (void)mouseMoved:(NSEvent *)theEvent {
//	[self rotateByAngle:5];
//    NSPoint eyeCenter = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//    eyeBox = NSMakeRect((eyeCenter.x-10.0), (eyeCenter.y-10.0), 20.0, 20.0);
//    [self setNeedsDisplayInRect:eyeBox];
//    [self setNeedsDisplay:YES];
//	NSLog(@"mouse moved in %ld", [self tag]);
}

- (void)mouseExited:(NSEvent *)theEvent {
	NSLog(@"mouse exited %ld", [self tag]);

//    [[self window] setAcceptsMouseMovedEvents:wasAcceptingMouseEvents];
	_hovered =	NO;
	[self setNeedsDisplay:YES];
}

@end
