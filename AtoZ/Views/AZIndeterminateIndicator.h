//
//  WhiteIntermProgIndicator.h
//  WhiteIntermProgIndicator
//
//  Created by Dallas Brown on 12/23/08.
//  http://www.CodeGenocide.com
//  Copyright 2008 Code Genocide. All rights reserved.
//
//  Based off of AMIndeterminateProgressIndicatorCell created by Andreas, version date 2007-04-03.
//  http://www.harmless.de
//  Copyright 2007 Andreas Mayer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZIndeterminateIndicator : NSCell {
//	double doubleValue;
//	NSTimeInterval animationDelay;
//	BOOL displayedWhenStopped;
//	BOOL spinning;
//	NSColor *_color;
	float redComponent;
	float greenComponent;
	float blueComponent;
	NSTimer *theTimer;
	NSControl *parentControl;
}

@property (retain, nonatomic) 	NSControl *parentControl;
@property (retain, nonatomic)	NSColor *color;
@property (assign) 				double doubleValue;
@property (assign) 				NSTimeInterval animationDelay;

@property (assign, getter = isDisplayedWhenStopped)	BOOL displayedWhenStopped;
@property (assign, getter = isSpinning) BOOL spinning;


- (void)animate:(NSTimer *)aTimer;


@end
