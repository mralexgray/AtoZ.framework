//
//  AZProgressIndicator.m
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZProgressIndicator.h"
#import <objc/runtime.h>

@interface AZProgressIndicator (PrivateBusiness)
- (void)makeIndeterminatePole;
@end


@implementation AZProgressIndicator

@synthesize doubleValue, maxValue;
@synthesize cornerRadius;
@synthesize isIndeterminate;
@synthesize usesThreadedAnimation;
@synthesize shadowBlur, shadowColor;
@synthesize progressText, fontSize;
@synthesize progressHolderColor, progressColor;
@synthesize backgroundTextColor, frontTextColor;


- (id)initWithFrame:(NSRect)frameRect {
	id superInit = [super initWithFrame:frameRect];
	if (superInit) {
		[self setMaxValue: 100.0];
		[self setCornerRadius: 15];
		[self setFontSize: 11];
		[self setProgressTextAlign: 2];
		[self setProgressHolderColor: [NSColor colorWithCalibratedWhite:1	 alpha: 0.500]];
		[self setProgressColor: [NSColor randomColor]];//[NSColor colorWithCalibratedRed:0.076 green:0.076 blue:0.071 alpha:1.000]];
		[self setBackgroundTextColor: [NSColor colorWithCalibratedWhite:0 alpha:1]];
		[self setFrontTextColor: [NSColor colorWithCalibratedWhite:1 alpha:1]];
		[self setShadowColor: [NSColor colorWithCalibratedWhite:0.160 alpha: 0.300]];
		[self setShadowBlur: 4.0];
		
		 [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(cycle) userInfo:nil repeats:YES];	
		_step = 0;
	}
	
	return superInit;
}

-(void) cycle {
	[self setProgressColor:[NSColor randomColor]];
	[self setNeedsDisplay:YES];
}
- (void)drawRect:(NSRect)dirtyRect {
	if (NSEqualRects(dirtyRect, NSZeroRect)) {return;}
	[NSGraphicsContext saveGraphicsState];
	NSRect frame = NSInsetRect(dirtyRect,0,0);
	frame.size.height -= 1;
	NSRect progress = frame;
	NSRect progressInset = progress;
	indeterminateRect = frame;
	progressInset.origin.y -= 1.5;
	progress.size.width = (frame.size.width / maxValue) * doubleValue;
	progressInset.size.width = (frame.size.width / maxValue) * doubleValue;

	/* RAIL */
	NSBezierPath *framePath = [NSBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius];	
	[[self progressHolderColor] setFill];
	[framePath fill];
	
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: [self shadowColor]];
	[shadow setShadowBlurRadius: [self shadowBlur]];
	[shadow setShadowOffset: NSMakeSize( 0, 0)];
	[framePath fillWithInnerShadow: shadow];
	[framePath addClip];
	
	if (![self isIndeterminate]) {
		/* LOWER TEXT */
		NSString *string = [self progressText];
		NSFont *font = [NSFont labelFontOfSize: [self fontSize]];
		NSDictionary *attributes = @{NSForegroundColorAttributeName: backgroundTextColor,
									NSFontAttributeName: font};
		NSSize size = [string sizeWithAttributes:attributes];
		[string drawInRect:NSOffsetRect(dirtyRect, [self alignTextOnProgress:dirtyRect fontSize:size], -dirtyRect.size.height / 2 + size.height / 2) withAttributes:attributes];
	}
	
	
	if (![self isIndeterminate]) {
		/* PROGRESS */
		NSBezierPath *progressPath = [NSBezierPath bezierPathWithRoundedRect:progress cornerRadius:cornerRadius];
//		[[self progressColor] set];
		NSColor *color = [progressColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		float oldhue =  ( [color hueComponent] <= .05 ? [color hueComponent] + .05 : [color hueComponent] - .05 );
					   
		NSColor *acolor = [NSColor colorWithDeviceHue:oldhue saturation:.9f brightness:.8f alpha:1.f];
		self.progressColor = acolor;
		[acolor set];
//		[[NSColor randomColor]set];
		[progressPath fill];
		[progressPath addClip];
//		[acolor release];

		/* PROGRESS INSET */
		NSBezierPath *progressInsetPath = [NSBezierPath bezierPathWithRoundedRect:progressInset cornerRadius:cornerRadius];
		NSGradient *backgroundAlphaGradient = [[NSGradient alloc] initWithColorsAndLocations:
										  [NSColor colorWithCalibratedWhite: 1.0 alpha:0.350], 0.1f, 
										  [NSColor colorWithCalibratedWhite: 1.0 alpha:0.000], 0.6f, 
										  nil];
		[backgroundAlphaGradient drawInBezierPath:progressPath angle: -90];
		[[NSColor colorWithCalibratedWhite: 1.0 alpha:0.400] setStroke];
		[progressInsetPath setLineWidth: 1];
		[progressInsetPath stroke];

	} else {
		indeterminateRect.origin.x -= [self frame].size.height - _step ;
		indeterminateRect.size.width += [self frame].size.height;
		
		if (_step > [self frame].size.height ) {
			_step = 0;
		}
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:indeterminateRect cornerRadius:cornerRadius];
		[path addClip];

		[_indeterminateImage drawInRect:indeterminateRect fromRect:NSMakeRect(0, 0, [_indeterminateImage size].width, [_indeterminateImage size].height) operation:NSCompositeSourceIn fraction:1];
		NSGradient *agradient = [[NSGradient alloc] initWithColorsAndLocations:
								 [NSColor colorWithCalibratedWhite:1 alpha: 0.300],0.0,
								 [NSColor colorWithCalibratedWhite:1 alpha: 0.000],0.6,
								 nil];
		[agradient drawInBezierPath:path angle: -90];
		
		NSShadow *shadowInd = [[NSShadow alloc] init];
		[shadowInd setShadowColor: [self shadowColor]];
		[shadowInd setShadowBlurRadius: [self shadowBlur]];
		[shadowInd setShadowOffset: NSMakeSize( 0, 0)];
		[path fillWithInnerShadow: shadowInd];
	}

	
	
	if (![self isIndeterminate]) {
		/* UPPER TEXT */
		NSString *stringInProgress = [self progressText];
		NSFont *fontInProgress = [NSFont labelFontOfSize: [self fontSize]];
		NSDictionary *attributesInProgress = @{NSForegroundColorAttributeName: frontTextColor,
									NSFontAttributeName: fontInProgress};
		NSSize sizeInProgress = [stringInProgress sizeWithAttributes:attributesInProgress];
		[stringInProgress drawInRect:NSOffsetRect(frame, [self alignTextOnProgress:frame fontSize:sizeInProgress], -frame.size.height / 2 + sizeInProgress.height / 2) withAttributes:attributesInProgress];
	}

	
	[NSGraphicsContext restoreGraphicsState];
}


- (void)makeIndeterminatePole {
	_indeterminateImage2 = [[NSImage alloc] initWithSize:NSMakeSize([self frame].size.height, [self frame].size.height)];
	[_indeterminateImage2 setTemplate:YES];
	
	[_indeterminateImage2 lockFocus];
	NSRect zigZag = NSMakeRect(0, 0, [_indeterminateImage2 size].height, [_indeterminateImage2 size].height);
	NSBezierPath *lineOne = [NSBezierPath bezierPath];
	NSBezierPath *lineTwo = [NSBezierPath bezierPath];
	NSBezierPath *lineThree = [NSBezierPath bezierPath];
	
	[lineOne moveToPoint: NSMakePoint(0, 0)];
	[lineOne lineToPoint: NSMakePoint(0, zigZag.size.height)];
	[lineOne lineToPoint: NSMakePoint((zigZag.size.width / 2) * 1, zigZag.size.height)];
	[lineOne closePath];
	[[self progressHolderColor] set];
	[lineOne fill];
	

	[lineTwo moveToPoint: NSMakePoint((zigZag.size.width / 2) * 1, zigZag.size.height)];
	[lineTwo lineToPoint: NSMakePoint((zigZag.size.width / 2) * 2, zigZag.size.height)];
	[lineTwo lineToPoint: NSMakePoint((zigZag.size.width / 2) * 1, 0)];
	[lineTwo lineToPoint: NSMakePoint(0, 0)];
	[lineTwo closePath];
	[[self progressColor] set];
	[lineTwo fill];
	
	
	[lineThree moveToPoint: NSMakePoint((zigZag.size.width / 2) * 2, zigZag.size.height)];
	[lineThree lineToPoint: NSMakePoint((zigZag.size.width / 2) * 2, 0)];
	[lineThree lineToPoint: NSMakePoint((zigZag.size.width / 2) * 1, 0)];
	[lineThree closePath];
	[[self progressHolderColor] set];
	[lineThree fill];
	[_indeterminateImage2 unlockFocus];
	
	
	
	_indeterminateImage = [[NSImage alloc] initWithSize:NSMakeSize(20,20)];//[self frame].size.width, [self frame].size.height)];
	[_indeterminateImage setTemplate:YES];
	
	[_indeterminateImage lockFocus];
	[_indeterminateImage setBackgroundColor: [NSColor redColor]];
	int max = [self frame].size.width / [self frame].size.height;
	
	for (int current=0; current < max + 1; current++) {
		[_indeterminateImage2 drawInRect:NSMakeRect(current * zigZag.size.height, 0, zigZag.size.height, zigZag.size.height)
								fromRect:zigZag
							   operation:NSCompositeSourceOver
								fraction:1];
	}
	
	[_indeterminateImage unlockFocus];
}


- (void)drawIndeterminate:(NSTimer*)theTimer { _step++; [self setNeedsDisplay:YES];}
- (float)alignTextOnProgress:(NSRect)rect fontSize:(NSSize)size {
	switch ([self progressTextAlignt]) {
		case 0:
			return 10;
			break;
		case 1:
			return rect.size.width - size.width - 10;
			break;
		default:
			return  rect.size.width / 2 - size.width / 2;
			break;
	}
}
- (void)setProgressTextAlign:(int)pos {
	switch (pos) {
		case 0:
			position = 0;
			break;
		case 1:
			position = 1;
			break;
		default:
			position = 2;
			break;
	}
}
- (int)progressTextAlignt {return position;}


- (void) startAnimation:(id)sender {
	
	if ([self window]) {
		[self makeIndeterminatePole];
		if (usesThreadedAnimation) {
            _animationThread = [[NSThread alloc] initWithTarget:self selector:@selector(animateInBackgroundThread) object:nil];
            [_animationThread start];
        } else {
			_timer = [NSTimer scheduledTimerWithTimeInterval:.05
												   target:self
												 selector:@selector(drawIndeterminate:)
												 userInfo:nil
												  repeats: YES];
			_animationStarted = YES;
		}
	}
}
- (void)stopAnimation:(id)sender {
	if (_animationThread) {
        // we were using threaded animation
		[_animationThread cancel];
		if (![_animationThread isFinished]) {
			[[NSRunLoop currentRunLoop] runMode:NSModalPanelRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
		}
        _animationThread = nil;
	} else if (isIndeterminate) {
		[_timer invalidate];
		_animationStarted = NO;
	}
}

- (void)setIsIndeterminate:(BOOL)aBool {
	isIndeterminate = aBool;
	if (!isIndeterminate && _animationStarted) {
		isIndeterminate = YES;
		[self stopAnimation:nil];
		isIndeterminate = NO;
	}
	[self setNeedsDisplay:YES];
}
- (BOOL)isIndeterminate { return isIndeterminate; }

- (void)animateInBackgroundThread
{
	@autoreleasepool {
		do {
			[NSThread sleepForTimeInterval: 0.05];
			NSLog(@"doing something in another thread");
			_step++; [self setNeedsDisplay:YES];
		} while (![[NSThread currentThread] isCancelled]); 
    
	}
}


- (void)setFrame:(NSRect)frameRect {
	[super setFrame:frameRect];
	[self makeIndeterminatePole];
}

@end
