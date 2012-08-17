//
//  ContentsView.h
//  CoreAnimationToggleLayer
//
//  Created by Tomaz Kragelj on 8.12.09.
//  Copyright (C) 2009 Gentle Bytes. All rights reserved.
//

#ifndef ah_retain
#if __has_feature(objc_arc)
#define ah_retain self
#define ah_dealloc self
#define release self
#define autorelease self
#else
#define ah_retain retain
#define ah_dealloc dealloc
#define __bridge
#endif
#endif

	//  Weak delegate support

#ifndef ah_weak
#import <Availability.h>
#if (__has_feature(objc_arc)) && \
((defined __IPHONE_OS_VERSION_MIN_REQUIRED && \
__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0) || \
(defined __MAC_OS_X_VERSION_MIN_REQUIRED && \
__MAC_OS_X_VERSION_MIN_REQUIRED > __MAC_10_7))
#define ah_weak weak
#define __ah_weak __weak
#else
#define ah_weak unsafe_unretained
#define __ah_weak __unsafe_unretained
#endif
#endif

	//  ARC Helper ends



#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
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
 
 The view also responds to user's interaction (only mouse is handled in this example) and
 updates the toggle status when the layer is clicked.
 */
@protocol AZToggleArrayViewDelegate;
@interface AZToggleArrayView : NSView
{
	CALayer* containerLayer;
	CALayer* rootLayer;

	@private

		id<AZToggleArrayViewDelegate> __ah_weak _delegate;

}
@property (nonatomic, ah_weak) IBOutlet id<AZToggleArrayViewDelegate> delegate;


@end

@protocol AZToggleArrayViewDelegate <NSObject>
@required
- (NSArray*)questionsForToggleView:(AZToggleArrayView *) view;
@optional
- (void)toggleStateDidChangeTo:(BOOL)state InToggleViewArray:(AZToggleArrayView *) view WithName:(NSString *)name;


@end




	//////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////
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
 @endverbatim
 */
@interface AZToggleControlLayer : CALayer
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

	//////////////////////////////////////////////////////////////////////////////////////////
	/// @name State handling
	//////////////////////////////////////////////////////////////////////////////////////////

/** Toggles the state from on to off or vice versa.

 @see toggleState;
 */
- (void) reverseToggleState;

/** Sets the toggle state.

 @see reverseToggleState;
 */
@property (assign) BOOL toggleState;

/** On state text.

 @see offStateText;
 */
@property (copy) NSString* onStateText;

/** Off state text.

 @see onStateText;
 */
@property (copy) NSString* offStateText;


@end
