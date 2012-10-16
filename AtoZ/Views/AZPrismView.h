//
//  AZPrismView.h
//  
//
//  Created by Alex Gray on 10/15/12.
//
//

#import <Cocoa/Cocoa.h>

@interface AZPrismView : NSView

@property (nonatomic, retain)  NSBitmapImageRep *nsBitmapImageRepObj;
//	NSRect	nsRectFrameRect
@property (nonatomic, assign) CGFloat	cgFloatRed, cgFloatRedUpdate;
@property (nonatomic, retain)  NSTimer	*nsTimerRef;

- (IBAction) startAnimation:(id)pId;
- (IBAction) stopAnimation:	(id)pId;

-(void) paintGradientBitmap;

@end
