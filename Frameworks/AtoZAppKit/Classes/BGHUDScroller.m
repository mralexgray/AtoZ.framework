//
//  BGHudScroller.m
//  HUDScroller
//
//  Created by BinaryGod on 5/22/08.
//


// Special thanks to Matt Gemmell (http://mattgemmell.com/) for helping me solve the
// transparent drawing issues.  Your awesome man!!!

#import "BGHUDScroller.h"


@implementation BGHUDScroller

#pragma mark Drawing Functions

@synthesize themeKey;

-(id)init {
	
	self = [super init];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		if([aDecoder containsValueForKey: @"themeKey"]) {
			
			self.themeKey = [aDecoder decodeObjectForKey: @"themeKey"];
		} else {
			self.themeKey = @"gradientTheme";
		}
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

- (NSString*)themeKey {
	
	return [self target] && [[self target] respondsToSelector: @selector(themeKey)] ? [[self target] themeKey] : nil;
}

- (void)drawRect:(NSRect)rect {
	
	// See if we should use system default or supplied value
	if([self arrowsPosition] == NSScrollerArrowsDefaultSetting) {
		
		arrowPosition = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:NSGlobalDomain] valueForKey: @"AppleScrollBarVariant"];
		
		
		if(arrowPosition == nil) {
			
			arrowPosition = @"DoubleMax";
		}
	} else {
		
		if([self arrowsPosition] == NSScrollerArrowsNone) {
			
			arrowPosition = @"None";
		}
	}
	
	NSDisableScreenUpdates();
	
	[[NSColor colorWithCalibratedWhite: 0.7f alpha: 1.0f] set];
	NSRectFill([self bounds]);
	
	// Draw knob-slot.
	[self drawKnobSlotInRect: [self bounds] highlight: YES];
	
	// Draw knob
	[self drawKnob];
	
	// Draw arrows	
	[self drawArrow: NSScrollerIncrementArrow highlight: ([self hitPart] == NSScrollerIncrementLine)];
	[self drawArrow: NSScrollerDecrementArrow highlight: ([self hitPart] == NSScrollerDecrementLine)];
	
	[[self window] invalidateShadow];
	
	NSEnableScreenUpdates();
}

- (void)drawKnob {
	NSRect knobRect = [self rectForPart: NSScrollerKnob];
	if ([self usableParts] == NSAllScrollerParts &&
		!NSEqualRects(knobRect, NSZeroRect)) {
		if(![self isHoriz]) {
			//Draw Knob
			NSBezierPath *knob = [[NSBezierPath alloc] init];
			
			
			[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5f) /2), (knobRect.origin.y + ((knobRect.size.width -2) /2)))
											 radius: (knobRect.size.width -2) /2
										 startAngle: 180
										   endAngle: 0];
			
			[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5f) /2), ((knobRect.origin.y + knobRect.size.height) - ((knobRect.size.width -2) /2)))
											 radius: (knobRect.size.width -2) /2
										 startAngle: 0
										   endAngle: 180];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
			[knob fill];
			
			knobRect.origin.x += 1;
			knobRect.origin.y += 1;
			knobRect.size.width -= 2;
			knobRect.size.height -= 2;
			
			knob = [[NSBezierPath alloc] init];
			
			[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5f) /2), (knobRect.origin.y + ((knobRect.size.width -2) /2)))
											 radius: (knobRect.size.width -2) /2
										 startAngle: 180
										   endAngle: 0];
			
			[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.width - .5f) /2), ((knobRect.origin.y + knobRect.size.height) - ((knobRect.size.width -2) /2)))
											 radius: (knobRect.size.width -2) /2
										 startAngle: 0
										   endAngle: 180];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerKnobGradient] drawInBezierPath: knob angle: 0];
			
		} else {
			
			//Draw Knob
			NSBezierPath *knob = [[NSBezierPath alloc] init];
			
			[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.height - .5f) /2), (knobRect.origin.y + ((knobRect.size.height -1) /2)))
											 radius: (knobRect.size.height -1) /2
										 startAngle: 90
										   endAngle: 270];
			
			[knob appendBezierPathWithArcWithCenter: NSMakePoint((knobRect.origin.x + knobRect.size.width) - ((knobRect.size.height - .5f) /2), (knobRect.origin.y + ((knobRect.size.height -1) /2)))
											 radius: (knobRect.size.height -1) /2
										 startAngle: 270
										   endAngle: 90];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
			[knob fill];
			
			knobRect.origin.x += 1;
			knobRect.origin.y += 1;
			knobRect.size.width -= 2;
			knobRect.size.height -= 2;
			
			knob = [[NSBezierPath alloc] init];
			
			[knob appendBezierPathWithArcWithCenter: NSMakePoint(knobRect.origin.x + ((knobRect.size.height - .5f) /2), (knobRect.origin.y + ((knobRect.size.height -1) /2)))
											 radius: (knobRect.size.height -1) /2
										 startAngle: 90
										   endAngle: 270];
			
			[knob appendBezierPathWithArcWithCenter: NSMakePoint((knobRect.origin.x + knobRect.size.width) - ((knobRect.size.height - .5f) /2), (knobRect.origin.y + ((knobRect.size.height -1) /2)))
											 radius: (knobRect.size.height -1) /2
										 startAngle: 270
										   endAngle: 90];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerKnobGradient] drawInBezierPath: knob angle: 270];
			
		}
	}
}

- (void)drawArrow:(NSScrollerArrow)arrow highlightPart:(NSUInteger)part {
	if ([self usableParts] != NSNoScrollerParts) {
		if(arrow == NSScrollerDecrementArrow) {
			
			if(part == (NSUInteger)-1 || part == 0) {
				
				[self drawDecrementArrow: NO];
			} else {
				
				[self drawDecrementArrow: YES];
			}
		}
		
		if(arrow == NSScrollerIncrementArrow) {
			
			if(part == 1 || part == (NSUInteger)-1) {
				
				[self drawIncrementArrow: NO];
			} else {
				
				[self drawIncrementArrow: YES];
			}
		}
	}
}

- (void)drawKnobSlotInRect:(NSRect)rect highlight:(BOOL)highlight {
	
	if(![self isHoriz]) {
		
		//Draw Knob Slot
		[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerTrackGradient] drawInRect: rect angle: 0];
		
		if([arrowPosition isEqualToString: @"DoubleMax"]) {
			
			//Adjust rect height for top base
			rect.size.height = 8;
			
			//Draw Top Base
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.size.width /2, rect.size.height + (rect.size.width /2) -5)
											 radius: (rect.size.width ) /2
										 startAngle: 180
										   endAngle: 0];
			
			//Add the rest of the points
			basePoints[3] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
			basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y);
			basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
			
		} else if([arrowPosition isEqualToString: @"None"]) {
			
			//Adjust rect height for top base
			NSRect topRect = rect;
			topRect.size.height = 8;
			
			//Draw Top Base
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			[path appendBezierPathWithArcWithCenter: NSMakePoint(topRect.size.width /2, topRect.size.height + (topRect.size.width /2) -5)
											 radius: (topRect.size.width ) /2
										 startAngle: 180
										   endAngle: 0];
			
			//Add the rest of the points
			basePoints[3] = NSMakePoint( topRect.origin.x, topRect.origin.y + topRect.size.height);
			basePoints[2] = NSMakePoint( topRect.origin.x, topRect.origin.y);
			basePoints[1] = NSMakePoint( topRect.origin.x + topRect.size.width, topRect.origin.y);
			basePoints[0] = NSMakePoint( topRect.origin.x + topRect.size.width, topRect.origin.y + topRect.size.height);
			
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
			
			
			//Draw Decrement Button
			NSRect bottomRect = rect;
			bottomRect.origin.y = rect.size.height - 4;
			bottomRect.size.height = 4;
			
			path = [[NSBezierPath alloc] init];
			
			//Add Notch
			[path appendBezierPathWithArcWithCenter: NSMakePoint((bottomRect.size.width ) /2, (bottomRect.origin.y  - ((bottomRect.size.width ) /2) + 1))
											 radius: (bottomRect.size.width ) /2
										 startAngle: 0
										   endAngle: 180];
			
			//Add the rest of the points
			basePoints[0] = NSMakePoint( bottomRect.origin.x, bottomRect.origin.y);
			basePoints[1] = NSMakePoint( bottomRect.origin.x, bottomRect.origin.y + bottomRect.size.height);
			basePoints[2] = NSMakePoint( bottomRect.origin.x + bottomRect.size.width, bottomRect.origin.y + bottomRect.size.height);
			basePoints[3] = NSMakePoint( bottomRect.origin.x + bottomRect.size.width, bottomRect.origin.y);
			
			//Add Points to Path
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
		}
	} else {
		
		//Draw Knob Slot
		[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerTrackGradient] drawInRect: rect angle: 270];
		
		if([arrowPosition isEqualToString: @"DoubleMax"]) {
			
			//Adjust rect height for top base
			rect.size.width = 8;
			
			//Draw Top Base
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			[path appendBezierPathWithArcWithCenter: NSMakePoint((rect.size.height /2) +5, rect.origin.y + (rect.size.height /2) )
											 radius: (rect.size.height ) /2
										 startAngle: 90
										   endAngle: 270];
			
			//Add the rest of the points
			basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
			basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y);
			basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
			basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
			
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
			
		} else if([arrowPosition isEqualToString: @"None"]) {
			
			//Adjust rect height for top base
			NSRect topRect = rect;
			topRect.size.width = 8;
			
			//Draw Top Base
			NSBezierPath *path = [[NSBezierPath alloc] init];
			NSPoint basePoints[4];
			
			[path appendBezierPathWithArcWithCenter: NSMakePoint((topRect.size.height /2) +5, topRect.origin.y + (topRect.size.height /2) )
											 radius: (topRect.size.height ) /2
										 startAngle: 90
										   endAngle: 270];
			
			//Add the rest of the points
			basePoints[2] = NSMakePoint( topRect.origin.x, topRect.origin.y + topRect.size.height);
			basePoints[1] = NSMakePoint( topRect.origin.x, topRect.origin.y);
			basePoints[0] = NSMakePoint( topRect.origin.x + topRect.size.width, topRect.origin.y);
			basePoints[3] = NSMakePoint( topRect.origin.x + topRect.size.width, topRect.origin.y + topRect.size.height);
			
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
			
			
			// Bottom Base
			//Draw Decrement Button
			NSRect bottomRect = rect;
			bottomRect.origin.x = rect.size.width - 4;
			bottomRect.size.width = 4;
			
			path = [[NSBezierPath alloc] init];
			
			//Add Notch
			[path appendBezierPathWithArcWithCenter: NSMakePoint(bottomRect.origin.x - ((bottomRect.size.height ) /2), (bottomRect.origin.y  + ((bottomRect.size.height ) /2) ))
											 radius: (bottomRect.size.height ) /2
										 startAngle: 270
										   endAngle: 90];
			
			//Add the rest of the points
			basePoints[3] = NSMakePoint( bottomRect.origin.x - (((bottomRect.size.height ) /2) -1), bottomRect.origin.y);
			basePoints[0] = NSMakePoint( bottomRect.origin.x - (((bottomRect.size.height ) /2) -1), bottomRect.origin.y + bottomRect.size.height);
			basePoints[1] = NSMakePoint( bottomRect.origin.x + bottomRect.size.width, bottomRect.origin.y + bottomRect.size.height);
			basePoints[2] = NSMakePoint( bottomRect.origin.x + bottomRect.size.width, bottomRect.origin.y);
			
			//Add Points to Path
			[path appendBezierPathWithPoints: basePoints count: 4];
			
			[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 90];
		}
	}
}

- (void)drawDecrementArrow:(BOOL)highlighted {
	NSRect rect = [self rectForPart: NSScrollerDecrementLine];
	if (!NSEqualRects(rect, NSZeroRect)) {
		if(![self isHoriz]) {
			
			if([arrowPosition isEqualToString: @"DoubleMax"]) {
				
				//Draw Decrement Button
				NSBezierPath *path = [[NSBezierPath alloc] init];
				NSPoint basePoints[4];
				
				//Add Notch
				[path appendBezierPathWithArcWithCenter: NSMakePoint((rect.size.width ) /2, (rect.origin.y  - ((rect.size.width ) /2) + 1))
												 radius: (rect.size.width ) /2
											 startAngle: 0
											   endAngle: 180];
				
				//Add the rest of the points
				basePoints[0] = NSMakePoint( rect.origin.x, rect.origin.y);
				basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
				basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
				basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
				
				//Add Points to Path
				[path appendBezierPathWithPoints: basePoints count: 4];
				
				//Fill Path
				if(!highlighted) {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowPushedGradient] drawInBezierPath: path angle: 0];
				}
				
				//Create Arrow Glyph
				NSBezierPath *arrow = [[NSBezierPath alloc] init];
				
				NSPoint points[3];
				points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) -3);
				points[1] = NSMakePoint( (rect.size.width /2) +3.5f, rect.origin.y + (rect.size.height /2) +3);
				points[2] = NSMakePoint( (rect.size.width /2) -3.5f, rect.origin.y + (rect.size.height /2) +3);
				
				[arrow appendBezierPathWithPoints: points count: 3];
				
				//[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				[arrow fill];
				
				//Create Devider Line
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				
				[NSBezierPath strokeLineFromPoint: NSMakePoint(0, (rect.origin.y + rect.size.height) +.5f)
										  toPoint: NSMakePoint(rect.size.width, (rect.origin.y + rect.size.height) +.5f)];
				
				
			} else if([arrowPosition isEqualToString: @"Single"]) {
				
				NSBezierPath *path = [[NSBezierPath alloc] init];
				NSPoint basePoints[4];
				
				[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.size.width /2, rect.size.height + (rect.size.width /2) -3)
												 radius: (rect.size.width ) /2
											 startAngle: 180
											   endAngle: 0];
				
				//Add the rest of the points
				basePoints[3] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
				basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y);
				basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
				basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
				
				[path appendBezierPathWithPoints: basePoints count: 4];
				
				//Fill Path
				if(!highlighted) {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowPushedGradient] drawInBezierPath: path angle: 0];
				}
				
				//Create Arrow Glyph
				NSBezierPath *arrow = [[NSBezierPath alloc] init];
				
				NSPoint points[3];
				points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) -3);
				points[1] = NSMakePoint( (rect.size.width /2) +3.5f, rect.origin.y + (rect.size.height /2) +3);
				points[2] = NSMakePoint( (rect.size.width /2) -3.5f, rect.origin.y + (rect.size.height /2) +3);
				
				[arrow appendBezierPathWithPoints: points count: 3];
				
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				[arrow fill];
				
			}
		} else {
			
			if([arrowPosition isEqualToString: @"DoubleMax"]) {
				
				//Draw Decrement Button
				NSBezierPath *path = [[NSBezierPath alloc] init];
				NSPoint basePoints[4];
				
				//Add Notch
				[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.origin.x - ((rect.size.height ) /2), (rect.origin.y  + ((rect.size.height ) /2) ))
												 radius: (rect.size.height ) /2
											 startAngle: 270
											   endAngle: 90];
				
				//Add the rest of the points
				basePoints[3] = NSMakePoint( rect.origin.x - (((rect.size.height ) /2) -1), rect.origin.y);
				basePoints[0] = NSMakePoint( rect.origin.x - (((rect.size.height ) /2) -1), rect.origin.y + rect.size.height);
				basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
				basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
				
				//Add Points to Path
				[path appendBezierPathWithPoints: basePoints count: 4];
				
				//Fill Path
				if(!highlighted) {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 90];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowPushedGradient] drawInBezierPath: path angle: 90];
				}
				
				//Create Arrow Glyph
				NSBezierPath *arrow = [[NSBezierPath alloc] init];
				
				NSPoint points[3];
				points[0] = NSMakePoint( rect.origin.x + (rect.size.width /2) -3, rect.size.height /2);
				points[1] = NSMakePoint( rect.origin.x + (rect.size.height /2) +3, (rect.size.height /2) +3.5f);
				points[2] = NSMakePoint( rect.origin.x + (rect.size.height /2) +3, (rect.size.height /2) -3.5f);
				
				[arrow appendBezierPathWithPoints: points count: 3];
				
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				[arrow fill];
				
				//Create Devider Line
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				
				[NSBezierPath strokeLineFromPoint: NSMakePoint(rect.origin.x + rect.size.width -.5f, rect.origin.y)
										  toPoint: NSMakePoint(rect.origin.x + rect.size.width -.5f, rect.origin.y + rect.size.height)];
				
				
			} else if([arrowPosition isEqualToString: @"Single"]) {
				
				NSBezierPath *path = [[NSBezierPath alloc] init];
				NSPoint basePoints[4];
				
				[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.origin.x + (rect.size.width -2) + ((rect.size.height ) /2), (rect.origin.y  + ((rect.size.height ) /2) ))
												 radius: (rect.size.height ) /2
											 startAngle: 90
											   endAngle: 270];
				
				//Add the rest of the points
				basePoints[2] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
				basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y);
				basePoints[0] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
				basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
				
				[path appendBezierPathWithPoints: basePoints count: 4];
				
				//Fill Path
				if(!highlighted) {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 90];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowPushedGradient] drawInBezierPath: path angle: 90];
				}
				
				//Create Arrow Glyph
				NSBezierPath *arrow = [[NSBezierPath alloc] init];
				
				NSPoint points[3];
				points[0] = NSMakePoint( rect.origin.x + (rect.size.width /2) -3, rect.size.height /2);
				points[1] = NSMakePoint( rect.origin.x + (rect.size.height /2) +3, (rect.size.height /2) +3.5f);
				points[2] = NSMakePoint( rect.origin.x + (rect.size.height /2) +3, (rect.size.height /2) -3.5f);
				
				[arrow appendBezierPathWithPoints: points count: 3];
				
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				[arrow fill];
				
			}
		}
	}
}

- (void)drawIncrementArrow:(BOOL)highlighted {
	NSRect rect = [self rectForPart: NSScrollerIncrementLine];
	if (!NSEqualRects(rect, NSZeroRect)) {
		if(![self isHoriz]) {
			
			if([arrowPosition isEqualToString: @"DoubleMax"]) {
				
				//Draw Increment Button
				if(!highlighted) {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInRect: rect angle: 0];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowPushedGradient] drawInRect: rect angle: 0];
				}
				
				//Create Arrow Glyph
				NSBezierPath *arrow = [[NSBezierPath alloc] init];
				
				NSPoint points[3];
				points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) +3);
				points[1] = NSMakePoint( (rect.size.width /2) +3.5f, rect.origin.y + (rect.size.height /2) -3);
				points[2] = NSMakePoint( (rect.size.width /2) -3.5f, rect.origin.y + (rect.size.height /2) -3);
				
				[arrow appendBezierPathWithPoints: points count: 3];
				
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				[arrow fill];
				
			} else if([arrowPosition isEqualToString: @"Single"]) {
				
				//Draw Decrement Button
				NSBezierPath *path = [[NSBezierPath alloc] init];
				NSPoint basePoints[4];
				
				//Add Notch
				[path appendBezierPathWithArcWithCenter: NSMakePoint((rect.size.width ) /2, (rect.origin.y  - ((rect.size.width ) /2) + 2))
												 radius: (rect.size.width ) /2
											 startAngle: 0
											   endAngle: 180];
				
				//Add the rest of the points
				basePoints[0] = NSMakePoint( rect.origin.x, rect.origin.y);
				basePoints[1] = NSMakePoint( rect.origin.x, rect.origin.y + rect.size.height);
				basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
				basePoints[3] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
				
				//Add Points to Path
				[path appendBezierPathWithPoints: basePoints count: 4];
				
				//Fill Path
				if(!highlighted) {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowPushedGradient] drawInBezierPath: path angle: 0];
				}
				
				//Create Arrow Glyph
				NSBezierPath *arrow = [[NSBezierPath alloc] init];
				
				NSPoint points[3];
				points[0] = NSMakePoint( rect.size.width /2, rect.origin.y + (rect.size.height /2) +3);
				points[1] = NSMakePoint( (rect.size.width /2) +3.5f, rect.origin.y + (rect.size.height /2) -3);
				points[2] = NSMakePoint( (rect.size.width /2) -3.5f, rect.origin.y + (rect.size.height /2) -3);
				
				[arrow appendBezierPathWithPoints: points count: 3];
				
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				[arrow fill];
				
			}
		} else {
			
			if([arrowPosition isEqualToString: @"DoubleMax"]) {
				
				//Draw Increment Button
				if(!highlighted) {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInRect: rect angle: 90];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowPushedGradient] drawInRect: rect angle: 90];
				}
				
				//Create Arrow Glyph
				NSBezierPath *arrow = [[NSBezierPath alloc] init];
				
				NSPoint points[3];
				points[0] = NSMakePoint( rect.origin.x + (rect.size.width /2) +3, rect.size.height /2);
				points[1] = NSMakePoint( rect.origin.x + (rect.size.height /2) -3, (rect.size.height /2) +3.5f);
				points[2] = NSMakePoint( rect.origin.x + (rect.size.height /2) -3, (rect.size.height /2) -3.5f);
				
				[arrow appendBezierPathWithPoints: points count: 3];
				
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				[arrow fill];
				
			} else if([arrowPosition isEqualToString: @"Single"]) {
				
				//Draw Decrement Button
				NSBezierPath *path = [[NSBezierPath alloc] init];
				NSPoint basePoints[4];
				
				//Add Notch
				[path appendBezierPathWithArcWithCenter: NSMakePoint(rect.origin.x - (((rect.size.height ) /2) -2), (rect.origin.y  + ((rect.size.height ) /2) ))
												 radius: (rect.size.height ) /2
											 startAngle: 270
											   endAngle: 90];
				
				//Add the rest of the points
				basePoints[3] = NSMakePoint( rect.origin.x - (((rect.size.height ) /2) -1), rect.origin.y);
				basePoints[0] = NSMakePoint( rect.origin.x - (((rect.size.height ) /2) -1), rect.origin.y + rect.size.height);
				basePoints[1] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
				basePoints[2] = NSMakePoint( rect.origin.x + rect.size.width, rect.origin.y);
				
				//Add Points to Path
				[path appendBezierPathWithPoints: basePoints count: 4];
				
				//Fill Path
				if(!highlighted) {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowNormalGradient] drawInBezierPath: path angle: 0];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerArrowPushedGradient] drawInBezierPath: path angle: 0];
				}
				
				//Create Arrow Glyph
				NSBezierPath *arrow = [[NSBezierPath alloc] init];
				
				NSPoint points[3];
				points[0] = NSMakePoint( rect.origin.x + (rect.size.width /2) +3, rect.size.height /2);
				points[1] = NSMakePoint( rect.origin.x + (rect.size.height /2) -3, (rect.size.height /2) +3.5f);
				points[2] = NSMakePoint( rect.origin.x + (rect.size.height /2) -3, (rect.size.height /2) -3.5f);
				
				[arrow appendBezierPathWithPoints: points count: 3];
				
				[[[[BGThemeManager keyedManager] themeForKey: [self themeKey]] scrollerStroke] set];
				[arrow fill];
				
			}
		}
	}
}


#pragma mark Helper Methods
//- (NSUsableScrollerParts)usableParts {
//	if([self arrowsPosition] != NSScrollerArrowsNone) {
//		if([self isHoriz]) {
//			//Now Figure out if we can actually show all parts
//			CGFloat arrowSpace = NSWidth([self rectForPart: NSScrollerIncrementLine]) + NSWidth([self rectForPart: NSScrollerDecrementLine]) +
//			BGCenterY([self rectForPart: NSScrollerIncrementLine]);
//			CGFloat knobSpace = NSWidth([self rectForPart: NSScrollerKnob]);
//			
//			if((arrowSpace + knobSpace) > NSWidth([self bounds])) {
//				
//				if(arrowSpace > NSWidth([self bounds])) {
//					
//					return NSNoScrollerParts;
//				} else {
//					
//					return NSOnlyScrollerArrows;
//				}
//			}
//			
//		} else {
//			
//			//Now Figure out if we can actually show all parts
//			CGFloat arrowSpace = NSHeight([self rectForPart: NSScrollerIncrementLine]) + NSHeight([self rectForPart: NSScrollerDecrementLine]) +
//			BGCenterX([self rectForPart: NSScrollerIncrementLine]);
//			CGFloat knobSpace = NSHeight([self rectForPart: NSScrollerKnob]);
//			
//			if((arrowSpace + knobSpace) > NSHeight([self bounds])) {
//				
//				if(arrowSpace > NSHeight([self bounds])) {
//					
//					return NSNoScrollerParts;
//				} else {
//					
//					return NSOnlyScrollerArrows;
//				}
//			}
//		}
//	}
//	
//	return NSAllScrollerParts;
//}

- (BOOL)isHoriz {
	
	if([self bounds].size.width > [self bounds].size.height) {
		
		return YES;
	}
	
	return NO;
}

@end
