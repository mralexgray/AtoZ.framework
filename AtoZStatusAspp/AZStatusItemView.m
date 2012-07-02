//
//  CustomView.m
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import "AZStatusAppController.h"
#import "AZStatusItemView.h"


@implementation AZStatusItemView
@synthesize clicked = _clicked;

- (id)initWithFrame:(NSRect)frame controller:(AZStatusAppController *)ctrlr {
    if (self = [super initWithFrame:frame]) {
        controller = ctrlr; // deliberately weak reference.
		_clicked = NO;
		
		[self toggleSpin];
    }
    return self;
}


- (void) toggleSpin {

	if (indicator == nil) {
		indicator = [[NSProgressIndicator alloc]initWithFrame:NSInsetRect([self frame], 3, 3)];
		[indicator setStyle:NSProgressIndicatorSpinningStyle];
//		[indicator setHidden:YES];
		[self addSubview:indicator];
	}
	///if (indicator.isHidden) {
	//	[indicator setHidden:NO];
//	}///
//		/[indicator animator] setAlphaValue:1];
		[indicator startAnimation:self];
//	} el/se {
//		[(NSView*)indicator fadeOut];
//	}
}



- (void)dealloc
{
    controller = nil;
}


- (void)drawRect:(NSRect)rect {
    // Draw background if appropriate.
    if (_clicked) {
		NSColor *rando = RANDOMCOLOR;
		NSBezierPath *frame = [NSBezierPath bezierPathWithRect:[self frame]];
		[frame fillGradientFrom:rando.brighter to:rando.darker angle:270];


//        [[NSColor selectedMenuItemColor] set];
//        NSRectFill(rect);
    }

	if (NO) {
		// Draw some text, just to show how it's done.
		NSString *text = @"3"; // whatever you want

		NSColor *textColor = [NSColor controlTextColor];
		if (_clicked) {
			textColor = [NSColor selectedMenuItemTextColor];
		}

		NSFont *msgFont = [NSFont menuBarFontOfSize:15.0];
		NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
		[paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
		[paraStyle setAlignment:NSCenterTextAlignment];
		[paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
		NSMutableDictionary *msgAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										 msgFont, NSFontAttributeName,
										 textColor, NSForegroundColorAttributeName,
										 paraStyle, NSParagraphStyleAttributeName,
										 nil];

		NSSize msgSize = [text sizeWithAttributes:msgAttrs];
		NSRect msgRect = NSMakeRect(0, 0, msgSize.width, msgSize.height);
		msgRect.origin.x = ([self frame].size.width - msgSize.width) / 2.0;
		msgRect.origin.y = ([self frame].size.height - msgSize.height) / 2.0;

		[text drawInRect:msgRect withAttributes:msgAttrs];
	}
}


- (void)mouseDown:(NSEvent *)event
{

	NSRect frame = [[self window] frame];
    NSPoint pt = NSMakePoint(NSMidX(frame), NSMinY(frame));
    if (!_clicked) {
		[controller toggleAttachedWindowAtPoint:pt];
		_clicked = YES;
	}
	else {     [controller toggleAttachedWindowAtPoint:pt]; }
    [self setNeedsDisplay:YES];
}


@end
