
//@interface  BGHUDProgressIndicator ()
//@property (nonatomic,retain) NSThread 	   *spinningAnimationThread;
//@property (nonatomic,retain) NSTimer	   *spinningAnimationTimer;
//@property (nonatomic,retain) NSBezierPath  *progressPath;
//@property (nonatomic,assign) NSInteger		spinningAnimationIndex;
//@property (nonatomic,assign) BOOL 			isAnimating;
//
//@end
#import "BGHUDProgressIndicator.h"

#define NSC NSColor
@interface NSColor (stub)
+ (NSC*)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;
@end
@implementation NSColor (stub)
+ (NSC*)r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a { return [NSC colorWithDeviceRed:r green:g blue:b alpha:a]; }
@end


#define DEFAULT_radius 			10
#define DEFAULT_angle 			30
#define DEFAULT_inset 			2
#define DEFAULT_stripeWidth 	7

#define DEFAULT_barColor 				[NSC r: 25.0/255.0 g: 29.0/255.0 b: 33.0/255.0 a:1.0]
#define DEFAULT_lighterProgressColor [NSC r:223.0/255.0 g:237.0/255.0 b:180.0/255.0 a:1.0]
#define DEFAULT_darkerProgressColor [NSC r:156.0/255.0 g:200.0/255.0 b: 84.0/255.0 a:1.0]
#define DEFAULT_lighterStripeColor	[NSC r:182.0/255.0 g:216.0/255.0 b: 86.0/255.0 a:1.0]
#define DEFAULT_darkerStripeColor 	[NSC r:126.0/255.0 g:187.0/255.0 b: 55.0/255.0 a:1.0]
#define DEFAULT_shadowColor 			[NSC r:223.0/255.0 g:238.0/255.0 b:181.0/255.0 a:1.0]


@interface BGHUDProgressIndicator ()
-(void)drawBezel;
-(void)drawProgressWithBounds:(NSRect)bounds;
-(void)drawStripesInBounds:(NSRect)bounds;
-(void)drawShadowInBounds:(NSRect)bounds;
-(NSBezierPath*)stripeWithOrigin:(NSPoint)origin bounds:(NSRect)frame;
@property (nonatomic) NSTimer* animator;
@property (readwrite) double progressOffset;
@end

@implementation BGHUDProgressIndicator

@synthesize progressOffset;

#pragma mark Accessors

-(void)setDoubleValue:(double)value {
    [super setDoubleValue:value];
    if (![self isDisplayedWhenStopped] && value == [self maxValue]) {
        [self stopAnimation:self];
    }
}

//-(NSTimer*)animator {
//    return animator;
//}

-(void)setAnimator:(NSTimer *)value {
	if (_animator != value) {
        [_animator invalidate];
        _animator = value;
    }
}

#pragma mark Initialization

-(id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.progressOffset = 0;
        self.animator = nil;
    }
    return self;
}

#pragma mark Memory

-(void)dealloc {
    self.progressOffset = 0;
    self.animator = nil;
	[super dealloc];
}

#pragma mark Drawing

-(void)drawShadowInBounds:(NSRect)bounds {
    [DEFAULT_shadowColor set];
    
    NSBezierPath* shadow = [NSBezierPath bezierPath];
    
    [shadow moveToPoint:NSMakePoint(0, 2)];
    [shadow lineToPoint:NSMakePoint(NSWidth(bounds), 2)];
    
    [shadow stroke];
}

-(NSBezierPath*)stripeWithOrigin:(NSPoint)origin bounds:(NSRect)frame {
    
    float height = frame.size.height;
    
    NSBezierPath* rect = [[NSBezierPath alloc] init];
    
    [rect moveToPoint:origin];
    [rect lineToPoint:NSMakePoint(origin.x+DEFAULT_stripeWidth, origin.y)];
    [rect lineToPoint:NSMakePoint(origin.x+DEFAULT_stripeWidth-8, origin.y+height)];
    [rect lineToPoint:NSMakePoint(origin.x-8, origin.y+height)];
    [rect lineToPoint:origin];
    
    return rect;
}

-(void)drawStripesInBounds:(NSRect)frame {
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:DEFAULT_lighterStripeColor endingColor:DEFAULT_darkerStripeColor];
    NSBezierPath* allStripes = [[NSBezierPath alloc] init];
    
    for (int i = 0; i <= frame.size.width/(2*DEFAULT_stripeWidth)+(2*DEFAULT_stripeWidth); i++) {
        NSBezierPath* stripe = [self stripeWithOrigin:NSMakePoint(i*2*DEFAULT_stripeWidth+self.progressOffset, DEFAULT_inset) bounds:frame];
        [allStripes appendBezierPath:stripe];
    }
    
    //clip
    NSBezierPath* clipPath = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:DEFAULT_radius yRadius:DEFAULT_radius];
    [clipPath addClip];
    [clipPath setClip];
    
    [gradient drawInBezierPath:allStripes angle:90];
    
}

-(void)drawBezel {
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    
    CGFloat maxX = NSMaxX(self.bounds);
    
    //white shadow
    NSBezierPath* shadow = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0.5, 0, self.bounds.size.width-1, self.bounds.size.height-1) xRadius:DEFAULT_radius yRadius:DEFAULT_radius];
    [NSBezierPath clipRect:NSMakeRect(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2)];
    [[NSColor colorWithCalibratedWhite:1.0 alpha:0.2] set];
    [shadow stroke];
    
    CGContextRestoreGState(context);
    
    //rounded rect
    NSBezierPath* roundedRect = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height-1) xRadius:DEFAULT_radius yRadius:DEFAULT_radius];
    [DEFAULT_barColor set];
    [roundedRect fill];
    
    //inner glow
    CGMutablePathRef glow = CGPathCreateMutable();
    CGPathMoveToPoint(glow, NULL, DEFAULT_radius, 0);
    CGPathAddLineToPoint(glow, NULL, maxX-DEFAULT_radius, 0);
    
    [[NSC r:17.0/255.0 g:20.0/255.0 b:23.0/255.0 a:1.0] set];
    CGContextAddPath(context, glow);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(glow);
}

-(void)drawProgressWithBounds:(NSRect)frame {
    NSBezierPath* bounds = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:DEFAULT_radius yRadius:DEFAULT_radius];
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:DEFAULT_lighterProgressColor endingColor:DEFAULT_darkerProgressColor];
    [gradient drawInBezierPath:bounds angle:90];
}

-(void)drawRect:(NSRect)dirtyRect {

	if ([self style] == NSProgressIndicatorBarStyle)
	{
		self.progressOffset = (self.progressOffset > (2*DEFAULT_stripeWidth)-1) ? 0 : ++self.progressOffset;
		
		float distance = [self maxValue]-[self minValue];
		float value = ([self doubleValue]) ? [self doubleValue]/distance : 0;
		
		[self drawBezel];
		
		if (value) {
			NSRect bounds = NSMakeRect(DEFAULT_inset, DEFAULT_inset, self.frame.size.width*value-2*DEFAULT_inset, (self.frame.size.height-2*DEFAULT_inset)-1);
			
			[self drawProgressWithBounds:bounds];
			[self drawStripesInBounds:bounds];
			[self drawShadowInBounds:bounds];
		}
	}
	else if ([self style] == NSProgressIndicatorSpinningStyle) {
		[self drawSpinningStyleIndicator];
	}

}

- (void) drawSpinningStyleIndicator
{


	if (!self.color) {
		Class c = NSClassFromString(@"AtoZ");
		[[NSBundle bundleForClass:c]load];
		[c sharedInstance];

//	SEL select = NSSelectorFromString(@"createImageFromView:")
//	NSInvocation *i = [NSInvocation invocationWithMethodSignature:<#(NSMethodSignature *)#>]

		self.color =   [(NSObject*)NSClassFromString(@"NSColor") performSelector:NSSelectorFromString(@"randomColor")];
//	redColor] performSelector:NSSelectorFromString(@"classProxy")] valueForKey:@"NSColor"] performSelector:NSSelectorFromString(@"randomColor")];
//	NSColor* colore =  [[[[NSColor redColor] performSelector:NSSelectorFromString(@"classProxy")] valueForKey:@"NSColor"] performSelector:NSSelectorFromString(@"randomColor")];
	//[RANDOMCOLOR;
//	NSImage *o = [[[self performSelector:NSSelectorFromString(@"classProxy")] valueForKey:@"NSImage"] performSelector:NSSelectorFromString(@"createImageFromView:") withObject:[self superview]];
//	o = [o croppedImage:self.frame];
//	NSC *backgorund = [o performSelector:NSSelectorFromString(@"quantized")];
	NSLog(@"Background color is %@",[_color performSelector:NSSelectorFromString(@"nameOfColor")]);
	}
//	[[@"Background color is" withString:backgorund.nameOfColor]log];
// ?:[NSColor whiteColor];// ? backgorund.contrastingForegroundColor : [NSColor whiteColor];

	[self.backgroundColor ?: [NSColor whiteColor] set];

	NSRect progressRect, rect; CGFloat radius;  NSBezierPath *bz;

	rect 	 = NSInsetRect([self bounds], 1.0, 1.0);
	radius 	 = rect.size.height / 2;
	bz		 = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
	[bz setLineWidth:2.0];
	[bz stroke];

	rect 	 = NSInsetRect(rect, 2.0, 2.0);
	radius 	 = rect.size.height / 2;
	bz	 	 = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
	[bz setLineWidth:1.0];	[bz addClip];
    
  	progressRect = NSMakeRect(	rect.origin.x,
								rect.origin.x,
								floor(rect.size.width * ([self doubleValue] / [self maxValue])),
								rect.size.height);
    
	NSRectFill(progressRect);

}


#pragma mark Actions

-(void)startAnimation:(id)sender {
	if (self.isHidden) [self setHidden:NO];
	if (!self.animator) {
        self.animator = [NSTimer scheduledTimerWithTimeInterval:1.0/30 target:self selector:@selector(activateAnimation:) userInfo:nil repeats:YES];
    }
}

-(void)stopAnimation:(id)sender {
	if (!self.isDisplayedWhenStopped) [self setHidden:YES];
    self.animator = nil;
}

-(void)activateAnimation:(NSTimer*)timer {
    [self setNeedsDisplay:YES];
}


@end

/*
- (void)drawRect:(NSRect)r
{

 	[[NSColor whiteColor] set];

	NSRect progressRect, rect; CGFloat radius;  NSBezierPath *bz;

	rect 	 = NSInsetRect([self bounds], 1.0, 1.0);
	radius 	 = rect.size.height / 2;
	bz		 = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
	[bz setLineWidth:2.0];
	[bz stroke];

	rect 	 = NSInsetRect(rect, 2.0, 2.0);
	radius 	 = rect.size.height / 2;
	bz	 	 = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
	[bz setLineWidth:1.0];	[bz addClip];
    
  	progressRect = NSMakeRect(	rect.origin.x,
								rect.origin.x,
								floor(rect.size.width * ([self doubleValue] / [self maxValue])),
								rect.size.height);
    
	NSRectFill(progressRect);
}
/*/

/*
@synthesize themeKey, spinningAnimationIndex, spinningAnimationThread, progressPath, spinningAnimationTimer, isAnimating;

#pragma mark Drawing Functions

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

- (void)_drawThemeBackground {
	NSRect frame = [self bounds];
	
	//Adjust rect based on size
	switch ([self controlSize]) {
		case NSRegularControlSize:
			frame.origin.y += 1.0f;
			frame.size.height -= 2.0f;
			break;
		case NSSmallControlSize:
			break;
	}
	
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:2.0f yRadius:2.0f];
	[path setClip];
	
	//Draw Fill
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] progressTrackGradient] drawInBezierPath:path angle:90];
	
	if(![self isIndeterminate]) {
		frame.size.width = (CGFloat)((frame.size.width / ([self maxValue] - [self minValue])) * ([self doubleValue] - [self minValue]));
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInBezierPath:[NSBezierPath bezierPathWithRect:frame] angle: 90];
	} else {
		//Setup Our Complex Path
		//Adjust Frame width
		frame.origin.x -= frame.size.height;
		frame.size.width += frame.size.height * 4;
		
		NSPoint position = NSMakePoint(frame.origin.x + 1, frame.origin.y + 1);
		
//		if(progressPath) { [progressPath release];}
		progressPath = progressPath ?: [[NSBezierPath alloc] init];
		
		CGFloat step = (frame.size.height / 4)*4;
		CGFloat double_step = step * 2;
		while(position.x <= (frame.origin.x + frame.size.width)) {
			[progressPath moveToPoint: NSMakePoint(position.x,					position.y)];
			[progressPath lineToPoint: NSMakePoint(position.x + step,			position.y)];
			[progressPath lineToPoint: NSMakePoint(position.x + double_step,	position.y + step)];
			[progressPath lineToPoint: NSMakePoint(position.x + step,			position.y + step)];
			[progressPath closePath];
			position.x += double_step;
		}
	}
	
	//Draw border
	[NSGraphicsContext saveGraphicsState];
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
}

- (void)_drawThemeProgressArea:(BOOL)flag {
	NSRect frame = [self bounds];
	
	//Adjust rect based on size
	switch ([self controlSize]) {
		case NSRegularControlSize:
			frame.origin.y += 1.0f;
			frame.size.height -= 2.0f;
			break;
		case NSSmallControlSize:
			break;
	}
	
	if([self isIndeterminate]) {
		//Setup Cliping Rect
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1, 1) xRadius:2.0f yRadius:2.0f];
		[path setClip];
		
		//Fill Background
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInRect: frame angle: 90];
		
		//Get the animation index (private)
		unsigned int animationIndex = 0;
		animationIndex = (unsigned int)object_getIvar(self, _animationIndex);
//		animationIndex = [[self valueForKey:@"animationIndex"]intValue];
//		Ivar u = object_getIvar( self, _animationIndex);//, (void **)&animationIndex );
		animationIndex %= 32;

		//Create XFormation
		NSAffineTransform *trans = [NSAffineTransform transform];
		[trans translateXBy:animationIndex - 16 yBy: 0];
		
		//Apply XForm to path
		NSBezierPath *newPath = [trans transformBezierPath: progressPath];
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInBezierPath: newPath angle: 90];
		
	} else {
		
		
	}
}

#define NUM_FINS 12

- (void)drawSpinningStyleIndicator {
    // Determine size based on current bounds
    NSSize size = [self bounds].size;
    float theMaxSize = MIN(size.width,size.height);
	
	[NSGraphicsContext saveGraphicsState];
    CGContextRef currentContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
    // Move the CTM so 0,0 is at the center of our bounds
    CGContextTranslateCTM(currentContext,[self bounds].size.width/2,[self bounds].size.height/2);
	
	NSColor *foreColor = [[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor];
	float alpha = [[[BGThemeManager keyedManager] themeForKey: self.themeKey] alphaValue];
	
    if ([self isIndeterminate]) {
        CGContextRotateCTM(currentContext, M_PI * 2.0f * spinningAnimationIndex / NUM_FINS);
		
        NSBezierPath *path = [[NSBezierPath alloc] init];
        float lineWidth = 0.0859375 * theMaxSize; // should be 2.75 for 32x32
        float lineStart = 0.234375 * theMaxSize; // should be 7.5 for 32x32
        float lineEnd = 0.421875 * theMaxSize;  // should be 13.5 for 32x32
        [path setLineWidth:lineWidth];
        [path setLineCapStyle:NSRoundLineCapStyle];
        [path moveToPoint:NSMakePoint(0,lineStart)];
        [path lineToPoint:NSMakePoint(0,lineEnd)];

		int i;
        for (i = 0; i < NUM_FINS; i++) {
			[[foreColor colorWithAlphaComponent:alpha] set];
            [path stroke];
            CGContextRotateCTM(currentContext, -M_PI * 2.0f/NUM_FINS);
            alpha -= 1.0/NUM_FINS;
        }
//        [path release];
    }
    else {
        float lineWidth = 1 + (0.01 * theMaxSize);
        float circleRadius = (theMaxSize - lineWidth) / 2.1;
        NSPoint circleCenter = NSMakePoint(0, 0);
        [[foreColor colorWithAlphaComponent:alpha] set];
        NSBezierPath *path = [[NSBezierPath alloc] init];
        [path setLineWidth:lineWidth];
        [path appendBezierPathWithOvalInRect:NSMakeRect(-circleRadius, -circleRadius, circleRadius*2, circleRadius*2)];
        [path stroke];
//        [path release];
        path = [[NSBezierPath alloc] init];
        [path appendBezierPathWithArcWithCenter:circleCenter radius:circleRadius startAngle:90 endAngle:90-(360*([self doubleValue]/[self maxValue])) clockwise:YES];
        [path lineToPoint:circleCenter] ;
        [path fill];
//        [path release];
    }
	
    [NSGraphicsContext restoreGraphicsState];
}

- (void)drawRect:(NSRect)dirtyRect {
	if ([self style] == NSProgressIndicatorBarStyle) {
		[self _drawThemeBackground];
		[self _drawThemeProgressArea:YES];
	}
	else if ([self style] == NSProgressIndicatorSpinningStyle) {
		[self drawSpinningStyleIndicator];
	}
}

#pragma mark Helper Methods

//-(void)dealloc {
//	
//	[themeKey release];
//	[progressPath release];
//	[super dealloc];
//}


- (void)updateFrame:(NSTimer *)timer;
{
    if(spinningAnimationIndex < NUM_FINS) {
        spinningAnimationIndex++;
    }
    else {
        spinningAnimationIndex = 0;
    }
    
    if ([self usesThreadedAnimation]) {
        // draw now instead of waiting for setNeedsDisplay (that's the whole reason
        // we're animating from background thread)
        [self setNeedsDisplay:YES];
		[self display];
    }
    else {
        [self setNeedsDisplay:YES];
    }
}

- (void)animateInBackgroundThread
{
//	NSAutoreleasePool *animationPool = [[NSAutoreleasePool alloc] init];
	@autoreleasepool {

	// Set up the animation speed to subtly change with size > 32.
	// int animationDelay = 38000 + (2000 * ([self bounds].size.height / 32));
    
    // Set the rev per minute here
    int omega = 100; // RPM
    int animationDelay = 60*1000000/omega/NUM_FINS;
	int poolFlushCounter = 0;
    
	do {
		[self updateFrame:nil];
		usleep(animationDelay);
		poolFlushCounter++;
		if (poolFlushCounter > 256) {
			}//[animationPool drain];
			@autoreleasepool {

//			animationPool = [[NSAutoreleasePool alloc] init];
			poolFlushCounter = 0;
		}
	} while (![[NSThread currentThread] isCancelled]); 
    }
//	[animationPool release];
}

- (void)actuallyStopAnimation
{
    if (spinningAnimationThread) {
        // we were using threaded animation
		[spinningAnimationThread cancel];
		if (![spinningAnimationThread isFinished]) {
			[[NSRunLoop currentRunLoop] runMode:NSModalPanelRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
		}
//		[spinningAnimationThread release];
        spinningAnimationThread = nil;
	}
    else if (spinningAnimationTimer) {
        // we were using timer-based animation
        [spinningAnimationTimer invalidate];
//        [spinningAnimationTimer release];
        spinningAnimationTimer = nil;
    }
    [self setNeedsDisplay:YES];
}

- (void)actuallyStartAnimation
{
    // Just to be safe kill any existing timer.
    [self actuallyStopAnimation];
	
    if ([self window]) {
        // Why animate if not visible?  viewDidMoveToWindow will re-call this method when needed.
        if ([self usesThreadedAnimation]) {
            spinningAnimationThread = [[NSThread alloc] initWithTarget:self selector:@selector(animateInBackgroundThread) object:nil];
            [spinningAnimationThread start];
        }
        else {
            spinningAnimationTimer = [NSTimer timerWithTimeInterval:(NSTimeInterval)0.05
															  target:self
															selector:@selector(updateFrame:)
															userInfo:nil
															 repeats:YES];// retain];
            
            [[NSRunLoop currentRunLoop] addTimer:spinningAnimationTimer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] addTimer:spinningAnimationTimer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] addTimer:spinningAnimationTimer forMode:NSEventTrackingRunLoopMode];
        }
    }
}

- (void)startAnimation:(id)sender
{
    if ([self style] == NSProgressIndicatorSpinningStyle) {
		if (![self isIndeterminate]) return;
		if (isAnimating) return;
		
		if (![self isDisplayedWhenStopped])
			[self setHidden:NO];
		
		[self actuallyStartAnimation];
		isAnimating = YES;
	}
	else {
		[super startAnimation:sender];
	}
}

- (void)stopAnimation:(id)sender
{
    if ([self style] == NSProgressIndicatorSpinningStyle) {
		[self actuallyStopAnimation];
		isAnimating = NO;
		
		if (![self isDisplayedWhenStopped])
			[self setHidden:YES];
	}
	else {
		[super startAnimation:sender];
	}
}
@end
*/
