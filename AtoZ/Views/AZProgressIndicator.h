//
//  AZProgressIndicator.h
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtoZ.h"

@interface AZProgressIndicator : NSView {

	NSThread *_animationThread;
	int 		position;
	NSRect 	indeterminateRect;

@private
	int 	_step;
	NSTimer *_timer;
	NSImage *_indeterminateImage, *_indeterminateImage2;
	BOOL	_animationStarted;
	BOOL	_animationStartedThreaded;
	float 	_gradientWidth;
}

@property (nonatomic, assign) double 	doubleValue;
@property (nonatomic, assign) double 	maxValue;
@property (nonatomic, assign) double 	cornerRadius;
@property (nonatomic, assign) float 	fontSize;
@property (nonatomic, assign) float 	shadowBlur;
@property (nonatomic, assign) BOOL 		usesThreadedAnimation;
@property (nonatomic, retain) NSString 	*progressText;
@property (nonatomic, retain) NSColor 	*progressHolderColor;
@property (nonatomic, retain) NSColor 	*progressColor;
@property (nonatomic, retain) NSColor 	*backgroundTextColor;
@property (nonatomic, retain) NSColor 	*frontTextColor;
@property (nonatomic, retain) NSColor 	*shadowColor;
@property (nonatomic, assign, setter = setIsIndeterminate:) BOOL isIndeterminate;

- (void)	setProgressTextAlign:(int)pos;
- (int)		progressTextAlignt;
- (float)	alignTextOnProgress:(NSRect)rect fontSize:(NSSize)size;
- (void)	startAnimation:(id)sender;
- (void)	stopAnimation:(id)sender;
- (void)	animateInBackgroundThread;
@end
