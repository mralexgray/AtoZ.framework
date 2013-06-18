#import <AtoZ/AtoZ.h>
/*	Allows for an extremely flexible manipulation of a static representation of the window.
 Since it uses a visual representation of the window, the window cannot be interacted with while a transform is applied, nor is it automatically updated to reflect the window's state.
 EXAMPLE:
 CABA *opacity 			= [CABA animationWithKeyPath:@"opacity"];					opacity.toValue 		= @0;
 CABA *translation 		= [CABA animationWithKeyPath:@"transform.translation.y"];	translation.toValue 		= @(-50);
 CAAG *group 		 	= CAAG.animation;
 group.timingFunction = CAMEDIAEASY;
 group.animations 	 	= @[ opacity, translation ];
 group.duration 		 	= self.animationDuration;
 [self.window orderOutWithAnimation:group];															or

 [self.window setFrame:rect withDuration:self.animationDuration timing:nil];							or
 CAT3D transform 		= CATransform3DIdentity;
 transform.m34 			= -1.f / 700.f;	// Apply a perspective transform onto the layer.
 self.window.layer.transform = transform;
 CABA *animation 		= [CABA animationWithKeyPath:@"transform.rotation.x"]; 				// Do a barrel roll.
 animation.duration 	= 3;
 animation.toValue 		= @(2*M_PI);
 animation.timing		= CAMEDIAEASY;
 animation.delegate 	= self;											// Set the delegate on the animation so we know when to remove the fake window.
 [self.window.layer addAnimation:animation forKey:nil];

 which calls....
 - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag   { [self.window destroyTransformingWindow];  }

 Animation is done, so lets get back to our real window by destroying the fake one.
 Note this only needs to happen if we initiate the creation of the layer ourselves by referencing it,
 otherwise it is automatically destroyed for us, as mentioned above.
 This layer can be transformed as much as desired. As soon as the property is first used an image representation of the current window's state will be grabbed and used for the layer's contents.
 Because it is a static image, it will not reflect the state of the window if it changes.
 If the window needs to change content while still having a transformed state, call `-updateImageRepresentation` to update the backing image.
 Important note: This layer is optimized with a shadow path. If you need to change the bounds or the size of the layer, you will need to update the shadow path yourself to reflect this change.	*/
typedef CAL*(^CALAyerSetupBlock)(CAL* layer);
@interface CAWindowContentView : NSView
@end
@interface CAWindow : NSWindow
@property (nonatomic,assign,readonly) 	CALayer 				*layer;
@property (nonatomic,copy) 				CALAyerSetupBlock setupBlock;
@property (nonatomic,assign) 				BOOL 					fullScreen;
/* Destroys the layer and fake window. Only necessary for use if the layer is animated manually.
 If the convenience methods are used below, calling this is not necessary as it is done automatically. */
- (void) destroyTransformingWindow;
/*	Order a window out with an animation. The `animations` block is wrapped in a `CATransaction`, so implicit
 animations will be enabled. Pass in nil for the timing function to default to ease-in-out.
 The layer and the extra window will be destroyed automatically after the animation completes. */
- (void) orderOutWithDuration:(CFTI)d timing:(CAMTF*)tf animations:(void(^)(CAL *winLay))ani;
/* 	Order a window out with an animation, automatically cleaning up after completion. The delegate of the animation will be changed. */
- (void) orderOutWithAnimation:(CAA*)ani;
/* 	Make a window key and visible with an animation. The setup block will be performed with implicit animations
 disabled, so it is an ideal time to set the initial state for your animation. The `animations` block is wrapped
 in a `CATransaction`, so implicit animations will be enabled. Pass in nil for the timing function to default to ease-in-out.
 The layer and the extra window will be destroyed automatically after the animation completes. */
- (void)makeKeyAndOrderFrontWithDuration:(CFTI)dur timing:(CAMTF*)tf setup:(void (^)(CAL *winLa))setup animations:(void (^)(CAL *layer))anis;
/*	EXAMPLE:
 [self.window makeKeyAndOrderFrontWithDuration:self.animationDuration timing:nil setup:^(CALayer *layer) {

 Anything done in this setup block is performed without any animation.
 The layer will not be visible during this time so now is our chance to set initial values for opacity, transform, etc.
 layer.transform = CATransform3DMakeTranslation(0.f, -50., 0.f);
 layer.opacity = 0.f;													} animations:^(CALayer *layer) {
 Now we're actually animating. In order to make the transition as seamless as possible, we want to set the final values to
 their original states, so that when the fake window is removed there will be no discernible jump to that state.
 To change the default timing and duration, just wrap the animations in an NSAnimationContext.
 	layer.transform = CATransform3DIdentity;
	layer.opacity = 1.f;
 }];
 Make a window key and visible with an animation, automatically cleaning up after completion.
 The delegate of the animation will be changed.
 The opacity of the layer will be set to the passed in opacity before it is shown. */
- (void)makeKeyAndOrderFrontWithAnimation:(CAA*)animation initialOpacity:(CGF)opacity;
/*	Sets the window to the frame specified using a layer The animation behavior is the same as
 NSWindow's full-screen animation, which cross-fades between the initial and final state images.
 The layer and the extra window will be destroyed automatically after the animation completes. */
- (void)setFrame:(NSR)frameRect withDuration:(CFTI)dur timing:(CAMTF*)timing;
@end
@interface CAWindow()
/* When we want to move the window off-screen to take the screen shot, we want
 to make sure we aren't being constrained. Although the documentation does not
 state that it constrains windows when moved using -setFrame:display:, such is the case. */
@property (nonatomic, assign) BOOL 	disableConstrainedWindow;
@property (readonly) 			CGR 	shadowRect;
@property (nonatomic, strong) NSW 	*fullScreenWindow;
@property (nonatomic, strong) CAL 	*windowRepresentationLayer;
@end


/*	Copyright (c) 2013, Jonathan Willing. All rights reserved. 	Licensed under the MIT license <http://opensource.org/licenses/MIT> 	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and  to permit persons to whom the Software is furnished to do so, subject to the following conditions:  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
