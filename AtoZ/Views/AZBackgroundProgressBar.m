//  AZBackgroundProgressBar.m
//  AtoZ
//  Created by Alex Gray on 8/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.

#import "AZBackgroundProgressBar.h"

//The number of pixels we phase every second
const CGF pixelsPerSecond = 40.0;
const CGF framesPerSecond = 10.0;

//@interface AZBackgroundProgressBar ()
//The number of pixels to translate right

//The time interval from the reference date when the progress bar was last phased. Used to update phase
//@property (NATOM, ASS) NSTimeInterval lastUpdate;
//@end

@interface AZBackgroundProgressBar ()
@property (NATOM,STRNG) NSBP *bp;
@property (NATOM		 ) BOOL  shouldAnimate;
@property (NATOM,  ASS) CGF   phase;
@end



@implementation AZBackgroundProgressBar

- (id) initWithFrame:(NSR)frame 	{	if (self!=[super initWithFrame:frame]) return nil;
	_shouldAnimate = YES;
	[NSThread detachNewThreadSelector:@selector(animate) toTarget:self withObject:nil];
	return self;
}
- (void) drawRect:	(NSR)rect 	{

	[self.bp = [NSBP diagonalLinesInRect:rect phase:self.phase] fillWithColor:self.primaryColor];
}
- (void) startProgressAnimation	{

	BOOL wasAlready 		= _shouldAnimate;
	self.shouldAnimate 	= YES;
	if (!wasAlready)	[NSThread detachNewThreadSelector:@selector(animate) toTarget:self withObject:nil];
}
- (void) stopProgressAnimation	{	self.shouldAnimate = NO;	}
- (void) animate						{	@autoreleasepool {		// animate

		while (_shouldAnimate) {	[self stepAnimation:nil];
											self.needsDisplay = YES;
											[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.04]];	}
}	}
- (void) stepAnimation:(NST*)t	{	self.phase += pixelsPerSecond / framesPerSecond;		//	[ball transformUsingAffineTransform:at];
																														//	[self checkCollision];
}

@end

/*- (void)checkCollision	{	NSRect ballRect = [ball bounds];	NSRect viewRect = [self bounds];
	if ( ballRect.origin.y < viewRect.origin.y ||
	(ballRect.origin.y + ballRect.size.height) > viewRect.size.height ) {
		dy = -dy;

		[at release];
		at = [[NSAffineTransform transform] retain];
		[at translateXBy:dx yBy:dy];
	} else if ( ballRect.origin.x < viewRect.origin.x ||
			   (ballRect.origin.x + ballRect.size.width) > viewRect.size.width ) {
		dx = -dx;

		[at release];
		at = [[NSAffineTransform transform] retain];
		[at translateXBy:dx yBy:dy];
	}
}

- (void)setDx:(float)_dx
{
	if ( dx < 0 )
		dx = -_dx;
	else
		dx = _dx;

	[at release];
	at = [[NSAffineTransform transform] retain];
	[at translateXBy:dx yBy:dy];
}

- (void)setDy:(float)_dy
{
	if ( dy < 0 )
		dy = -_dy;
	else
		dy = _dy;

	[at release];
	at = [[NSAffineTransform transform] retain];
	[at translateXBy:dx yBy:dy];
}
- (id)initWithFrame:(NSRect)frameRect
{
	if (!(self = [super initWithFrame:frameRect])) return nil;
	[self awakeFromNib];
	return self;
}
- (void) awakeFromNib
{
	shouldStop = NO;
	[self reactToBackdrop];
	[self startAnimation:nil];
}

- (void) reactToBackdrop {

	self.highContrast = NO;
//	NSIMG* i = [[self superview] snapshot];
//	[i openInPreview];
//	NSC* back = [i quantize][0];
//	onDark = [back isDark];
//	NSLog(@"analysing backdrop with image:%@   color:%@   isDark: %@", i, back, onDark);
}

- (BOOL)isFlipped { return YES;  }

- (NSC*) primaryColor { return _primaryColor ?: [NSColor colorWithCalibratedWhite:0.0 alpha:onDark ? .5 :0.06]; }

- (void)drawRect:(NSRect)dirtyRect
{
//	[NSGraphicsContext state:^{

		if (shouldStop) return;
		if (_highContrast) { NSRectFillWithColor(self.bounds,GRAY9); self.primaryColor = GRAY1; }

		NSR rect	  = dirtyRect;
		NSBP *bp 	  = [NSBP bezierPath];
		NSI numX 	  = ceil( rect.size.width / 25 );
		CGF bandWidth = 20;
		CGF h 		  = 0;
		CGF modPhase  = round(fmod(phase, rect.size.width));
		CGF lastX	 = -27 + modPhase - rect.size.width;
		
		for ( NSI i = NEG(numX); i < numX; i++ ) {
			[bp moveToPoint:NSMakePoint( lastX + .5, 			rect.size.height + .5 - h )];
			[bp lineToPoint:NSMakePoint( lastX + bandWidth + .5, 			   0 + .5 + h )];
			[bp lineToPoint:NSMakePoint( lastX + bandWidth + bandWidth + .5,   0 + .5 + h )];
			[bp lineToPoint:NSMakePoint( lastX + bandWidth +.5, rect.size.height + .5 - h )];
			[bp lineToPoint:NSMakePoint( lastX + .5, 			rect.size.height + .5 - h )];
			lastX += bandWidth * 2 - 1;
		}
		[self.primaryColor set];
		[bp fill];
//	}];
}

//FIXME: It would be more reliable to use an NSTimer here
- (void)doAnimation
{
	if (shouldStop)	return;
	phase += pixelsPerSecond / framesPerSecond;
	[self setNeedsDisplay:YES];
//	[self performSelector:@selector(doAnimation) withObject:nil afterDelay: 1 / framesPerSecond];
}
- (IBAction)startAnimation:(id)sender
{
	shouldStop = NO;
	[NSThread mainThread]pe
	[self performSelector:@selector(doAnimation) withObject:nil afterDelay: 1 / framesPerSecond];
}
- (IBAction)stopAnimation:(id)sender
{
	shouldStop = YES;
	[self display];
	//-display instead of -setNeedsDisplay: because the main thread may be blocked immediately after this call, so the drawing has to be done *now*
}
*/
