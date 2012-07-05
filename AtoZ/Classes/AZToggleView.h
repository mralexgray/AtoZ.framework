//
//  ContentsView.h
//  CoreAnimationToggleLayer
//
//  Created by Tomaz Kragelj on 8.12.09.
//  Copyright (C) 2009 Gentle Bytes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "AtoZ.h"
#import "AZToggle.h"


/** The view that serves as Core Animation host.
 
 The user interface is composed using Core Animation layers using the following structure:
 
 @verbatim
 CALayer (root)
 |
 +--> CALayer (container)
 |
 +--> CALayer ("item name")
 |
 +--> CATextLayer (name)
 +--> ToggleLayer (toggle)
 @endverbatim
 
 The view also responds to user's interaction (only mouse is handled in this example) and updates the toggle status when the layer is clicked.   */

@interface AZToggleView : NSView {
	
	NSString	* font;
	CALayer		* containerLayer;
	CALayer		* rootLayer;
}
@end

