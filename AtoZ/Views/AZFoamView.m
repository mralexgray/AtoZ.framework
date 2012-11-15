
//  AZFoamView.m
//  AZLayerGrid

//  Created by Alex Gray on 7/24/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
#import "AZFoamView.h"
#import "AtoZ.h"

static inline double radians (double degrees) { return degrees * M_PI/180; }

@implementation AZFoamView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void) awakeFromNib
{
	CAL *l	= [self setupHostView];
	l.delegate = self;
	[l setNeedsDisplay];
}

void MyDrawColoredPattern (void *info, CGContextRef context) {

	NSColor *dot = [NSC colorWithDeviceHue:0 saturation:0 brightness:0.07 alpha:1.0];
    NSC* shadowColor = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:0.1];

    CGContextSetFillColorWithColor(context, [dot CGColor]);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, [shadowColor CGColor]);

    CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
    CGContextFillPath(context);

    CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
    CGContextFillPath(context);

}

//-(NSC*) patternColor {
//	NSColor *dot = [NSC colorWithDeviceHue:0 saturation:0 brightness:0.07 alpha:1.0];
//	NSC* shadowColor = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:0.1];
//
//	NSIMG *i = [[NSIMG alloc]initWithSize:self.frame.size];
//	[i lockFocus];
//	[dot set];
//	NSRectFill(self.frame);
//
//		CGContextSetFillColorWithColor(context, [dot CGColor]);
//		CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, [shadowColor CGColor]);
//
//		CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
//		CGContextFillPath(context);
//
//		CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
//		CGContextFillPath(context);
//
//

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)context {


	NSC*c = [NSColor colorWithDeviceHue:0 saturation:0 brightness:0.15 alpha:1.0];
	CGContextSetFillColorWithColor(context, [c CGColor]);
	CGContextFillRect(context, layer.bounds);

	static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };

	CGContextSaveGState(context);
	CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
	CGContextSetFillColorSpace(context, patternSpace);
	CGColorSpaceRelease(patternSpace);

	CGPatternRef pattern = CGPatternCreate(NULL,
										   layer.bounds,
										   CGAffineTransformIdentity,
										   24,
										   24,
										   kCGPatternTilingConstantSpacing,
										   true,
										   &callbacks);
	CGFloat alpha = 1.0;
	CGContextSetFillPattern(context, pattern, &alpha);
	CGPatternRelease(pattern);
	CGContextFillRect(context, self.bounds);
	CGContextRestoreGState(context);
}

- (void) drawRect:(NSRect)rect {
}
//
//	CGContextRef context = (CGContextRef) [AZGRAPHICSCTX graphicsPort];
//
//	[NSGraphicsContext drawInContext:context flipped:NO actions:^{
//		float patternX = 24.0;
//		float patternY = 24.0;
//		int repeatX = ceil(rect.size.width / patternX);
//		int repeatY = ceil(rect.size.height / patternY);
//
//		CGColorRef bgColor = [NSColor colorWithDeviceHue:0 saturation:0 brightness:0.15 alpha:1.0]
//		.CGColor;
//		CGContextSetFillColorWithColor(context, bgColor);
//		CGContextFillRect(context, rect);
//
//		for(int i = 0; i < repeatX; ++i) {
//
//			for(int j = 0; j < repeatY; ++j) {
//
//				float originX = rect.origin.x + (i * patternX);
//				float originY = rect.origin.y + (j * patternY);
//
//				CGColorRef dotColor = [NSColor colorWithDeviceHue:0 saturation:0 brightness:0.07 alpha:1.0].CGColor;
//				CGColorRef shadowColor = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:0.1].CGColor;
//
//				CGContextSetFillColorWithColor(context, dotColor);
//				CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor);
//
//				CGContextAddArc(context, originX + 3, originY + 3, 4, 0, radians(360), 0);
//				CGContextFillPath(context);
//
//				CGContextAddArc(context, originX + 16, originY + 16, 4, 0, radians(360), 0);
//				CGContextFillPath(context);
//
//			}
//
//		}
//		}];
//
//}

@end
