
//  AZBackgroundProgressBar.m
//  AtoZ

//  Created by Alex Gray on 8/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AZBackgroundProgressBar.h"

//The number of pixels we phase every second
const CGFloat pixelsPerSecond = 60.0;
const CGFloat framesPerSecond = 30.0;


@interface AZBackgroundProgressBar ()
//The number of pixels to translate right
@property (NATOM, ASS) CGFloat phase;

//The time interval from the reference date when the progress bar was last phased. Used to update phase
@property (NATOM, ASS) NSTimeInterval lastUpdate;
@end

@implementation AZBackgroundProgressBar
@synthesize shouldStop, phase, lastUpdate, onDark;

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
	[NSGraphicsContext state:^{

		if (shouldStop) return;
		if (_highContrast) { NSRectFillWithColor(self.bounds,GRAY9); self.primaryColor = GRAY1; }

		NSR rect      = dirtyRect;
		NSBP *bp 	  = [NSBP bezierPath];
		NSI numX 	  = ceil( rect.size.width / 25 );
		CGF bandWidth = 20;
		CGF h 		  = 0;
		CGF modPhase  = round(fmod(phase, rect.size.width));
		CGF lastX     = -27 + modPhase - rect.size.width;
		
		for ( NSI i = NEG(numX); i < numX; i++ ) {
			[bp moveToPoint:NSMakePoint( lastX + .5, 			rect.size.height + .5 - h )];
			[bp lineToPoint:NSMakePoint( lastX + bandWidth + .5, 			   0 + .5 + h )];
			[bp lineToPoint:NSMakePoint( lastX + bandWidth + bandWidth + .5,   0 + .5 + h )];
			[bp lineToPoint:NSMakePoint( lastX + bandWidth +.5, rect.size.height + .5 - h )];
			[bp lineToPoint:NSMakePoint( lastX + .5, 	        rect.size.height + .5 - h )];
			lastX += bandWidth * 2 - 1;
		}
		[self.primaryColor set];
		[bp fill];
	}];
}

//FIXME: It would be more reliable to use an NSTimer here
- (void)doAnimation
{
	if (shouldStop)	return;
	phase += pixelsPerSecond / framesPerSecond;
	[self display];
	[self performSelector:@selector(doAnimation) withObject:nil afterDelay: 1 / framesPerSecond];
}
- (IBAction)startAnimation:(id)sender
{
	shouldStop = NO;
	[self performSelector:@selector(doAnimation) withObject:nil afterDelay: 1 / framesPerSecond];
}
- (IBAction)stopAnimation:(id)sender
{
	shouldStop = YES;
	[self display];
	//-display instead of -setNeedsDisplay: because the main thread may be blocked immediately after this call, so the drawing has to be done *now*
}
@end
