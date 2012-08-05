//
//  CoreAnimationView.h
//  CoreAnimationUpdateOnMainThread
//
//  Created by Patrick Geiller on 08/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@interface IsometricView : NSView {


	CGGradientRef backgroundGradient;
	// Container layer for our text layers
	CALayer*	containerLayer;

}
@property (weak) IBOutlet NSView *rootLayer;
@property (weak) IBOutlet NSTextField *editorField;

@property (weak) IBOutlet NSMatrix *editorSelector;

- (IBAction)new:(id)sender;
- (void)enableShadows:(BOOL)hasShadows;

- (IBAction)toggleShadows:(id)sender;
- (IBAction)appearWithRotation:(id)sender;
- (IBAction)appearWithTranslation:(id)sender;
- (IBAction)appearWithScale:(id)sender;


@end
