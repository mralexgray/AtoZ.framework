//
//  MondoSwitch.h
//  CocoaMondoKit
//
//  Created by Matthieu Cormier on 12/7/09.
//  Copyright 2009 Preen and Prune Software and Design. All rights reserved.
//

#import <Cocoa/Cocoa.h>



// This class emulates a switch component.  Switches are used quite often
// in the iPhone interface but are not available on the Mac OS X platform.
//
// Apple does use a switch for the Time Machine interface but the control
// is not available in interface builder.

// A switch control is more natural in an iPhone interface than the Mac desktop.
// So, please don't abuse this control and replace all your checkboxes with
// switches.  Use common sense.  A good guideline is to use a switch for a 
// desktop application when the state of the switch has far reaching implications.
// For example: The switch disables or enables the core functionality of the application.

// Sizing note:
// The Time Machine Switch on 10.6.2 has a sizing of 93px wide and 27px height.
//                                   the internal switch is 40px wide or 

@class MondoSwitchButtonCALayer;

@interface MondoSwitch : NSView {

  NSGradient *_bgGradient;
  
  @private
    MondoSwitchButtonCALayer *buttonLayer;
    CALayer *mainLayer;
    BOOL on;
  
    id target;
    SEL action; 
}

@property(nonatomic, getter=isOn) BOOL on;

-(void)setOn:(BOOL)on animated:(BOOL)animated;

// FIXME: If an NSControl was extended instead of an NSView these definitions
// wouldn't be required.
@property(retain) id target;
@property SEL action;


@end
