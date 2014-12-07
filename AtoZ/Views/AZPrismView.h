//
//  AZPrismView.h
//  
//
//  Created by Alex Gray on 10/15/12.
//
//
#import <AppKit/AppKit.h>

@interface AZPrismView : NSView

@property (nonatomic)  NSBitmapImageRep *nsBitmapImageRepObj;
//	NSRect	nsRectFrameRect
@property (nonatomic) CGFloat	cgFloatRed, cgFloatRedUpdate;
@property (nonatomic)  NSTimer	*nsTimerRef;

- (IBAction) startAnimation:(id)pId;
- (IBAction) stopAnimation:	(id)pId;

- (void) paintGradientBitmap;

@end
