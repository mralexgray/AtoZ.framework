//
//  Created by Ian Voyce on 02/12/2011.
//  Copyright (c) 2011 Ian Voyce. All rights reserved.

#import "StarLayer.h"
#import "AtoZ.h"
//#import <DrawKit/DKDrawKit.h>

@interface StarLayer ()
@property (RONLY) 		CALayer *root;
@property (STRNG) 	 	CALayer *star, *text;

@end

@implementation StarLayer
@dynamic color, outlineColor, spinState;


- (id)init {	return [self initWithFrame:[self.superlayer bounds]]; }

//-(id)initWithRect:(CGRect)rect
//{
//	if (!(self = [super init])) return nil;
//	_root 			= [CAL layer];
//	_star 			= [CAL layer];
//	_text 			= [CAL layer];
//	_root.delegate 	= self;
//	_root.frame 	= rect;
//	_root.arMASK 	= CASIZEABLE;
//	_root.NDOBC 	= YES;
//	[@[_star, _text] do:^(CAL *obj){
//		obj.frame		= AZMakeRectFromSize(rect.size);
//	 	obj.delegate	= self;
//		[obj setNeedsDisplay];
//		[_root addSublayer:obj];
//	}];
//	[self toggleSpin:AZOn];
//	[self addSublayer:_root];
//	[self setNeedsDisplay];
//	return self;
//}

+ (BOOL)needsDisplayForKey:(NSString *)key {

	BOOL result;
	if ([@[@"orient", @"anchorPoint", @"position", @"rotation",@"color"]containsObject:key]) {
		result = YES;
	}
	else result = [super needsDisplayForKey:key];
	NSLog(@"does need display for key:%@ : %@", key, StringFromBOOL(result));
	return result;
}

- (id < CAAction >)actionForKey:(NSString *)key {
	if ([self presentationLayer] != nil) {
		if ([key isEqualToString:@"color"]) {
			CABasicAnimation *anim = [CABasicAnimation
									  animationWithKeyPath:@"color"];
			anim.fromValue = [[self presentationLayer]
							  valueForKey:@"color"];
			return anim;
		}
	}

	return [super actionForKey:key];
}

//+ (BOOL)needsDisplayForKey:(NSString *)key
//{
//	BOOL result;
//	if ([@[@"color", @"outlineColor"] containsObject:key])		result = YES;
//	else  result = [super needsDisplayForKey:key];
//	NSLog(@"does need display for key:%@ : %@", key, StringFromBOOL(result));
//	return result;
//}


-(void) toggleSpin: (AZState)state
{
	if (self.spinState == state) return;
	if (state == AZOff || ( state > (AZState)100 && self.spinState == AZOn)) { [_star removeAllAnimations]; }
	else {
		CABA *animation = [CABA animationWithKeyPath:@"transform.rotation"];
		animation.duration		= 8.0;
		animation.repeatCount	= HUGE_VALF;
		animation.autoreverses	= NO;
		animation.fromValue		= @0;
		animation.toValue		= @(TWOPI);

		[_star addAnimation:animation forKey:@"rotation"];
	}
	self.spinState = state;
}
//
//-(NSC*) color{
//	return color = color ?: RANDOMCOLOR;
//}
////
//-(NSC*) outlineColor{
//	return WHITE;
//}

//-(void)setOrient:(AZWindowPosition)orient
//{
//	_orient = orient;
//	[self setNeedsDisplay];
//	[_text setNeedsDisplay];
//}

//+(NSSet*)keyPathsForValuesAffectingValueForKey:(NSString *)key
//{
//	NSSet *defaultPaths = [super keyPathsForValuesAffectingValueForKey:key];
//	if ([key isEqualToString:@"pixelsWide"] || [key isEqualToString:@"pixelsHigh"]) {
//		defaultPaths = [[defaultPaths mutableCopy] autorelease];
//		[(NSMutableSet *)defaultPaths addObject:@"scale"];
//		[(NSMutableSet *)defaultPaths addObject:@"image"];
//	}
//	return defaultPaths;

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//- (void)drawLayer:(CALayer *)theLayer
//		inContext:(CGContextRef)context 

		[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{

//		CGContextSaveGState(context);
//		CGContextSetFillColorWithColor(context, [[NSColor blackColor] CGColor]);
//		NSFont *font = [NSFont fontWithName:@"Helvetica" size:24.0];

		layer == _star ? ^{
			NSBP *pp = [self starburstInFrame:self.bounds withPoints:6];
//			pp.lineWidth = 5;
//			pp.lineJoinStyle =
			[NSShadow setShadowWithOffset:CGSizeMake(4, 4) blurRadius:4 color:[BLACK alpha:.79]];
			[self.outlineColor setFill];
			[pp fill];
			[NSShadow clearShadow];
			NSBP *smallP = [pp scaleToSize:AZInsetRect(_star.bounds, 6).size];// insetPathBy:6];
			[self.color setFill];
			[smallP fill];
		}() : layer == _text ? ^{

//			NSString *s = [NSS stringForPosition:self.orient];
			NSS*font = [AtoZ randomFontName];
//			[s drawInRect:AZCenteredRect(NSMakeSize(NSWidth(_text.frame),20), self.frame) withFontNamed:font andColor:WHITE];
		}() :
		 layer == self ? ^{
			[[NSBP bezierPathWithTriangleInRect:AZCenterRectOnPoint(AZRectFromDim(50), self.anchorPoint) orientation:0]drawWithFill:BLACK andStroke:WHITE];
		}() : nil;
	}];

	//		CGSize sz = [s sizeWithFont:font
	//				 constrainedToSize:theLayer.bounds.size
	//					 lineBreakMode:NSLineBreakByClipping];
	//		CGRect r = CGRectOffset(CGRectMake(0, 0, theLayer.bounds.size.width, sz.height), 0, (theLayer.bounds.size.height-sz.height)/2);
//			[s drawAtPoint:NSZeroPoint withAttributes:nil];//:NSInsetRect(theLayer.frame, 20, 20)
	//			 withFont:font
	//		lineBreakMode:NSLineBreakByClipping
	//			alignment:NSCenterTextAlignment];
//			CGContextRestoreGState(context);
	//		UIGraphicsPopContext();
	//		return;
//	}

//	CGContextSaveGState(context);
//	CGContextSetShadow(context, CGSizeMake(4, 4), 5);

//	CGContextSetFillColorWithColor(context, cgRANDOMCOLOR);
//	CGContextAddPath(context, r);
//	CGContextFillPath(context);

//	CGContextRestoreGState(context);
}

-(NSBP*) starburstInFrame:(NSR)frame {

 	return [self starburstInFrame:frame withPoints:60];
}

-(NSBP*) starburstInFrame:(NSR)frame withPoints:(NSUI)nPoints {

	nPoints = nPoints != 0 ? nPoints : 50;
	// CGRect frame = theLayer.frame;
	CGPoint offset = CGPointMake(frame.size.width/2, frame.size.height/2);
	int r1 = frame.size.width/2;
	int r2 = r1 - 20;
	CGMutablePathRef r = CGPathCreateMutable();
	for (float n=0; n < nPoints; n+=1)
	{
		int x1 = offset.x + sin((TWOPI/nPoints) * n) * r2;
		int y1 = offset.y + cos((TWOPI/nPoints) * n) * r2;
		if (n==0)
			CGPathMoveToPoint(r, NULL, x1, y1);
		else
			CGPathAddLineToPoint(r, NULL, x1, y1);
		int x2 = offset.x + sin((TWOPI/nPoints) * n+1) * r1;
		int y2 = offset.y + cos((TWOPI/nPoints) * n+1) * r1;
		CGPathAddLineToPoint(r, NULL, x2, y2);
		int x3 = offset.x + sin((TWOPI/nPoints) * n+2) * r2;
		int y3 = offset.y + cos((TWOPI/nPoints) * n+2) * r2;
		CGPathAddLineToPoint(r, NULL, x3, y3);
	}
	CGPathCloseSubpath(r);
	return [NSBP bezierPathWithCGPath:r];
}
@end
//-(void) setValue: (id)value forUndefinedKey: (NSS*)key
//{
//	[self associateValue:value withKey:[key UTF8String]];
//}
//
//-(id) valueForUndefinedKey: (NSS*)key
//{
//	return [self associatedValueForKey: key];
//}

//- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//
//	[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
//		NSRectFillWithColor(self.frame, RANDOMCOLOR);
//	}];
//	CGContextSetFillColorWithColor(ctx,
//								   [self.color CGColor]);
//	CGFloat radius = 100;
//	CGRect rect;
//	rect.size = CGSizeMake(radius, radius);
//	rect.origin.x = (self.bounds.size.width - radius) / 2;
//	rect.origin.y = (self.bounds.size.height - radius) / 2;
//	CGContextAddEllipseInRect(ctx, rect);
//	CGContextFillPath(ctx);
//}
