//
//  AZPrismView.m
//
//
//  Created by Alex Gray on 10/15/12.
//
//

#import "AZPrismView.h"
#import <AtoZ/AtoZ.h>
@implementation AZPrismView

@synthesize nsBitmapImageRepObj, cgFloatRed, cgFloatRedUpdate, nsTimerRef;

- (id)initWithFrame:(NSRect)frame {	self = [super initWithFrame:frame]; if (self) {
	self.postsBoundsChangedNotifications = YES;
	[NSEvent addLocalMonitorForEventsMatchingMask:(int)NSViewBoundsDidChangeNotification handler:^NSEvent *(NSEvent *e){ [self setNeedsDisplay:YES]; return e; }];
	nsBitmapImageRepObj = [NSBitmapImageRep.alloc initWithBitmapDataPlanes:NULL
																  pixelsWide:self.width   pixelsHigh:self.height
															   bitsPerSample:8		samplesPerPixel:3
																	hasAlpha:NO				 isPlanar:NO
													 		  colorSpaceName:@"NSCalibratedRGBColorSpace"
													  			 bytesPerRow:0			bitsPerPixel:0];

	cgFloatRed = 1.0;	cgFloatRedUpdate = 0.02; 	[self startAnimation:self];	}   return self;
}

- (IBAction) startAnimation:(id)pId {
	nsTimerRef ?^{	[nsTimerRef invalidate]; nsTimerRef =nil; }() : nil;
	nsTimerRef = [NSTimer scheduledTimerWithTimeInterval:0.05
												  target:self
												selector:@selector(paintGradientBitmap)
												userInfo:NULL
												 repeats:YES];

} // end startAnimation

- (IBAction) stopAnimation:(id)pId {	[nsTimerRef invalidate]; 	nsTimerRef	= nil; } // end stopAnimation

- (void) paintGradientBitmap {
	// green and blue values are a function of their position within the nsRectFrameRect
	// red has the same value throughout the picture but changes value with each iteration
	cgFloatRed	+= cgFloatRedUpdate;
	if (cgFloatRed > 1){ cgFloatRed = 1; cgFloatRedUpdate = -cgFloatRedUpdate; cgFloatRed += cgFloatRedUpdate; }
	if (cgFloatRed < 0){ cgFloatRed	= 0; cgFloatRedUpdate = -cgFloatRedUpdate; cgFloatRed += cgFloatRedUpdate; }
	CGFloat zFloatFrameHeight = self.height;
	CGFloat zFloatFrameWidth  = self.width;		NSUInteger	zIntRed	= round(255.0 * cgFloatRed);
												NSInteger 	y;
												CGFloat   	zFloatY;
	for (y = 0; y < self.height; y++) {			zFloatY 	= (CGFloat)y;
												NSInteger 	x;
												CGFloat   	zFloatX;
		NSUInteger zIntBlue = round((255.0 / zFloatFrameHeight) * zFloatY);
		for (x = 0; x < self.width; x++) {		zFloatX 	= (CGFloat)x;
			NSUInteger zIntGreen = round((255.0 / zFloatFrameWidth) * zFloatX);
			NSUInteger zColourAry[3] = {zIntRed,zIntGreen,zIntBlue};
			[nsBitmapImageRepObj setPixel:zColourAry atX:x y:y];
		} // end for x
	} // end for y
	if ( !NSEqualRects(self.frame, [self.superview bounds])) self.frame = [[self superview]bounds];
	[self setNeedsDisplay:YES];
} // end paintGradientBitmap

- (void) drawRect:(NSRect)pRect {
	[NSGraphicsContext state:^{		[nsBitmapImageRepObj drawInRect:pRect]; }];
} // end drawRect


@end
