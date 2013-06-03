//
//  BGHUDSegmentedCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 7/1/08.
//


#import "BGHUDSegmentedCell.h"
#import "AtoZAppKit.h"

@interface NSSegmentedCell (private)
-(NSRect)rectForSegment:(NSInteger)segment inFrame:(NSRect)frame;
@end

@implementation BGHUDSegmentedCell

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

-(id)copyWithZone:(NSZone *) zone {
	
	BGHUDSegmentedCell *copy = [super copyWithZone: zone];
	
	copy->themeKey = nil;
	[copy setThemeKey: [self themeKey]];
	
	return copy;
}

-(NSSegmentStyle)segmentStyle {
	
	return [super segmentStyle];
}

-(void)setSegmentStyle:(NSSegmentStyle) style {
	
	if(style == NSSegmentStyleSmallSquare || style == NSSegmentStyleRounded) {
		
		[super setSegmentStyle: style];
	}
}

- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view {
	NSBezierPath *border;
	
	switch ([self segmentStyle]) {
		default: // Silence uninitialized variable warnings
		case NSSegmentStyleSmallSquare:
			
			//Adjust frame for shadow
			frame.origin.x += 1.5f;
			frame.origin.y += 0.5f;
			frame.size.width -= 3;
			frame.size.height -= 5;
			
			border = [[NSBezierPath alloc] init];
			[border appendBezierPathWithRect: frame];
			
			break;
			
		case NSSegmentStyleRounded: //NSSegmentStyleTexturedRounded:
			
			//Adjust frame for shadow
			frame.origin.x += 1.5f;
			frame.origin.y += .5f;
			frame.size.width -= 3;
			frame.size.height -= 5;
			
			border = [[NSBezierPath alloc] init];
			
			[border appendBezierPathWithRoundedRect: frame
											xRadius: 4.0f yRadius: 4.0f];
			break;
	}
	
	//Draw Shadow + Border
	[NSGraphicsContext saveGraphicsState];
	if([self isEnabled]) {
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] dropShadow] set];
	}
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	[border stroke];
	[NSGraphicsContext restoreGraphicsState];
	
	
	//Draw Background (used as dividers)
	NSBezierPath *shadowPath = [[NSBezierPath alloc] init];
	switch ([self segmentStyle]) {
		default: // Silence uninitialized variable warnings
		case NSSegmentStyleSmallSquare:
			[shadowPath appendBezierPathWithRect:frame];
			break;
			
		case NSSegmentStyleRounded: //NSSegmentStyleTexturedRounded:
			[shadowPath appendBezierPathWithRoundedRect:frame
												xRadius:5.0f
												yRadius:5.0f];
			break;
	}
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	[shadowPath fill];
	
	//Draw Segments
	[NSGraphicsContext saveGraphicsState];
	int segCount = 0;
	while (segCount <= [self segmentCount] -1) {
		[self drawSegment: segCount inFrame: frame withView: view];
		segCount++;
	}
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawSegment:(NSInteger)segment inFrame:(NSRect)frame withView:(NSView *)view {
	//Calculate rect for this segment
	NSRect fillRect = [self rectForSegment: segment inFrame: frame];
	fillRect.origin.x += 0.5f;
	fillRect.origin.y += 0.5f;
	fillRect.size.width -= 1.0f;
	fillRect.size.height -= 1.0f;
	
	NSBezierPath *fillPath;
	
	switch ([self segmentStyle]) {
		default: // Silence uninitialized variable warnings
		case NSSegmentStyleSmallSquare:
		{
			if(segment == ([self segmentCount] -1)) {
				fillRect.size.width -= 3;
			}
			fillPath = [[NSBezierPath alloc] init];
			[fillPath appendBezierPathWithRect: fillRect];
		}
			break;
		case NSSegmentStyleRounded: //NSSegmentStyleTexturedRounded:
		{
			fillPath = [[NSBezierPath alloc] init];
			//If this is the first segment, draw left rounded corners
			if(segment == 0 && segment != ([self segmentCount] -1)) {
				[fillPath appendBezierPathWithRoundedRect: fillRect xRadius: 4.0f yRadius: 4.0f];
				
				//Setup our joining rect
				NSRect joinRect = fillRect;
				joinRect.origin.x += 4;
				joinRect.size.width -= 4;
				
				[fillPath appendBezierPathWithRect: joinRect];
			}
			//If this is the last segment, draw right rounded corners
			if (segment != 0 && segment == ([self segmentCount] -1)) {
				fillRect.size.width -= 3;
				[fillPath appendBezierPathWithRoundedRect: fillRect xRadius: 4.0f yRadius: 4.0f];
				
				//Setup our joining rect
				NSRect joinRect = fillRect;
				joinRect.size.width -= 4;
				
				[fillPath appendBezierPathWithRect: joinRect];
				
			}
			//If this is the only segment
			if (segment == 0 && segment == ([self segmentCount] -1)) {
				//if(![self hasText]) {
				fillRect.size.width -= 3;
				//}
				[fillPath appendBezierPathWithRoundedRect: fillRect xRadius: 4.0f yRadius: 4.0f];
			}
			//If this is a middle segment
			if (segment != 0 && segment != ([self segmentCount] -1)) {
				[fillPath appendBezierPathWithRect: fillRect];
			}
		}
			break;
	}
	
	//Fill our pathes
	NSGradient *gradient = nil;
	if([self isEnabled])
	{
		if([self selectedSegment] == segment) {
			gradient = [[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient];
		} else {
			
			gradient = [[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient];
		}
	}
	else {
		gradient = [[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledNormalGradient];
	}
	
	[gradient drawInBezierPath: fillPath angle: 90];
	
	[self drawInteriorForSegment: segment withFrame: fillRect];
}

-(void)drawInteriorForSegment:(NSInteger)segment withFrame:(NSRect)rect {
	
	NSAttributedString *newTitle;
	
	//if([self labelForSegment: segment] != nil) {
	
	NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] initWithCapacity: 0];
	
	[textAttributes setValue: [NSFont controlContentFontOfSize: [NSFont systemFontSizeForControlSize: [self controlSize]]] forKey: NSFontAttributeName];
	if([self isEnabled])
	{
		if([self selectedSegment] == segment) {
			[textAttributes setValue: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightTextColor] forKey: NSForegroundColorAttributeName];
		} else {
			[textAttributes setValue: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor] forKey: NSForegroundColorAttributeName];
		}
	}
	else {
		[textAttributes setValue:[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor] forKey: NSForegroundColorAttributeName];
	}
	
	
	if([self labelForSegment: segment]) {
		
		newTitle = [[NSAttributedString alloc] initWithString: [self labelForSegment: segment] attributes: textAttributes];
	} else {
		
		newTitle = [[NSAttributedString alloc] initWithString: @"" attributes: textAttributes];
	}
	
	//}
	
	NSRect textRect = rect;
	NSRect imageRect = rect;
	
	if([super imageForSegment: segment] != nil) {
		
		NSImage *image = [self imageForSegment: segment];
		[image setFlipped: YES];
		
		if([self imageScalingForSegment: segment] == NSImageScaleProportionallyDown) {
			
			CGFloat resizeRatio = (rect.size.height - 4) / [image size].height;
			
			[image setScalesWhenResized: YES];
			[image setSize: NSMakeSize([image size].width * resizeRatio, rect.size.height -4)];
		}
		
		if([self labelForSegment: segment] != nil && ![[self labelForSegment: segment] isEqualToString: @""]) {
			
			imageRect.origin.y += (BGCenterY(rect) - ([image size].height /2));
			imageRect.origin.x += (BGCenterX(rect) - (([image size].width + [newTitle size].width + 5) /2));
			imageRect.size.height = [image size].height;
			imageRect.size.width = [image size].width;
			
			textRect.origin.y += (BGCenterY(rect) - ([newTitle size].height /2));
			textRect.origin.x += imageRect.origin.x + [image size].width + 5;
			textRect.size.height = [newTitle size].height;
			textRect.size.width = [newTitle size].width;
			
			[image drawInRect: imageRect fromRect: NSZeroRect operation: NSCompositeSourceAtop fraction: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] alphaValue]];
			[newTitle drawInRect: textRect];
			
		} else {
			
			//Draw Image Alone
			imageRect.origin.y += (BGCenterY(rect) - ([image size].height /2));
			imageRect.origin.x += (BGCenterX(rect) - ([image size].width /2));
			imageRect.size.height = [image size].height;
			imageRect.size.width = [image size].width;
			
			[image drawInRect: imageRect fromRect: NSZeroRect operation: NSCompositeSourceAtop fraction: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] alphaValue]];
		}
	} else {
		
		textRect.origin.y += (BGCenterY(rect) - ([newTitle size].height /2));
		textRect.origin.x += (BGCenterX(rect) - ([newTitle size].width /2));
		textRect.size.height = [newTitle size].height;
		textRect.size.width = [newTitle size].width;
		
		if(textRect.origin.x < 3) { textRect.origin.x = 3; }
		
		[newTitle drawInRect: textRect];
	}
	
}

-(BOOL)hasText {
	
	int i = 0;
	BOOL flag = NO;
	
	while(i <= [self segmentCount] -1) {
		
		if([self labelForSegment: i] != nil && ![[self labelForSegment: i] isEqualToString: @""]) {
			
			flag = YES;
		}
		i++;
	}
	
	return flag;
}


@end
