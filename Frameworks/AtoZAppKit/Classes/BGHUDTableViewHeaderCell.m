//
//  BGHUDTableViewHeaderCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/17/08.
//


#import "BGHUDTableViewHeaderCell.h"

@interface NSTableHeaderCell (AppKitPrivate)
- (void)_drawSortIndicatorIfNecessaryWithFrame:(NSRect)arg1 inView:(id)arg2;
@end

@implementation BGHUDTableViewHeaderCell

@synthesize themeKey;

#pragma mark Drawing Functions

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	//[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

-(id)copyWithZone:(NSZone *) zone {
	
	BGHUDTableViewHeaderCell *copy = [super copyWithZone: zone];
	
	copy->themeKey = nil;
	[copy setThemeKey: [self themeKey]];
	
	return copy;
}

- (id)textColor {
	
	return [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor];
}

- (void)_drawThemeContents:(NSRect)frame highlighted:(BOOL)flag inView:(id)view {
	
	//Draw base layer
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableHeaderCellBorderColor] set];
	NSRectFill(frame);
	
	//Adjust fill layer
	//frame.origin.x += 1;	- Removed to fix Issue #31
	frame.size.width -= 1;
	frame.origin.y +=1;
	frame.size.height -= 2;
	
	if(flag) {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableHeaderCellSelectedFill] drawInRect: frame angle: 90];
	} else {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableHeaderCellNormalFill] drawInRect: frame angle: 90];
	}
	
	//Adjust so text aligns correctly
	frame.origin.x -= 1;
	frame.size.width += 1;
	frame.origin.y -= 1;
	frame.size.height += 2;
	
	// REMOVED - Enabling this line draws two sort arrows, frame alignment issue here.
	//			 Not needed since the Apple drawing routines seem to be updating sort
	//			 arrows fine.
	/*if ([self respondsToSelector:@selector(_drawSortIndicatorIfNecessaryWithFrame:inView:)])
		[super _drawSortIndicatorIfNecessaryWithFrame: frame inView: view];*/
	
	frame.origin.y += (NSMidY(frame) - ([[self font] pointSize] /2)) - 2;
	frame.origin.x += 3;
	
	
	
	[super drawInteriorWithFrame: frame inView: view];
}

- (void)drawSortIndicatorWithFrame:(NSRect) frame inView:(id) controlView ascending:(BOOL) ascFlag priority:(NSInteger) priInt {
	
	frame.origin.y -=1;
	frame.size.height += 2;
	
	if(priInt == 0) {
		
		NSRect arrowRect = [self sortIndicatorRectForBounds: frame];
		
		// Adjust Arrow rect
		arrowRect.size.width -= 2;
		arrowRect.size.height -= 1;
		
		NSBezierPath *arrow = [[NSBezierPath alloc] init];
		NSPoint points[3];
		
		if(ascFlag == NO) {
			// Re-center arrow
			arrowRect.origin.y -= 2;
			points[0] = NSMakePoint(NSMinX(arrowRect), NSMinY(arrowRect) +2);
			points[1] = NSMakePoint(NSMaxX(arrowRect), NSMinY(arrowRect) +2);
			points[2] = NSMakePoint(NSMidX(arrowRect), NSMaxY(arrowRect));
		} else {
			
			points[0] = NSMakePoint(NSMinX(arrowRect), NSMaxY(arrowRect) -2);
			points[1] = NSMakePoint(NSMaxX(arrowRect), NSMaxY(arrowRect) -2);
			points[2] = NSMakePoint(NSMidX(arrowRect), NSMinY(arrowRect));
		}
		
		[arrow appendBezierPathWithPoints: points count: 3];
		
		if([self isEnabled]) {
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor] set];
		} else {
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor] set];
		}
		
		[arrow fill];
	}
	
	frame.origin.y += 1;
	frame.size.height -= 2;
}

#pragma mark Helper Methods

@end
