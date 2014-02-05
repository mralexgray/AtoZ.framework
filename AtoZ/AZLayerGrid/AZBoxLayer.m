//
//  AZBoxLayer.m
//  AtoZ
//
//  Created by Alex Gray on 7/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZBoxLayer.h"
//#import <AtoZ/AtoZ.h>

#define kCompositeIconHeight 155.0
#define kIconWidth 128.0
#define kFontHeight 25.0
#define kMargin 30.0

//
//CGFloat DegreesToRadians(CGFloat degrees)
//{
//	return degrees * M_PI / 180;
//}
//
//NSNumber* DegreesToNumber(CGFloat degrees)
//{
//	return [NSNumber numberWithFloat:
//			DegreesToRadians(degrees)];
//}

@implementation AZBoxLayer

@synthesize image;
@synthesize title;

- (id)initWithImage:(NSImage*)anImage title:(NSString*)iconTitle
{	
//	- (id)initWithImagePath:(NSString*)path title:(NSString*)iconTitle;
  if( ![super init] ) return nil;
	
	[self setImage:anImage];
	[self setTitle:iconTitle];
	
//	NSImage *image = [NSImage.alloc 
//					  initWithContentsOfFile:[self imagePath]];
	
//	NSData * imageData = [image TIFFRepresentation];
//	if(imageData)
//	{
//		CGImageRef imageRef;
//		CGImageSourceRef imageSource = 
//		CGImageSourceCreateWithData(
//									(CFDataRef)imageData,  NULL);
//		
//		imageRef = CGImageSourceCreateImageAtIndex(
//												   imageSource, 0, NULL);
//		
		imageLayer = [CALayer layer];
//		
		[imageLayer setFrame:
		 CGRectMake(0.0,
					kIconWidth + kMargin - kIconWidth, 
					kIconWidth, 
					kIconWidth)];

		[imageLayer setContents:(id)image];
		[self addSublayer:imageLayer];
//		
//		CFRelease(imageRef);
//	}
	
//	NSFont *font = [NSFont fontWithName:@"Helvetica" size:12];
	
	text = [CATextLayer layer];
	[text setString:[self title]];
	[text setFont:@"Helvetica"];//(id)font];
	[text setFontSize:12.0];
	[text setAlignmentMode:kCAAlignmentCenter];
	[text setFrame:CGRectMake(0.0, 
							  0.0, 
							  kIconWidth, 
							  kFontHeight)];
	
	[self addSublayer:text];
	
	closeLayer = [self closeBoxLayer];
	
	return self;
	
}

- (void)toggleShake;
{
	if( [self isRunning] )
	{
		[self stopShake];
	}
	else
	{
		[self startShake];
	}
}

- (BOOL)isRunning;
{
	return ([self animationForKey:@"rotate"] != nil);
}

- (void)startShake;
{
	[self addSublayer:closeLayer];
	// Tell the closeLayer to draw its contents which is
	// an 'X' to indicate a close box.
	[closeLayer setNeedsDisplay];
	[self addAnimation:[self shakeAnimation] forKey:@"rotate"];
}

- (void)stopShake;
{
	[closeLayer removeFromSuperlayer];
	[self removeAnimationForKey:@"rotate"];
}

- (CAAnimation*)shakeAnimation;
{
	CAKeyframeAnimation * animation;
	animation = [CAKeyframeAnimation 
				 animationWithKeyPath:@"transform.rotation.z"];
	[animation setDuration:0.15];
	[animation setRepeatCount:10000];
	
	// Try to get the animation to begin to start with a small offset
	// that will make it shake out of sync with other layers.
	srand([[NSDate date] timeIntervalSince1970]);
	float rand = (float)random();
	[animation setBeginTime:
	 CACurrentMediaTime() + rand * .0000000001];
	
	NSMutableArray *values = [NSMutableArray array];
	
	// Turn right
	[values addObject:DegreesToNumber(-2)];
	
	// Turn left
	[values addObject:DegreesToNumber(2)];
	
	// Turn right
	[values addObject:DegreesToNumber(-2)];	
	
	// Set the values for the animation
	[animation setValues:values];
	
	return animation;
}

-(CALayer*)closeBoxLayer;
{
	CGColorRef white = 
	CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0);
	CGColorRef black = 
	CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0);
	
	CALayer *layer = [CALayer layer];
	[layer setFrame:CGRectMake(0.0, 
							   kCompositeIconHeight - 30.0, 
							   30.0, 30.0)];
	
	[layer setBackgroundColor:black];
	[layer setShadowColor:black];
	[layer setShadowOpacity:1.0];
	[layer setShadowRadius:5.0];
	[layer setBorderColor:white];
	[layer setBorderWidth:3];
	[layer setCornerRadius:15];
	[layer setDelegate:self];
//	[layer retain];
	
	// Release our color refs
	CFRelease(white);
	CFRelease(black);
	
	return layer;
}

- (void)drawLayer:(CALayer *)layer
		inContext:(CGContextRef)context
{
	// Make sure the call is applying to our close
	// box layer
	if( layer == closeLayer )
	{
		// Create the pagh ref
		CGMutablePathRef path = CGPathCreateMutable();
		
		// Set our first point and add a line
		CGPathMoveToPoint(path,NULL,10.0f,10.f);
		CGPathAddLineToPoint(path, NULL, 20.0, 20.0);
		
		// Set our second point and add a line
		CGPathMoveToPoint(path,NULL,10.0f,20.f);
		CGPathAddLineToPoint(path, NULL, 20.0, 10.0);
		
		// Set the stroke color to white
		CGColorRef white =
		CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0);
		CGContextSetStrokeColorWithColor(context, white);
		CFRelease(white);
		
		// Begin drawing the path
		CGContextBeginPath(context);
		CGContextAddPath(context, path);
		
		// Set line width to 3.0 pixels
		CGContextSetLineWidth(context, 3.0);
		
		// Draw the path
		CGContextStrokePath(context);
		
		// release the path
		CFRelease(path);		
	}
}

@end
