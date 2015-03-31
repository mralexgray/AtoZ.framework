//
//  CoreAnimationView.h
//  CoreAnimationUpdateOnMainThread
//
//  Created by Patrick Geiller on 08/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

void DrawBluePrintInRectWithScale(NSR r,CGF gridSize);

@interface BlueprintView : NSView
@property  (NA) CGF gridSize;
@end

@interface IsometricView : NSView {
	CGGradientRef backgroundGradient;
	// Container layer for our text layers
	CALayer*	containerLayer;

}
@property (weak) IBOutlet NSView *rootLayer;
@property (weak) IBOutlet NSTextField *editorField;

@property (weak) IBOutlet NSMatrix *editorSelector;

- (IBAction)new:__ _
                              - (void)enableShadows:(BOOL)hasShadows;

- (IBAction)toggleShadows:__ _
                              - (IBAction)appearWithRotation:__ _
                              - (IBAction)appearWithTranslation:__ _
                              - (IBAction)appearWithScale:__ _
                              @end
