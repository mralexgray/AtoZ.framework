//
//  AZToggle.h
//  AtoZ
//
//  Created by Alex Gray on 7/4/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "AtoZ.h"
#import "AZToggleView.h"
/** Implements iPhone-like Core Animation toggle layer.
 
 The client can change the texts and toggle state. There's also a helper method that
 reverses the state that can be handy in certain situations.
 
 The layer uses the following layout:
 
 @verbatim
 CALayer (root)
 |
 +--> CALayer (onback)
 |    |
 |    +--> CATextLayer (text)
 |
 +--> CALayer (thumb)
 |
 +--> CALayer (offback)
 |
 +--> CATextLayer (text)
 @endverbatim  */

//@interface AZToggle : NSView

@interface GBToggleLayer : CALayer
{
	CALayer* thumbLayer;
	CALayer* onBackLayer;
	CALayer* offBackLayer;
	CATextLayer* onTextLayer;
	CATextLayer* offTextLayer;
	NSGradient* onBackGradient;
	NSGradient* offBackGradient;
	BOOL toggleState;
}


///////// @name State handling

/** Toggles the state from on to off or vice versa.  @see toggleState;  */
- (void) reverseToggleState;
/** Sets the toggle state.  @see reverseToggleState;  */
@property (assign) BOOL toggleState;
/** On state text.  @see offStateText;  */
@property (copy) NSString* onStateText;
/** Off state text.  @see onStateText;  */
@property (copy) NSString* offStateText;
@end

